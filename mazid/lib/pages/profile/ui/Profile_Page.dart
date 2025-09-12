// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mazid/core/data/admin_data.dart';
import 'package:mazid/core/models/user_model.dart';
import 'package:mazid/pages/profile/data/profile_data.dart';
import 'package:mazid/pages/profile/widget/stats_grid.dart';
import 'package:mazid/pages/profile/widget/user_card.dart';
import 'package:mazid/pages/profile/widget/wallet_section.dart';

class ProfilePage extends StatelessWidget {
  final String userId;
  final bool isAdmin;

  const ProfilePage({super.key, required this.userId, this.isAdmin = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: isAdmin ? _buildAdminProfile() : _buildUserProfile(),
        ),
      ),
    );
  }

  // بيانات الإدمن
  Widget _buildAdminProfile() {
    final adminUser = UserModel(
      id: "admin_001",
      name: AdminData.name,
      email: AdminData.email,
      phone: AdminData.phone,
      password: AdminData.password,
      imageUrl: "https://example.com/admin_image.png",
      avatar: '',
    );

    return Column(
      children: [
        UserCard(user: adminUser),
        const SizedBox(height: 24),
        WalletSection(walletBalance: 0),
        const SizedBox(height: 24),
        StatsGrid(
          totalPurchases: 0,
          totalCancelledOrders: 0,
          pendingOrders: 0,
          receivedOrders: 0,
          unreceivedOrders: 0,
          totalSales: 0,
          totalAuctions: 0,
          totalSpent: 0,
          totalEarned: 0,
        ),
      ],
    );
  }

  // بيانات المستخدم العادي
  Widget _buildUserProfile() {
    final profileData = ProfileData(userId: userId);

    return FutureBuilder<UserModel?>(
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
    );
  }
}
