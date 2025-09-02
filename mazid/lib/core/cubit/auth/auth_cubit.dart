// ignore_for_file: avoid_print

import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_service.dart';
import 'auth_state.dart';

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
        print("✅ [AuthCubit] Registration successful: ${user.email}");
        emit(Authenticated(user));
      } else {
        print("❌ [AuthCubit] Registration failed: null user");
        emit(AuthFailure(message: "فشل إنشاء الحساب، حاول مرة أخرى"));
      }
    } catch (e, st) {
      print("❌ [AuthCubit] Register exception: $e\n$st");
      emit(AuthFailure(message: "حدث خطأ أثناء إنشاء الحساب"));
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
        print("✅ [AuthCubit] Login successful: $email");
        emit(Authenticated(user));
      } else {
        print("❌ [AuthCubit] Invalid email/password: $email");
        emit(
          AuthFailure(message: "البريد الإلكتروني أو كلمة المرور غير صحيحة"),
        );
      }
    } catch (e, st) {
      print("❌ [AuthCubit] Login exception: $e\n$st");
      emit(
        AuthFailure(message: "تعذر تسجيل الدخول، تحقق من الشبكة وحاول مجددًا"),
      );
    }
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await authService.logout();
      print("🔄 [AuthCubit] User logged out");
      emit(Unauthenticated()); // بدل LoginPage مباشرة بدل Intro
    } catch (e, st) {
      print("❌ [AuthCubit] Logout failed: $e\n$st");
      emit(AuthFailure(message: "تعذر تسجيل الخروج"));
    }
  }

  /// التحقق من حالة المصادقة عند بدء التطبيق
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    try {
      final user = await authService.currentUser();
      if (user != null) {
        print("✅ [AuthCubit] Current user: ${user.email}");
        emit(Authenticated(user)); // يذهب مباشرة للصفحة الرئيسية بدل Intro
      } else {
        print("❌ [AuthCubit] No user logged in");
        emit(Unauthenticated()); // المستخدم سيبقى في LoginPage بدل Intro
      }
    } catch (e, st) {
      print("❌ [AuthCubit] Auth status check failed: $e\n$st");
      emit(Unauthenticated());
    }
  }
}
