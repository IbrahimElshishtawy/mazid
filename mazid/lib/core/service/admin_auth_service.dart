import 'package:mazid/core/data/admin_data.dart';

class AdminAuthService {
  static bool isAdminLogin(String identifier, String password) {
    return identifier == AdminData.email && password == AdminData.password;
  }
}
