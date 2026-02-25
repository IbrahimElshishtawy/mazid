// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_shop/core/cubit/navigation/navigation_cubit.dart';
import 'package:m_shop/core/cubit/product/product_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:m_shop/core/widget/home/widget/AppBar_widget.dart';
import 'package:m_shop/core/widget/home/widget/bottom_NavigationBar.dart';
import 'package:m_shop/page/home/drawer/ui/drawer_menu.dart';
import 'package:m_shop/page/home/ui/home_ui.dart';

class HomeContents extends StatefulWidget {
  const HomeContents({super.key});

  @override
  _HomeContentsState createState() => _HomeContentsState();
}

class _HomeContentsState extends State<HomeContents> {
  bool _booting = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _checkAuctionTerms();
      if (!mounted) return;
      setState(() => _booting = false);
    });
  }

  Future<void> _checkAuctionTerms() async {
    final prefs = await SharedPreferences.getInstance();
    final accepted = prefs.getBool('auction_terms_accepted') ?? false;
    if (accepted || !mounted) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(ctx).dividerColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text('شروط المزاد', style: Theme.of(ctx).textTheme.titleLarge),
              const SizedBox(height: 12),
              Text(
                'بالدخول على المزادات، أنت توافق على الشروط والأحكام المعروضة.',
                style: Theme.of(ctx).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('إلغاء'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await SharedPreferences.getInstance().then(
                          (p) => p.setBool('auction_terms_accepted', true),
                        );
                        if (context.mounted) Navigator.of(ctx).pop();
                      },
                      child: const Text('موافقة'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_booting) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: Colors.orange)),
      );
    }

    return BlocBuilder<NavigationCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          appBar: AppbarWidget(
            onSearchChanged: (query) => context.read<ProductCubit>().filterProducts(query, null),
          ),
          backgroundColor: Colors.black,
          drawer: const DrawerMenu(favoriteProducts: []),
          body: const HomeUI(),
          bottomNavigationBar: BottomNavigationbarWidget(
            currentIndex: currentIndex,
            onTap: (index) => context.read<NavigationCubit>().setIndex(index),
          ),
        );
      },
    );
  }
}
