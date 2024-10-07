import 'package:drs/screens/aid_distribution_page/aid_distribution_screen.dart';
import 'package:drs/screens/disaster_events_page/disaster_events_screen.dart';
import 'package:drs/screens/Incident_reports_page/incident_reports_screen.dart';
import 'package:drs/screens/login_page/login_screen.dart';
import 'package:drs/screens/resources_page/resources_screen.dart';
import 'package:drs/screens/volunteers_page/volunteers_screen.dart';
import 'package:drs/widgets/background_image.dart';
import 'package:flutter/material.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});
  static String routeName = 'main-menu';

  void navigateToScreen(BuildContext context, String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  // ignore: non_constant_identifier_names
  void Logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: const Text(
            'Log Out',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Do you actually want to log out?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.greenAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, LoginScreen.routeName);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundImage(imageName: 'main_menu_background'),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text(
              'DISASTER RESPONSE',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                decorationThickness: 2.0,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                color: Colors.white,
                onPressed: () => Logout(context),
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: const Text(
                        'The Disaster Response System (DRS) is a comprehensive platform designed to assist in managing disaster response activities. It facilitates the distribution of aid, efficient management of resources, accurate reporting of incidents, and effective oversight of volunteers, ensuring a coordinated and timely response to disasters.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      color: Colors.white,
                      thickness: 2.0,
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        buildCard(
                          context,
                          'RESOURCES',
                          'assets/icons/resources.png',
                          ResourcesScreen.routeName,
                        ),
                        const SizedBox(height: 10),
                        buildCard(
                          context,
                          'DISASTER EVENTS',
                          'assets/icons/disaster.png',
                          DisasterEventsScreen.routeName,
                        ),
                        const SizedBox(height: 10),
                        buildCard(
                          context,
                          'INCIDENT REPORTS',
                          'assets/icons/incident.png',
                          IncidentReportsScreen.routeName,
                        ),
                        const SizedBox(height: 10),
                        buildCard(
                          context,
                          'VOLUNTEERS',
                          'assets/icons/volunteers.png',
                          VolunteersScreen.routeName,
                        ),
                      ],
                    ),
                  ],
                ),
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
          side: const BorderSide(
              color: Color.fromARGB(255, 221, 200, 9), width: 2),
        ),
        color: const Color.fromARGB(255, 54, 8, 145),
        child: Container(
          width: double.infinity,
          height: 80,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 221, 200, 9),
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
