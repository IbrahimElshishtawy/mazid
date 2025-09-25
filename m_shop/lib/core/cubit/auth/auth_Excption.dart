// ignore_for_file: file_names

// نعيد تصدير AuthService الأصلي من مكانه الموحّد

/// استثناءات المصادقة
class AuthException implements Exception {
  final String message;
  final String? code;
  const AuthException(this.message, {this.code});

  @override
  String toString() => 'AuthException(${code ?? 'unknown'}): $message';
}
