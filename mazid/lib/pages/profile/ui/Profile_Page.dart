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

  const ProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: (userId == "guest")
              ? _buildGuestProfile()
              : _buildUserProfile(),
        ),
      ),
    );
  }

  // ✅ بيانات الأدمن
  Widget _buildAdminProfile() {
    final adminUser = UserModel(
      id: AdminData.id,
      name: AdminData.name,
      email: AdminData.email,
      phone: AdminData.phone,
      password: "",
      imageUrl: AdminData.imageUrl,
      avatar: AdminData.avatar,
      walletBalance: AdminData.walletBalance.toDouble(),
      totalPurchases: AdminData.totalPurchases,
      totalCancelledOrders: AdminData.totalCancelledOrders,
      pendingOrders: AdminData.pendingOrders,
      receivedOrders: AdminData.receivedOrders,
      unreceivedOrders: AdminData.unreceivedOrders,
      totalSales: AdminData.totalSales,
      totalAuctions: AdminData.totalAuctions,
      totalSpent: AdminData.totalSpent,
      totalEarned: AdminData.totalEarned,
      role: 'admin',
    );

    return Column(
      children: [
        UserCard(user: adminUser),
        const SizedBox(height: 24),
        WalletSection(walletBalance: adminUser.walletBalance),
        const SizedBox(height: 24),
        StatsGrid(
          totalPurchases: adminUser.totalPurchases,
          totalCancelledOrders: adminUser.totalCancelledOrders,
          pendingOrders: adminUser.pendingOrders,
          receivedOrders: adminUser.receivedOrders,
          unreceivedOrders: adminUser.unreceivedOrders,
          totalSales: adminUser.totalSales,
          totalAuctions: adminUser.totalAuctions,
          totalSpent: adminUser.totalSpent,
          totalEarned: adminUser.totalEarned,
        ),
      ],
    );
  }

  // ✅ بيانات المستخدم من Firebase
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

        if (snapshot.hasError) {
          return const Center(
            child: Text(
              "حدث خطأ أثناء تحميل البيانات",
              style: TextStyle(color: Colors.redAccent),
            ),
          );
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(
            child: Text(
              "لا توجد بيانات للمستخدم",
              style: TextStyle(color: Colors.white),
            ),
          );
        }

        final user = snapshot.data!;

        // ✅ لو المستخدم أدمن
        if (user.email == AdminData.email) {
          return _buildAdminProfile();
        }

        // ✅ مستخدم عادي
        return Column(
          children: [
            UserCard(user: user),
            const SizedBox(height: 24),
            WalletSection(walletBalance: user.walletBalance),
            const SizedBox(height: 24),
            StatsGrid(
              totalPurchases: user.totalPurchases,
              totalCancelledOrders: user.totalCancelledOrders,
              pendingOrders: user.pendingOrders,
              receivedOrders: user.receivedOrders,
              unreceivedOrders: user.unreceivedOrders,
              totalSales: user.totalSales,
              totalAuctions: user.totalAuctions,
              totalSpent: user.totalSpent,
              totalEarned: user.totalEarned,
            ),
          ],
        );
      },
    );
  }

  Widget _buildGuestProfile() {
    final guestUser = UserModel(
      id: "guest_001",
      name: "ضيف",
      email: "guest@example.com",
      phone: "-",
      password: "",
      imageUrl: 'asset/icon/iconimage.jpg',
      avatar: '',
      walletBalance: 0.0,
      totalPurchases: 0,
      totalCancelledOrders: 0,
      pendingOrders: 0,
      receivedOrders: 0,
      unreceivedOrders: 0,
      totalSales: 0,
      totalAuctions: 0,
      totalSpent: 0.0,
      totalEarned: 0.0,
      role: 'guest',
    );

    return Column(
      children: [
        UserCard(user: guestUser),
        const SizedBox(height: 24),
        WalletSection(walletBalance: guestUser.walletBalance),
        const SizedBox(height: 24),
        StatsGrid(
          totalPurchases: guestUser.totalPurchases,
          totalCancelledOrders: guestUser.totalCancelledOrders,
          pendingOrders: guestUser.pendingOrders,
          receivedOrders: guestUser.receivedOrders,
          unreceivedOrders: guestUser.unreceivedOrders,
          totalSales: guestUser.totalSales,
          totalAuctions: guestUser.totalAuctions,
          totalSpent: guestUser.totalSpent,
          totalEarned: guestUser.totalEarned,
        ),
      ],
    );
  }
}
