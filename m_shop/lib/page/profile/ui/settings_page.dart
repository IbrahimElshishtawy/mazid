import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedLanguage = "English";
  bool _isPrivateProfile = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Settings", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          _buildSectionHeader("Language"),
          ListTile(
            title: Text(_selectedLanguage, style: const TextStyle(color: Colors.white)),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
            onTap: _showLanguageDialog,
          ),
          const Divider(color: Colors.white10),
          _buildSectionHeader("Privacy"),
          SwitchListTile(
            title: const Text("Private Profile", style: TextStyle(color: Colors.white)),
            subtitle: const Text("Only verified users can see your history", style: TextStyle(color: Colors.white54, fontSize: 12)),
            value: _isPrivateProfile,
            onChanged: (val) => setState(() => _isPrivateProfile = val),
            activeColor: Colors.orangeAccent,
          ),
          const Divider(color: Colors.white10),
          _buildSectionHeader("Notifications"),
          SwitchListTile(
            title: const Text("Push Notifications", style: TextStyle(color: Colors.white)),
            value: _notificationsEnabled,
            onChanged: (val) => setState(() => _notificationsEnabled = val),
            activeColor: Colors.orangeAccent,
          ),
          const Divider(color: Colors.white10),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
            title: const Text("Delete Account", style: TextStyle(color: Colors.redAccent)),
            onTap: () {
              // Logic to delete account
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(color: Colors.orangeAccent, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.2),
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
          children: [
            _languageOption("English"),
            _languageOption("Arabic"),
            _languageOption("Spanish"),
          ],
        ),
      ),
    );
  }

  Widget _languageOption(String lang) {
    return ListTile(
      title: Text(lang, style: const TextStyle(color: Colors.white)),
      onTap: () {
        setState(() => _selectedLanguage = lang);
        Navigator.pop(context);
      },
    );
  }
}
