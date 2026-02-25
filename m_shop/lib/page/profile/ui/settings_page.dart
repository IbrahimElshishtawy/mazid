// m_shop/lib/page/profile/ui/settings_page.dart
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifications = true;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(title: const Text("Settings"), backgroundColor: Colors.transparent),
      body: ListView(
        children: [
          _buildSectionHeader("Account"),
          ListTile(
            leading: const Icon(Icons.person, color: Colors.orange),
            title: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          _buildSectionHeader("Preferences"),
          SwitchListTile(
            secondary: const Icon(Icons.notifications, color: Colors.orange),
            title: const Text("Push Notifications", style: TextStyle(color: Colors.white)),
            value: _notifications,
            onChanged: (val) => setState(() => _notifications = val),
            activeColor: Colors.orange,
          ),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.orange),
            title: const Text("Language", style: TextStyle(color: Colors.white)),
            subtitle: Text(_language, style: const TextStyle(color: Colors.grey)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => _showLanguageDialog(),
          ),
          _buildSectionHeader("Other"),
          ListTile(
            leading: const Icon(Icons.security, color: Colors.orange),
            title: const Text("Privacy Settings", style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.orange),
            title: const Text("Help & Support", style: TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text("Select Language", style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['English', 'Arabic', 'French', 'Spanish'].map((lang) {
            return ListTile(
              title: Text(lang, style: const TextStyle(color: Colors.white)),
              onTap: () {
                setState(() => _language = lang);
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
