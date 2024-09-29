import 'package:drs/screens/aid_distribution_page/aid_distribution_screen.dart';
import 'package:drs/screens/disaster_events_page/disaster_events_screen.dart';
import 'package:drs/screens/Incident_reports_page/incident_reports_screen.dart';
import 'package:drs/screens/login_page/login_screen.dart';
import 'package:drs/screens/resources_page/resources_screen.dart';
import 'package:drs/screens/volunteers_page/volunteers_screen.dart';
import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});
  static String routeName = 'main-menu';

  void navigateToScreen(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
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
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                const Text(
                    'Disaster Response',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationThickness: 2.0,
                  ),
                ),
                const SizedBox(width: 50),
                FloatingActionButton(
                  
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: const Icon(Icons.logout),
                  onPressed: () {
                    Navigator.pushNamed(context, LoginScreen.routeName);
                  },
                ),
              ],
                
            ),
            centerTitle: true,
            
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Text(
                      'The Disaster Response System (DRS) helps in managing disaster response activities like distributing aid, managing resources, reporting incidents, and overseeing volunteers.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Divider(
                    color: Colors.white,
                    thickness: 2.0,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildCard(
                              context,
                              'Aid Distribution',
                              'assets/icons/aid.png',
                              AidDistributionScreen.routeName,
                            ),
                            buildCard(
                              context,
                              'Resources',
                              'assets/icons/resources.png',
                              ResourcesScreen.routeName,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            buildCard(
                              context,
                              'Disaster Events',
                              'assets/icons/disaster.png',
                              DisasterEventsScreen.routeName,
                            ),
                            buildCard(
                              context,
                              'Incident Reports',
                              'assets/icons/incident.png',
                              IncidentReportsScreen.routeName,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.center,
                          child: buildCard(
                            context,
                            'Volunteers',
                            'assets/icons/volunteers.png',
                            VolunteersScreen.routeName,
                          ),
                        ),
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

  Widget buildCard(
      BuildContext context, String title, String iconPath, String routeName) {
    return GestureDetector(
      onTap: () => navigateToScreen(context, routeName),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.white.withOpacity(0.9),
        child: Container(
          width: 150,
          height: 80,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
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
