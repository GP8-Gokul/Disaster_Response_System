import 'package:flutter/material.dart';
import 'package:demoproject6/services/route_service/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Color color1 = const Color.fromRGBO(248, 249, 250, 1);
  final Color color2 = const Color.fromRGBO(173, 181, 189, 1);
  final Color color3 = const Color.fromRGBO(16, 17, 18, 1);
  final Color color4 = const Color.fromRGBO(52, 58, 64, 1);
  final Color color5 = const Color.fromRGBO(108, 117, 125, 1);

  void _showNotification(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(child: Text(text)),
        backgroundColor: color3,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HOME',
              style: TextStyle(
                color: Color.fromRGBO(248, 249, 250, 1),
                fontSize: 35,
                fontWeight: FontWeight.bold,
              )),
          backgroundColor: color4,
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu),
              iconColor: color2,
              onSelected: (value) {
                if (value == 'logout') {
                  _showNotification(context, 'Logout not yet implemented');
                }
              },
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout',
                        style: TextStyle(
                          color: Color.fromRGBO(248, 249, 250, 1),
                        )),
                  ),
                ];
              },
              color: color5,
            ),
          ],
        ),
        backgroundColor: color5,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildButton('SELECT'),
                const SizedBox(height: 15),
                buildButton('UPDATE'),
                const SizedBox(height: 15),
                buildButton('INSERT'),
                const SizedBox(height: 15),
                buildButton('DELETE'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(String text) {
    return SizedBox(
      width: 250,
      height: 60,
      child: ElevatedButton(
        onPressed: () {
          if (text == 'SELECT') {
            Navigator.pushNamed(context, select_page);
          } else if (text == 'UPDATE') {
            _showNotification(context, 'UPDATE not yet implemented');
          } else if (text == 'INSERT') {
            _showNotification(context, 'INSERT not yet implemented');
          } else if (text == 'DELETE') {
            _showNotification(context, 'DELETE not yet implemented');
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Circular corners
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
            color: color3,
          ),
        ),
      ),
    );
  }
}
