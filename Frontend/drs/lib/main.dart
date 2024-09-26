import 'package:drs/screens/aid_distribution_page/aid_distribution_screen.dart';
import 'package:drs/screens/disaster_events_page/disaster_events_screen.dart';
import 'package:drs/screens/Incident_reports_page/incident_reports_screen.dart';
import 'package:drs/screens/main_menu_page/main_menu_screen.dart';
import 'package:drs/screens/resources_page/resources_screen.dart';
import 'package:drs/screens/volunteers_page/volunteers_screen.dart';
import 'package:drs/screens/login_page/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DRS',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        MainMenuScreen.routeName: (context) => const MainMenuScreen(),
        AidDistributionScreen.routeName: (context) =>
            const AidDistributionScreen(),
        DisasterEventsScreen.routeName: (context) =>
            const DisasterEventsScreen(),
        IncidentReportsScreen.routeName: (context) =>
            const IncidentReportsScreen(),
        ResourcesScreen.routeName: (context) => const ResourcesScreen(),
        VolunteersScreen.routeName: (context) => const VolunteersScreen(),
        LoginScreen.routeName: (context) => const LoginScreen(),
      },
      initialRoute: MainMenuScreen.routeName,
    );
  }
}
