import 'package:flutter/material.dart';
import 'package:demoproject6/services/routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FUNCTIONS'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, select_page);
              },
              child: const Text('SELECT'),
            ),
          ],
        ),
      ),
    );
  }
}
