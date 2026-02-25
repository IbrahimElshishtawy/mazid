// m_shop/lib/page/profile/ui/seller_dashboard.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_shop/core/cubit/seller/seller_cubit.dart';
import 'package:m_shop/core/cubit/seller/seller_state.dart';

class SellerDashboardPage extends StatelessWidget {
  const SellerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text("Seller Dashboard"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<SellerCubit, SellerState>(
        builder: (context, state) {
          if (state is SellerLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.orange));
          } else if (state is SellerLoaded) {
            return _buildDashboard(context, state.stats);
          } else if (state is SellerError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const Center(child: Text("Initial State", style: TextStyle(color: Colors.white)));
        },
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, SellerStats stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatSection("Revenue", [
            _StatCard(title: "Daily", value: "\$${stats.dailyRevenue}", color: Colors.green),
            _StatCard(title: "Weekly", value: "\$${stats.weeklyRevenue}", color: Colors.green),
            _StatCard(title: "Monthly", value: "\$${stats.monthlyRevenue}", color: Colors.green),
            _StatCard(title: "Annual", value: "\$${stats.annualRevenue}", color: Colors.green),
          ]),
          const SizedBox(height: 24),
          _buildStatSection("Losses", [
            _StatCard(title: "Daily", value: "\$${stats.dailyLoss}", color: Colors.red),
            _StatCard(title: "Weekly", value: "\$${stats.weeklyLoss}", color: Colors.red),
            _StatCard(title: "Monthly", value: "\$${stats.monthlyLoss}", color: Colors.red),
            _StatCard(title: "Annual", value: "\$${stats.annualLoss}", color: Colors.red),
          ]),
          const SizedBox(height: 24),
          _buildStatSection("Inventory", [
            _StatCard(title: "Daily", value: "${stats.dailyInventory}", color: Colors.blue),
            _StatCard(title: "Weekly", value: "${stats.weeklyInventory}", color: Colors.blue),
            _StatCard(title: "Monthly", value: "${stats.monthlyInventory}", color: Colors.blue),
            _StatCard(title: "Annual", value: "${stats.annualInventory}", color: Colors.blue),
          ]),
        ],
      ),
    );
  }

  Widget _buildStatSection(String title, List<Widget> cards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: cards,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 14)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
