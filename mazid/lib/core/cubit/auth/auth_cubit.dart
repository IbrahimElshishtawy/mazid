import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_state.dart';
import 'auth_service.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService authService;

  AuthCubit({required this.authService}) : super(AuthInitial());

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
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(message: "Registration failed"));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final user = await authService.login(email: email, password: password);

      if (user != null) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure(message: "Login failed"));
      }
    } catch (e) {
      emit(AuthFailure(message: e.toString()));
    }
  }

  Future<void> logout() async {
    await authService.logout();
    emit(AuthInitial());
  }
}
