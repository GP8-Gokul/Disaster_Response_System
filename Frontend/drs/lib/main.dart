import 'package:drs/screens/aid_distribution_screen.dart';
import 'package:drs/screens/disaster_events_screen.dart';
import 'package:drs/screens/incident_reports_screen.dart';
import 'package:drs/screens/main_menu_screen.dart';
import 'package:drs/screens/resources_screen.dart';
import 'package:drs/screens/volunteers_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'DRS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes:{
        MainMenuScreen.routeName : (context) => const MainMenuScreen(),
        AidDistributionScreen.routeName : (context) => const AidDistributionScreen(),
        DisasterEventsScreen.routeName : (context) => const DisasterEventsScreen(),
        IncidentReportsScreen.routeName : (context) => const IncidentReportsScreen(),
        ResourcesScreen.routeName : (context) => const ResourcesScreen(),
        VolunteersScreen.routeName : (context) => const VolunteersScreen(),
      },
      initialRoute: MainMenuScreen.routeName,
    );
  }
}

