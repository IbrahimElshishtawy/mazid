import 'package:flutter/material.dart';

class WalletSection extends StatelessWidget {
  final double? walletBalance;
  const WalletSection({super.key, this.walletBalance});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
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
                "رصيد المحفظة: \$${walletBalance?.toStringAsFixed(2) ?? "0.00"}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
