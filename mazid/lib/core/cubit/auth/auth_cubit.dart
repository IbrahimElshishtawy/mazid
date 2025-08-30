// ignore_for_file: avoid_print
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
    print("🔄 [AuthCubit] Registering user: $email | phone: $phone");

    try {
      final user = await authService.register(
        name: name,
        email: email ?? '',
        phone: phone ?? '',
        password: password,
      );

      if (user != null) {
        print("✅ [AuthCubit] User registered: ${user.id}");
        emit(Authenticated(user));
      } else {
        print("❌ [AuthCubit] Register failed");
        emit(AuthFailure(message: "فشل إنشاء الحساب، حاول مرة أخرى"));
      }
    } catch (e) {
      print("🔥 [AuthCubit] Unexpected error: $e");
      emit(AuthFailure(message: "حدث خطأ غير متوقع أثناء التسجيل"));
    }
  }

  /// تسجيل الدخول بالبريد
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    print("🔄 [AuthCubit] Login with email: $email");

    try {
      final user = await authService.loginWithEmail(
        email: email,
        password: password,
      );

      if (user != null) {
        print("✅ [AuthCubit] Login success: ${user.id}");
        emit(Authenticated(user));
      } else {
        print("❌ [AuthCubit] Invalid email or password");
        emit(
          AuthFailure(message: "البريد الإلكتروني أو كلمة المرور غير صحيحة"),
        );
      }
    } catch (e) {
      print("🔥 [AuthCubit] Login error: $e");
      emit(
        AuthFailure(message: "تعذر تسجيل الدخول، تحقق من الشبكة وحاول مجددًا"),
      );
    }
  }

  /// إرسال OTP للهاتف
  Future<void> loginWithPhone(String phone) async {
    emit(AuthLoading());
    print("🔄 [AuthCubit] Sending OTP to phone: $phone");

    try {
      await authService.loginWithPhone(phone);
      print("✅ [AuthCubit] OTP sent to $phone");
      emit(AuthOtpSent(phone));
    } catch (e) {
      print("🔥 [AuthCubit] OTP error: $e");
      emit(AuthFailure(message: "فشل إرسال رمز التحقق، حاول مرة أخرى"));
    }
  }

  /// التحقق من OTP
  Future<void> verifyPhoneOtp({
    required String phone,
    required String otp,
  }) async {
    emit(AuthLoading());
    print("🔄 [AuthCubit] Verifying OTP for $phone | Code: $otp");

    try {
      final user = await authService.verifyPhoneOtp(phone: phone, otp: otp);
      if (user != null) {
        print("✅ [AuthCubit] OTP verified for user: ${user.id}");
        emit(Authenticated(user));
      } else {
        print("❌ [AuthCubit] OTP verification failed");
        emit(AuthFailure(message: "رمز التحقق غير صحيح"));
      }
    } catch (e) {
      print("🔥 [AuthCubit] OTP verification error: $e");
      emit(AuthFailure(message: "حدث خطأ أثناء التحقق من الرمز"));
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    print("🔄 [AuthCubit] Logging out...");
    try {
      await authService.logout();
      print("✅ [AuthCubit] Logout success");
      emit(Unauthenticated());
    } catch (e) {
      print("🔥 [AuthCubit] Logout error: $e");
      emit(AuthFailure(message: "تعذر تسجيل الخروج"));
    }
  }

  /// التحقق من حالة المصادقة
  Future<void> checkAuthStatus() async {
    print("🔄 [AuthCubit] Checking auth status...");
    final user = await authService.currentUser();
    if (user != null) {
      print("✅ [AuthCubit] User already authenticated: ${user.id}");
      emit(Authenticated(user));
    } else {
      print("❌ [AuthCubit] No user logged in");
      emit(Unauthenticated());
    }
  }
}
