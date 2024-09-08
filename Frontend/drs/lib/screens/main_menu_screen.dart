import 'package:drs/screens/aid_distribution_screen.dart';
import 'package:drs/screens/disaster_events_screen.dart';
import 'package:drs/screens/incident_reports_screen.dart';
import 'package:drs/screens/resources_screen.dart';
import 'package:drs/screens/volunteers_screen.dart';
import 'package:drs/widgets/main_menu_button.dart';
import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});
  static String routeName = 'main-menu';

  void aidDistributionScreen(BuildContext context) {
    Navigator.pushNamed(context, AidDistributionScreen.routeName);
  }

  void resourcesScreen(BuildContext context) {
    Navigator.pushNamed(context, ResourcesScreen.routeName);
  }

  void disasterEventsScreen(BuildContext context) {
    Navigator.pushNamed(context, DisasterEventsScreen.routeName);
  }

  void incidentReportsScreen(BuildContext context) {
    Navigator.pushNamed(context, IncidentReportsScreen.routeName);
  }

  void volunteersScreen(BuildContext context) {
    Navigator.pushNamed(context, VolunteersScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        const Text('Main Menu Screen'),
        MainMenuButton(onTap: () => aidDistributionScreen(context), text: 'Aid Distribution'),
        MainMenuButton(onTap: () => resourcesScreen(context), text: 'Resources'),
        MainMenuButton(onTap: () => disasterEventsScreen(context), text: 'Disaster Events'),
        MainMenuButton(onTap: () => incidentReportsScreen(context), text: 'Incident Reports'),
        MainMenuButton(onTap: () => volunteersScreen(context), text: 'Volunteers'),
      ],),
    );
  }
}