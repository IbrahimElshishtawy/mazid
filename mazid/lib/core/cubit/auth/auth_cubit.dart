import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import 'auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit({required this.authService}) : super(AuthInitial());

  /// تسجيل مستخدم جديد
  Future<void> register({
    required String name,
    String? email,
    String? phone,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await authService.register(
        name: name,
        email: email ?? '',
        phone: phone ?? '',
        password: password,
      );

      if (user != null) {
        emit(Authenticated(user.id));
      } else {
        emit(AuthFailure(message: "Registration failed"));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  /// تسجيل الدخول بالبريد
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await authService.loginWithEmail(
        email: email,
        password: password,
      );

      if (user != null) {
        emit(Authenticated(user.id));
      } else {
        emit(AuthFailure(message: "Login failed"));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  /// إرسال OTP للهاتف
  Future<void> loginWithPhone(String phone) async {
    emit(AuthLoading());
    try {
      await authService.loginWithPhone(phone);
      emit(AuthOtpSent(phone));
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  /// التحقق من OTP
  Future<void> verifyPhoneOtp({
    required String phone,
    required String otp,
  }) async {
    emit(AuthLoading());
    try {
      final user = await authService.verifyPhoneOtp(phone: phone, otp: otp);
      if (user != null) {
        emit(Authenticated(user.id));
      } else {
        emit(AuthFailure(message: "OTP verification failed"));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    try {
      await authService.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  /// التحقق من حالة المصادقة
  Future<void> checkAuthStatus() async {
    final user = authService.currentUser();
    if (user != null) {
      emit(Authenticated(user.id));
    } else {
      emit(Unauthenticated());
    }
  }
}
