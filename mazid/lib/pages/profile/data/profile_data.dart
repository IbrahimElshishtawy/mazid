import 'package:flutter/foundation.dart';
import 'package:mazid/core/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileData {
  final String userId;
  final supabase = Supabase.instance.client;
  int? totalPurchases;
  int? totalCancelledOrders;
  int? pendingOrders;
  int? receivedOrders;
  int? unreceivedOrders;
  int? totalSales;
  int? totalAuctions;
  double? totalSpent;
  double? totalEarned;
  double? walletBalance;

  ProfileData({required this.userId});
  Future<UserModel?> getUserData() async {
    try {
      final authUser = supabase.auth.currentUser;
      if (authUser == null) {
        if (kDebugMode) {
          print("⚠️ لا يوجد مستخدم مسجل دخول حالياً");
        }
        return null;
      }

      final response = await supabase
          .from('users')
          .select()
          .eq('id', userId)
          .maybeSingle();

      final user = UserModel(
        id: userId,
        name: response?['name'] ?? authUser.userMetadata?['name'] ?? "مستخدم",
        email: authUser.email ?? "no-email",
        phone: response?['phone'] ?? "",
        walletBalance: await getWalletBalance(),
        totalPurchases: await getTotalPurchases(),
        totalCancelledOrders: await getTotalCancelledOrders(),
        pendingOrders: await getPendingOrders(),
        receivedOrders: await getReceivedOrders(),
        unreceivedOrders: await getUnreceivedOrders(),
        totalSales: await getTotalSales(),
        totalAuctions: await getTotalAuctions(),
        totalSpent: await getTotalSpent(),
        totalEarned: await getTotalEarned(),
        avatar: '',
        password: '',
        imageUrl: '',
        role: '',
      );

      return user;
    } catch (e) {
      if (kDebugMode) {
        print("❌ خطأ أثناء جلب بيانات المستخدم: $e");
      }
      return null;
    }
  }

  Future<int> getTotalPurchases() async => 0;
  Future<int> getTotalCancelledOrders() async => 0;
  Future<int> getPendingOrders() async => 0;
  Future<int> getReceivedOrders() async => 0;
  Future<int> getUnreceivedOrders() async => 0;
  Future<int> getTotalSales() async => 0;
  Future<int> getTotalAuctions() async => 0;
  Future<double> getTotalSpent() async => 0.0;
  Future<double> getTotalEarned() async => 0.0;
  Future<double> getWalletBalance() async => 0.0;
}
