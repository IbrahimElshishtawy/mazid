import 'package:flutter/material.dart';

class WalletSection extends StatelessWidget {
  final double? walletBalance;
  const WalletSection({super.key, this.walletBalance});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.lightGreenAccent,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Wallet: \$${walletBalance?.toStringAsFixed(2) ?? "0.00"}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Deposit feature simulation!")));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightGreenAccent.withOpacity(0.2),
                  foregroundColor: Colors.lightGreenAccent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Deposit"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white10),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Recent Transactions",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
          ),
          const SizedBox(height: 8),
          _buildTransactionItem("Product Purchase", "-\$20.00", Colors.redAccent),
          _buildTransactionItem("Deposit", "+\$50.00", Colors.lightGreenAccent),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(String title, String amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          Text(amount, style: TextStyle(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
