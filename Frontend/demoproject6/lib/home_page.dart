import 'package:flutter/material.dart';
import 'package:demoproject6/services/routes.dart';

class HomePage extends StatelessWidget {
  final Color color1 = const Color.fromRGBO(3, 102, 102, 1);
  final Color color2 = const Color.fromRGBO(36, 130, 119, 1);
  final Color color3 = const Color.fromRGBO(70, 157, 137, 1);
  final Color color4 = const Color.fromRGBO(103, 185, 154, 1);
  final Color color5 = const Color.fromRGBO(136, 212, 171, 1);

  const HomePage({super.key}); // Fifth color (not used yet)

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: color3,
        appBar: AppBar(
          title: const Center(child: Text('Home Page')),
          backgroundColor: color1,
        ),
        body: Padding(
          padding:
              const EdgeInsets.all(16.0), // Padding around the entire layout
          child: OrientationBuilder(
            builder: (context, orientation) {
              return GridView.count(
                crossAxisCount: orientation == Orientation.portrait
                    ? 2
                    : 2, // 2x2 layout for both orientations
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: <Widget>[
                  buildCard('SELECT', color1, context),
                  buildCard('UPDATE', color1, context),
                  buildCard('INSERT', color1, context),
                  buildCard('DELETE', color1, context),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildCard(String text, Color color, BuildContext context) {
    return Card(
      color: color,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          if (text == 'SELECT') {
            Navigator.pushNamed(context, select_page);
          } else {}
        },
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
