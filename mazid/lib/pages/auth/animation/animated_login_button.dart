import 'package:flutter/material.dart';

class AnimatedLoginButton extends StatelessWidget {
  final AnimationController animController;
  final VoidCallback onPressed;
  final bool isLoading;
  final ThemeData theme;

  const AnimatedLoginButton({
    super.key,
    required this.animController,
    required this.onPressed,
    required this.isLoading,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animController,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 - (animController.value * 0.1),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.primaryColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    "Login",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
          ),
        );
      },
    );
  }
}
