import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

/// الحالة الأولية
class AuthInitial extends AuthState {}

/// حالة التحميل
class AuthLoading extends AuthState {}

/// حالة النجاح العام (مثلاً تسجيل الدخول أو التسجيل بنجاح)
class AuthSuccess extends AuthState {}

/// المستخدم مسجّل الدخول
class Authenticated extends AuthState {
  final String userId;

  Authenticated(this.userId);

  @override
  List<Object?> get props => [userId];
}

/// المستخدم غير مسجّل الدخول
class Unauthenticated extends AuthState {
  final String? message;

  Unauthenticated({this.message});

  @override
  List<Object?> get props => [message];
}

/// فشل العملية (زي خطأ في الباسورد أو غيره)
class AuthFailure extends AuthState {
  final String message;

  AuthFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
