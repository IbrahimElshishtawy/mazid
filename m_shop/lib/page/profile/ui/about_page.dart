import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("About Mazid", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/asset/icon/iconimage.jpg'),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Mazid Shop",
              style: TextStyle(color: Colors.orangeAccent, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Version: 1.0.0+1",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              "Mazid Shop is your one-stop destination for products, auctions, and exchanges. Experience a professional and secure shopping environment.",
              style: TextStyle(color: Colors.white, fontSize: 16, height: 1.5),
            ),
            const Spacer(),
            const Center(
              child: Text(
                "© 2025 Mazid Inc.",
                style: TextStyle(color: Colors.white24, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
