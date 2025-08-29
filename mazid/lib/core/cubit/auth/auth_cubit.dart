import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_state.dart';
import 'auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit({required this.authService}) : super(AuthInitial());

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

  Future<void> login({
    String? email,
    String? phone,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final user = await authService.login(
        email: email ?? '',
        phone: phone ?? '',
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

  Future<void> logout() async {
    try {
      await authService.logout();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> checkAuthStatus() async {
    final user = authService.currentUser();
    if (user != null) {
      emit(Authenticated(user.id));
    } else {
      emit(Unauthenticated());
    }
  }
}
