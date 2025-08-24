import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPageAnimated extends StatelessWidget {
  final Color textColor;

  const IntroPageAnimated({super.key, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 🔹 الأنيميشن من الإنترنت
              Lottie.network(
                'https://pin.it/559zLOyVx', // ضع هنا اللينك الصحيح للـ JSON
                width: 250,
                height: 250,
                repeat: true,
                animate: true,
              ),

              const SizedBox(height: 30),

              // 🔹 مقدمة البرنامج بالعامي (قسمتها 3 صفحات تقريبية)
              Text(
                "أهلا بيك في مزاد 👋\n"
                "هنا هتلاقي كل الجديد والمميز ✨\n"
                "مزادات حقيقية وفرص ما تتفوتش 👌",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
