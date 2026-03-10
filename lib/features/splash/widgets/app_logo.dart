import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          "https://unblast.com/wp-content/uploads/2025/07/instagram-logo-colored.jpg",
          height: 120,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}