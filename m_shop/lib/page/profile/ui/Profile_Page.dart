// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:m_shop/core/data/admin_data.dart';
import 'package:m_shop/core/models/user/user_model.dart';
import 'package:m_shop/page/profile/data/profile_data.dart';
import 'package:m_shop/page/profile/widget/stats_grid.dart';
import 'package:m_shop/page/profile/widget/user_card.dart';
import 'package:m_shop/page/profile/widget/wallet_section.dart';
import 'package:m_shop/page/profile/ui/settings_page.dart';
import 'package:m_shop/page/profile/ui/about_page.dart';
import 'package:m_shop/page/profile/ui/legal_terms_page.dart';
import 'package:m_shop/page/profile/ui/sims_control_page.dart';
import 'package:m_shop/page/profile/ui/seller_dashboard.dart';
import 'package:m_shop/page/profile/ui/seller_product_management.dart';
import 'package:m_shop/page/profile/ui/order_history_page.dart';

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
          child: Column(
            children: [
              (userId == "guest")
                  ? _buildGuestProfile()
                  : _buildUserProfile(),
              const SizedBox(height: 24),
              _buildNavigationMenu(context),
            ],
          ),
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

  Widget _buildNavigationMenu(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _buildMenuItem(
            context,
            icon: Icons.settings,
            title: "Settings",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage())),
          ),
          _buildMenuItem(
            context,
            icon: Icons.info_outline,
            title: "About",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage())),
          ),
          _buildMenuItem(
            context,
            icon: Icons.gavel,
            title: "Legal Terms",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LegalTermsPage())),
          ),
          _buildMenuItem(
            context,
            icon: Icons.store,
            title: "Seller Dashboard",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerDashboard())),
          ),
          _buildMenuItem(
            context,
            icon: Icons.inventory_2,
            title: "Manage My Products",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerProductManagement())),
          ),
          _buildMenuItem(
            context,
            icon: Icons.shopping_bag,
            title: "My Orders",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryPage())),
          ),
          _buildMenuItem(
            context,
            icon: Icons.tune,
            title: "Sims Control",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SimsControlPage())),
          ),
          _buildMenuItem(
            context,
            icon: Icons.edit,
            title: "Edit Profile",
            onTap: () {
              // Placeholder for edit profile logic
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Edit Profile feature coming soon!")));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.orangeAccent),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
      onTap: onTap,
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
