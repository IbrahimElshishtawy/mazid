import 'package:flutter/material.dart';
import 'package:mazid/core/models/user_model.dart';
import '../widgets/user_card.dart';
import '../widgets/wallet_section.dart';
import '../widgets/stats_grid.dart';
import '../data/profile_data.dart';

class ProfilePage extends StatelessWidget {
  final String userId;

  const ProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    // جلب بيانات المستخدم من Supabase
    final profileData = ProfileData(userId: userId);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: FutureBuilder<UserModel?>(
            future: profileData.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orangeAccent),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    "لا توجد بيانات للمستخدم",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
              final user = snapshot.data!;
              return Column(
                children: [
                  UserCard(user: user),
                  const SizedBox(height: 24),
                  WalletSection(walletBalance: profileData.walletBalance),
                  const SizedBox(height: 24),
                  StatsGrid(
                    totalPurchases: profileData.totalPurchases,
                    totalCancelledOrders: profileData.totalCancelledOrders,
                    pendingOrders: profileData.pendingOrders,
                    receivedOrders: profileData.receivedOrders,
                    unreceivedOrders: profileData.unreceivedOrders,
                    totalSales: profileData.totalSales,
                    totalAuctions: profileData.totalAuctions,
                    totalSpent: profileData.totalSpent,
                    totalEarned: profileData.totalEarned,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
