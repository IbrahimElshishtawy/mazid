import 'package:flutter/material.dart';

class LegalTermsPage extends StatelessWidget {
  const LegalTermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Legal Terms & Conditions", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Terms of Service",
              style: TextStyle(color: Colors.orangeAccent, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "By using Mazid Shop, you agree to comply with all applicable laws and regulations. Our platform provides a marketplace for buying, selling, and exchanging products through direct purchase or auctions.",
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
            ),
            SizedBox(height: 20),
            Text(
              "Auction Rules",
              style: TextStyle(color: Colors.orangeAccent, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "1. All bids are final.\n2. Users must have sufficient wallet balance or verified payment methods.\n3. Sellers are responsible for the accuracy of product descriptions.",
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
            ),
            SizedBox(height: 20),
            Text(
              "Privacy Policy",
              style: TextStyle(color: Colors.orangeAccent, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "We value your privacy. Your personal data is encrypted and used only to improve your experience and facilitate transactions.",
              style: TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
