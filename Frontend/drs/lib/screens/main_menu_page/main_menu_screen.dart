import 'package:drs/screens/aid_distribution_page/aid_distribution_screen.dart';
import 'package:drs/screens/disaster_events_page/disaster_events_screen.dart';
import 'package:drs/screens/Incident_reports_page/incident_reports_screen.dart';
import 'package:drs/screens/resources_page/resources_screen.dart';
import 'package:drs/screens/volunteers_page/volunteers_screen.dart';
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
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
        'assets/images/background.jpg',
        fit: BoxFit.cover,
          ),
        ),
        Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text(
            'Disaster Response',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              decorationThickness: 2.0,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
          // Description with glowing effect
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10.0),
             
            ),
            child: const Text(
              'The Disaster Response System (DRS) is a platform that helps in managing disaster response activities. It provides a way to distribute aid, manage resources, report incidents, and manage volunteers.',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.black,
            thickness: 2.0,
            height: 20.0,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                MainMenuButton(
            onTap: () => aidDistributionScreen(context),
            text: 'Aid Distribution',
                ),
                const SizedBox(height: 5),
                MainMenuButton(
            onTap: () => resourcesScreen(context),
            text: 'Resources',
                ),
                const SizedBox(height: 5),
                MainMenuButton(
            onTap: () => disasterEventsScreen(context),
            text: 'Disaster Events',
                ),
                const SizedBox(height: 5),
                MainMenuButton(
            onTap: () => incidentReportsScreen(context),
            text: 'Incident Reports',
                ),
                const SizedBox(height: 5),
                MainMenuButton(
            onTap: () => volunteersScreen(context),
            text: 'Volunteers',
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
              ],
            ),
          ),
        ),
  
      ),
      ],
    );
  }
}
