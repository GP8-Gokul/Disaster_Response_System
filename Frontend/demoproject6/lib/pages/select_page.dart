import 'package:flutter/material.dart';
import 'package:demoproject6/services/routes.dart';

class SelectPage extends StatelessWidget {
  const SelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SELECTION'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, disaster_events);
              },
              child: const Text('Disaster Events'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, resources);
              },
              child: const Text('Resources'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, volunteers);
              },
              child: const Text('Volunteers'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, aid_distribution);
              },
              child: const Text('Aid Distribution'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, incident_reports);
              },
              child: const Text('Incident Reports'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, record_by_id);
              },
              child: const Text('Record by ID'),
            ),
          ],
        ),
      ),
    );
  }
}
