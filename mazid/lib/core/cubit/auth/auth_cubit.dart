import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import 'auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit({required this.authService}) : super(AuthInitial());

  // تسجيل مستخدم جديد
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await authService.register(
        name: name,
        email: email,
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

  // تسجيل الدخول
  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final user = await authService.login(email: email, password: password);

      if (user != null) {
        emit(Authenticated(user.id));
      } else {
        emit(AuthFailure(message: "Login failed"));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  // تسجيل الخروج
  Future<void> logout() async {
    try {
      await authService.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  // التأكد من حالة المستخدم الحالي
  Future<void> checkAuthStatus() async {
    final user = authService.currentUser();
    if (user != null) {
      emit(Authenticated(user.id));
    } else {
      emit(Unauthenticated());
    }
  }

  void signIn(String trim, String trim2) {}
}
