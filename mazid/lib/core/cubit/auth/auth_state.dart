import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final String userId;
  Authenticated(this.userId);

  @override
  List<Object?> get props => [userId];
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
