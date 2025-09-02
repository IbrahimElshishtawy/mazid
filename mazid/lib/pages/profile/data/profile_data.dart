import 'package:mazid/core/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileData {
  final String userId;
  final supabase = Supabase.instance.client;

  // إحصائيات افتراضية
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
      final response = await supabase
          .from('users')
          .select()
          .eq('id', userId)
          .single();
      final user = UserModel.fromMap(response);

      // جلب باقي البيانات من جدول orders أو finance حسب تصميمك
      totalPurchases = await getTotalPurchases();
      totalCancelledOrders = await getTotalCancelledOrders();
      pendingOrders = await getPendingOrders();
      receivedOrders = await getReceivedOrders();
      unreceivedOrders = await getUnreceivedOrders();
      totalSales = await getTotalSales();
      totalAuctions = await getTotalAuctions();
      totalSpent = await getTotalSpent();
      totalEarned = await getTotalEarned();
      walletBalance = await getWalletBalance();

      return user;
    } catch (e) {
      print("❌ Error fetching user data: $e");
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
