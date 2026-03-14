class AuthService {
  bool login(String email, String password) {
    return email.isNotEmpty && password.isNotEmpty;
  }

  void logout() {}
}
