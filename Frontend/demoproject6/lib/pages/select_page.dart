import 'package:flutter/material.dart';
import 'package:demoproject6/services/routes.dart';

class SelectPage extends StatelessWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color color1 = Color.fromRGBO(3, 102, 102, 1);
    const Color color2 = Color.fromRGBO(36, 130, 119, 1);
    const Color color3 = Color.fromRGBO(70, 157, 137, 1);
    const Color color4 = Color.fromRGBO(103, 185, 154, 1);
    const Color color5 = Color.fromRGBO(136, 212, 171, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('SELECTION'),
        backgroundColor: color1,
      ),
      backgroundColor: color3,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            // Makes the page scrollable
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildCard('Disaster Events', color1, () {
                  Navigator.pushNamed(context, disaster_events);
                }),
                const SizedBox(height: 20),
                buildCard('Resources', color1, () {
                  Navigator.pushNamed(context, resources);
                }),
                const SizedBox(height: 20),
                buildCard('Volunteers', color1, () {
                  Navigator.pushNamed(context, volunteers);
                }),
                const SizedBox(height: 20),
                buildCard('Aid Distribution', color1, () {
                  Navigator.pushNamed(context, aid_distribution);
                }),
                const SizedBox(height: 20),
                buildCard('Incident Reports', color1, () {
                  Navigator.pushNamed(context, incident_reports);
                }),
                const SizedBox(height: 20),
                buildCard('Record by ID', color1, () {
                  Navigator.pushNamed(context, record_by_id);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to create a styled card
  Widget buildCard(String text, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: color,
        child: Container(
          height: 80, // Card height
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
