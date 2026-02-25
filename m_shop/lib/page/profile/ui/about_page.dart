// m_shop/lib/page/profile/ui/about_page.dart
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(title: const Text("About Mazid Shop"), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
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
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Version 1.0.0",
              style: TextStyle(color: Colors.grey[400]),
            ),
            const SizedBox(height: 30),
            const Text(
              "Mazid Shop is a comprehensive e-commerce platform that allows users to buy, sell, and auction products. We provide a robust and secure environment for all your trading needs.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 40),
            _buildInfoTile(Icons.link, "Website", "www.mazidshop.com"),
            _buildInfoTile(Icons.email, "Contact Us", "support@mazidshop.com"),
            _buildInfoTile(Icons.privacy_tip, "Privacy Policy", "Read our terms"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      subtitle: Text(value, style: const TextStyle(color: Colors.grey)),
    );
  }
}
