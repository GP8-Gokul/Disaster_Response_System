import 'package:demoproject6/services/route_service/routes.dart';
import 'package:flutter/material.dart';
import 'package:demoproject6/services/image_service.dart';

class SelectPage extends StatelessWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('SELECTION',
              style: TextStyle(
                color: Color.fromRGBO(248, 249, 250, 1),
                fontSize: 35,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: const Color.fromRGBO(16, 17, 18, 1),
        ),
        backgroundColor: const Color.fromRGBO(108, 117, 125, 1),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildCard(disaster_event, const Color.fromRGBO(16, 17, 18, 1), () {
                    Navigator.pushNamed(context, disaster_events);
                  }),
                  const SizedBox(height: 20),
                  buildCard(resource, const Color.fromRGBO(173, 181, 189, 1), () {
                    Navigator.pushNamed(context, resources);
                  }),
                  const SizedBox(height: 20),
                  buildCard(volunteer, const Color.fromRGBO(52, 58, 64, 1), () {
                    Navigator.pushNamed(context, volunteers);
                  }),
                  const SizedBox(height: 20),
                  buildCard(aid_distributions, const Color.fromRGBO(108, 117, 125, 1), () {
                    Navigator.pushNamed(context, aid_distribution);
                  }),
                  const SizedBox(height: 20),
                  buildCard(incident_report, const Color.fromRGBO(16, 17, 18, 1), () {
                    Navigator.pushNamed(context, incident_reports);
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCard(String text, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image(image: AssetImage(text), fit: BoxFit.cover),
      ),
    );
  }
}
