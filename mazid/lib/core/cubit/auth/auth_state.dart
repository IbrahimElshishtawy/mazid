import 'package:equatable/equatable.dart';
import 'package:mazid/core/models/user_model.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserModel user;
  Authenticated(this.user);

  @override
  List<Object?> get props => [user.id, user.email];
}

class Unauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthOtpSent extends AuthState {
  final String phone;
  AuthOtpSent(this.phone);

  @override
  List<Object?> get props => [phone];
}
