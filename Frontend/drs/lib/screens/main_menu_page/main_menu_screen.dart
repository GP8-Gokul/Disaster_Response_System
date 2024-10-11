import 'package:drs/screens/aid_distribution_page/aid_distribution_screen.dart';
import 'package:drs/screens/disaster_events_page/disaster_events_screen.dart';
import 'package:drs/screens/Incident_reports_page/incident_reports_screen.dart';
import 'package:drs/screens/login_page/login_screen.dart';
import 'package:drs/screens/resources_page/resource_screen.dart';
import 'package:drs/screens/volunteers_page/volunteers_screen.dart';
import 'package:drs/services/api/root_api.dart';
import 'package:drs/widgets/background_image.dart';
import 'package:drs/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> launchGooglePay(amount) async {
  final String upiId = 'gokulpjayan2004-1@okicici';
  final String payeeName = 'Gokul P Jayan';
  final String googlePayUri =
      'upi://pay?pa=$upiId&pn=$payeeName&am=$amount&cu=INR';
  final Uri launchUri = Uri.parse(googlePayUri);

  if (await canLaunchUrl(launchUri)) {
    await launchUrl(launchUri);
  } else {
    throw 'Could not launch $googlePayUri';
  }
}

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
            leading: IconButton(
                icon: const Icon(Icons.help),
              color: Colors.white,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController amountController = TextEditingController(text: '10');
                    return AlertDialog(
                      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 3.0),
                      ),
                      title: const Text('Support the Initiative',
                        style: TextStyle(color: Colors.black),
                      ),
                      content: 
                        Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return Slider(
                            value: double.parse(amountController.text.isEmpty ? '100' : amountController.text),
                            min: 10,
                            max: 1000,
                            divisions: 100,
                            label: amountController.text,
                            onChanged: (double value) {
                              setState(() {
                              amountController.text = value.toStringAsFixed(0);
                              });
                            },
                            );
                          },
                          ),
                          TextField(
                          controller: amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Amount',
                            hintText: 'Enter amount',
                          ),
                          ),
                          SizedBox(height: 10),
                          TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.black.withOpacity(0.7),
                              side: const BorderSide(color: Colors.white, width: 2),
                            ),
                          child: const Text('Donate',
                            style: TextStyle(color: Colors.greenAccent),
                          ),

                          onPressed: () {
                            launchGooglePay(amountController.text);
                          },
                          ),
                        ],
                        ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Close'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
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
                    Row(
                      children: [
                        CustomText(text: 'logged in as: $userName'),
                      ],
                    ),
                    const SizedBox(height: 10),
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
                            ResourceScreenB.routeName),
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
                        const SizedBox(height: 10),
                        buildCard(
                          context,
                          'AID DISTRIBUTION',
                          'assets/icons/aid.png',
                          AidDistributionScreen.routeName,
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
          side: const BorderSide(color: Colors.white, width: 2),
        ),
        color: const Color.fromARGB(91, 0, 0, 0),
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
                  color: Colors.white,
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
