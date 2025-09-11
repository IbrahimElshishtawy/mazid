// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:mazid/core/data/admin_data.dart';
import 'package:mazid/core/models/user_model.dart';
import 'package:mazid/pages/profile/widget/stats_grid.dart';
import 'package:mazid/pages/profile/widget/user_card.dart';
import 'package:mazid/pages/profile/widget/wallet_section.dart';

class ProfilePage extends StatelessWidget {
  final bool isAdmin;
  final String userId;

  const ProfilePage({super.key, this.isAdmin = false, required this.userId});

  @override
  Widget build(BuildContext context) {
    UserModel? user;
    if (isAdmin) {
      // بيانات الإدمن من AdminData
      user = UserModel(
        id: "admin_001",
        name: AdminData.name,
        email: AdminData.email,
        phone: AdminData.phone,
        password: AdminData.password,
        imageUrl: "https://example.com/admin_image.png",
        avatar: '', // ضع رابط الصورة إذا موجود
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: isAdmin
              ? Column(
                  children: [
                    UserCard(user: user!),
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
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.block, color: Colors.redAccent, size: 60),
                      SizedBox(height: 16),
                      Text(
                        "غير مسموح بعرض بيانات المستخدم",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
