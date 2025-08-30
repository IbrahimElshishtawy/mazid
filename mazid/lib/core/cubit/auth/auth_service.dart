// ignore_for_file: avoid_print
import 'package:mazid/core/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  /// تسجيل مستخدم جديد
  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
    String phone = '',
  }) async {
    print("🔄 [AuthService] Registering: $email");

    final response = await supabase.auth.signUp(
      email: email,
      password: password,
    );

    print("🟢 [AuthService] signUp response: $response");

    if (response.user != null) {
      final userId = response.user!.id;

      // إضافة المستخدم لجدول 'users'
      await supabase.from('users').insert({
        'id': userId,
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'avatar': '',
        'created_at': DateTime.now().toUtc().toIso8601String(),
      });

      print("✅ [AuthService] User inserted in DB: $userId");

      return UserModel(
        id: userId,
        name: name.trim(),
        email: email.trim(),
        avatar: '',
        phone: phone.trim(),
      );
    }

    print("❌ [AuthService] Registration failed for $email");
    return null;
  }

  /// تسجيل الدخول بالبريد مع التحقق من البريد المؤكد
  Future<UserModel?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    print("🔄 [AuthService] Login with email: $email");

    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      print("🟢 [AuthService] signIn response: $response");

      if (response.user != null) {
        // لو عايز تتحقق من البريد مفعل
        // if (response.user!.emailConfirmedAt == null) {
        //   print("❌ [AuthService] Email not confirmed: $email");
        //   return null;
        // }

        final data = await supabase
            .from('users')
            .select()
            .eq('id', response.user!.id)
            .maybeSingle();

        print("🟢 [AuthService] User data from DB: $data");

        if (data != null) {
          return UserModel.fromJson(data);
        } else {
          print("❌ [AuthService] User not found in 'users' table");
        }
      } else {
        print("❌ [AuthService] Invalid email or password");
      }
    } catch (e) {
      print("🔥 [AuthService] Login exception: $e");
    }

    return null;
  }

  /// إرسال OTP للهاتف
  Future<void> loginWithPhone(String phone) async {
    print("🔄 [AuthService] Sending OTP to: $phone");
    await supabase.auth.signInWithOtp(phone: phone);
    print("✅ [AuthService] OTP sent to $phone");
  }

  /// التحقق من OTP
  Future<UserModel?> verifyPhoneOtp({
    required String phone,
    required String otp,
  }) async {
    print("🔄 [AuthService] Verifying OTP for: $phone");

    final response = await supabase.auth.verifyOTP(
      phone: phone,
      token: otp,
      type: OtpType.sms,
    );

    print("🟢 [AuthService] verifyOTP response: $response");

    if (response.user != null) {
      final data = await supabase
          .from('users')
          .select()
          .eq('id', response.user!.id)
          .maybeSingle();

      if (data != null) {
        return UserModel.fromJson(data);
      }
    }

    print("❌ [AuthService] OTP verification failed for $phone");
    return null;
  }

  /// تسجيل الخروج
  Future<void> logout() async {
    print("🔄 [AuthService] Logging out...");
    await supabase.auth.signOut();
    print("✅ [AuthService] Logout success");
  }

  /// جلب المستخدم الحالي
  Future<UserModel?> currentUser() async {
    final user = supabase.auth.currentUser;
    print("🔄 [AuthService] Checking current user: $user");

    if (user != null) {
      final data = await supabase
          .from('users')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      print("🟢 [AuthService] Current user data from DB: $data");

      if (data != null) {
        return UserModel.fromJson(data);
      }
    }

    print("❌ [AuthService] No user logged in");
    return null;
  }

  /// تسجيل دخول شامل (بريد أو هاتف)
  Future<UserModel?> login({
    String? email,
    String? phone,
    String? password,
  }) async {
    if (email != null && email.isNotEmpty && password != null) {
      return await loginWithEmail(email: email, password: password);
    } else if (phone != null && phone.isNotEmpty) {
      await loginWithPhone(phone);
      return null;
    } else {
      throw Exception("Either email/password or phone must be provided");
    }
  }
}
