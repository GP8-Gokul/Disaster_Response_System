import 'package:flutter/material.dart';

class IncidentReportsScreen extends StatefulWidget {
  const IncidentReportsScreen({super.key});
  static String routeName = 'incident-reports'; 

  @override
  State<IncidentReportsScreen> createState() => _IncidentReportsScreenState();
}

class _IncidentReportsScreenState extends State<IncidentReportsScreen> {
  @override
  Widget build(BuildContext context) {
    return const Text('Incident Reports Screen');
  }
}