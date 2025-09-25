import 'package:flutter/material.dart';
import 'package:m_shop/page/action/ui/intro_Auction_page.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'auction_home_page.dart';

class AuctionEntryPage extends StatelessWidget {
  const AuctionEntryPage({super.key});

  Future<bool> _hasAccepted() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = Supabase.instance.client.auth.currentUser?.id ?? 'global';
    return prefs.getBool('auction_terms_accepted_$userId') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasAccepted(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            backgroundColor: Colors.black,
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snap.data == true) {
          return const AuctionHomePage();
        }
        return const AuctionTermsPage();
      },
    );
  }
}
