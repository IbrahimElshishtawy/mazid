import 'package:flutter/material.dart';
import 'package:mazid/core/models/user_model.dart';

class ProfilePage extends StatelessWidget {
  final UserModel user;
  final int totalSales;
  final int totalPurchases;
  final int totalAuctions;
  final double totalSpent;
  final double totalEarned;

  const ProfilePage({
    super.key,
    required this.user,
    required this.totalSales,
    required this.totalPurchases,
    required this.totalAuctions,
    required this.totalSpent,
    required this.totalEarned,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // خلفية متدرجة
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black87, Colors.black54],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // بطاقة المستخدم
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.orangeAccent,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                            user.avatar.isNotEmpty
                                ? user.avatar
                                : 'https://via.placeholder.com/150',
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      if (user.phone.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          user.phone,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // إحصائيات
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  children: [
                    _buildStatCard(
                      Icons.shopping_cart,
                      "المشتريات",
                      totalPurchases.toString(),
                      Colors.orangeAccent,
                    ),
                    _buildStatCard(
                      Icons.sell,
                      "المبيعات",
                      totalSales.toString(),
                      Colors.greenAccent,
                    ),
                    _buildStatCard(
                      Icons.gavel,
                      "المزادات",
                      totalAuctions.toString(),
                      Colors.blueAccent,
                    ),
                    _buildStatCard(
                      Icons.attach_money,
                      "الإنفاق",
                      "\$${totalSpent.toStringAsFixed(2)}",
                      Colors.redAccent,
                    ),
                    _buildStatCard(
                      Icons.account_balance_wallet,
                      "الأرباح",
                      "\$${totalEarned.toStringAsFixed(2)}",
                      Colors.lightGreenAccent,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // زر تعديل البيانات
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: Colors.orange,
                  ),
                  onPressed: () {
                    // Navigate to EditProfilePage
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text(
                    "تعديل البيانات",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.6),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
