import 'package:flutter/material.dart';

Future<void> showProfileInfoSheet({required BuildContext context, required String title, required String subtitle, required List<Widget> children}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [BoxShadow(color: Color(0x1A0F172A), blurRadius: 30, offset: Offset(0, 16))],
      ),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.78),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(width: 54, height: 5, decoration: BoxDecoration(color: const Color(0xFFD6E3DF), borderRadius: BorderRadius.circular(999))),
                const SizedBox(height: 16),
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(subtitle, style: const TextStyle(color: Color(0xFF667B75), height: 1.5)),
                const SizedBox(height: 18),
                ...children,
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class ProfileSheetLine extends StatelessWidget {
  const ProfileSheetLine({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFF7FAF9), borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
            Text(value, style: const TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w900)),
          ],
        ),
      ),
    );
  }
}

class ProfileSheetMessage extends StatelessWidget {
  const ProfileSheetMessage({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFEFFBF7), borderRadius: BorderRadius.circular(18)),
      child: Text(message, style: const TextStyle(color: Color(0xFF30413D), height: 1.5)),
    );
  }
}
