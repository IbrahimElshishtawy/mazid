import 'package:flutter/material.dart';
import 'package:mazid/pages/auth/widget/from/login_social_buttons.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        SizedBox(height: 30),

        Text(
          "Mazid",
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          "Discover, Bid & Win ",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 10),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Join auctions, exchange products, or adopt what you love ",
            style: TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
            textAlign: TextAlign.center,
          ),
        ),

        SizedBox(height: 40),
        LoginSocialButtons(),
      ],
    );
  }
}
