import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class CustomLoadingAnimation extends StatelessWidget {
  const CustomLoadingAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: RiveAnimation.asset(
        'assets/rive/loading_symbol.riv',
      ),
    );
  }
}