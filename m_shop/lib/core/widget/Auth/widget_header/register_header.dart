import 'package:flutter/material.dart';
import 'package:m_shop/core/widget/Auth/widget_form/login_social_buttons.dart';

class RegisterHeader extends StatelessWidget {
  const RegisterHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 20),

        // name of the app
        Text(
          "Create your Mazid account",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 10),

        // description
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Start joining auctions, exchange items, and adopt products you love ",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
          ),
        ),
        SizedBox(height: 15),
        LoginSocialButtons(),
        SizedBox(height: 14),
      ],
    );
  }
}
