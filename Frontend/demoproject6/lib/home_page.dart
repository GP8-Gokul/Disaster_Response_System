import 'package:flutter/material.dart';
import 'package:demoproject6/services/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disaster & Resources'),
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
          ],
        ),
      ),
    );
  }
}
