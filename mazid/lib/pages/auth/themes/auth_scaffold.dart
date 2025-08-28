// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mazid/pages/auth/animation/login_animation.dart';

class AuthPalette {
  static List<Color> background(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? const [Color(0xFF0B1220), Color(0xFF0E2A3E)]
        : const [Color(0xFFEFF6FF), Color(0xFFBFE9FF)];
  }

  static Color glassBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? Colors.white.withOpacity(0.06)
      : Colors.white.withOpacity(0.4);
}

class AuthScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget form;
  final Widget? footer;

  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.form,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = AuthPalette.background(context);

    return BackgroundAnimation(
      colors: gradient,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: _GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Opacity(
                      opacity: 0.9,
                      child: Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: 20),
                    form,
                    if (footer != null) ...[
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      footer!,
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  final Widget child;
  const _GlassCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AuthPalette.glassBg(context),
            borderRadius: BorderRadius.circular(24),
          ),
          child: child,
        ),
      ),
    );
  }
}
