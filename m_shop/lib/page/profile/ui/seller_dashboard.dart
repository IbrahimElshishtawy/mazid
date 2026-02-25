import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_shop/core/cubit/seller/seller_cubit.dart';
import 'package:m_shop/core/cubit/seller/seller_state.dart';

class SellerDashboard extends StatefulWidget {
  const SellerDashboard({super.key});

  @override
  State<SellerDashboard> createState() => _SellerDashboardState();
}

class _SellerDashboardState extends State<SellerDashboard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  String _selectedCategory = "Electronics";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Seller Dashboard", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<SellerCubit, SellerState>(
        builder: (context, state) {
          if (state is SellerLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.orangeAccent));
          } else if (state is SellerLoaded) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnalyticsSection(state.analytics),
                  const SizedBox(height: 30),
                  const Text("List a New Product", style: TextStyle(color: Colors.orangeAccent, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(_nameController, "Product Name"),
                        const SizedBox(height: 12),
                        _buildTextField(_priceController, "Price (\$)", keyboardType: TextInputType.number),
                        const SizedBox(height: 12),
                        _buildDropdown(),
                        const SizedBox(height: 12),
                        _buildTextField(_descController, "Description", maxLines: 3),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Product listed successfully!")));
                              _nameController.clear();
                              _priceController.clear();
                              _descController.clear();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orangeAccent,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Submit Listing", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is SellerError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.redAccent)));
          }
          return const Center(child: Text("No data available", style: TextStyle(color: Colors.white)));
        },
      ),
    );
  }

  Widget _buildAnalyticsSection(SellerAnalytics analytics) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Business Analytics", style: TextStyle(color: Colors.orangeAccent, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildAnalyticsGrid(analytics),
      ],
    );
  }

  Widget _buildAnalyticsGrid(SellerAnalytics analytics) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.5,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildStatCard("Daily Profit", "\$${analytics.dailyProfit}", Colors.greenAccent),
        _buildStatCard("Weekly Profit", "\$${analytics.weeklyProfit}", Colors.greenAccent),
        _buildStatCard("Monthly Profit", "\$${analytics.monthlyProfit}", Colors.greenAccent),
        _buildStatCard("Annual Profit", "\$${analytics.annualProfit}", Colors.greenAccent),
        _buildStatCard("Daily Inventory", "${analytics.dailyInventory}", Colors.blueAccent),
        _buildStatCard("Monthly Inventory", "${analytics.monthlyInventory}", Colors.blueAccent),
        _buildStatCard("Weekly Loss", "\$${analytics.weeklyLoss}", Colors.redAccent),
        _buildStatCard("Annual Loss", "\$${analytics.annualLoss}", Colors.redAccent),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (val) => val == null || val.isEmpty ? "Required" : null,
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCategory,
          dropdownColor: Colors.grey[900],
          style: const TextStyle(color: Colors.white),
          onChanged: (val) => setState(() => _selectedCategory = val!),
          items: ["Electronics", "Clothes", "Perfume", "Cosmetic", "Laptops"]
              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
              .toList(),
        ),
      ),
    );
  }
}
