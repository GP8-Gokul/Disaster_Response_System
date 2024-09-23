import 'package:flutter/material.dart';

class AidDistributionScreen extends StatefulWidget {
  const AidDistributionScreen({super.key});
  static String routeName = 'aid-distribution';

  @override
  State<AidDistributionScreen> createState() => _AidDistributionScreenState();
}

class _AidDistributionScreenState extends State<AidDistributionScreen> {
  @override
  Widget build(BuildContext context) {
    return const Text('Aid Distribution Screen');
  }
}