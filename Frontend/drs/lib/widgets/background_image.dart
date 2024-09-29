import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
    child: Image.asset(
      'assets/images/6114100.jpg',
      fit: BoxFit.cover,
    ),
  );
  }
}