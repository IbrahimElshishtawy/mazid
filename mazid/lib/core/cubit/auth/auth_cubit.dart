import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
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
        emit(AuthFailure(message: "فشل إنشاء الحساب، حاول مرة أخرى"));
      }
    } on AuthException catch (e) {
      emit(AuthFailure(message: e.message)); // رسالة واضحة من السيرفر
    } catch (e) {
      emit(AuthFailure(message: "حدث خطأ غير متوقع أثناء التسجيل"));
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
        emit(
          AuthFailure(message: "البريد الإلكتروني أو كلمة المرور غير صحيحة"),
        );
      }
    } on AuthException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (e) {
      emit(
        AuthFailure(message: "تعذر تسجيل الدخول، تحقق من الشبكة وحاول مجددًا"),
      );
    }
  }

  /// إرسال OTP للهاتف
  Future<void> loginWithPhone(String phone) async {
    emit(AuthLoading());
    try {
      await authService.loginWithPhone(phone);
      emit(AuthOtpSent(phone));
    } on AuthException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (e) {
      emit(AuthFailure(message: "فشل إرسال رمز التحقق، حاول مرة أخرى"));
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
        emit(AuthFailure(message: "رمز التحقق غير صحيح"));
      }
    } on AuthException catch (e) {
      emit(AuthFailure(message: e.message));
    } catch (e) {
      emit(AuthFailure(message: "حدث خطأ أثناء التحقق من الرمز"));
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    try {
      await authService.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure(message: "تعذر تسجيل الخروج"));
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
