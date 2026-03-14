class ValidationHelper {
  static bool isValidEmail(String value) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  }

  static bool isStrongPassword(String value) {
    return value.length >= 6;
  }
}
