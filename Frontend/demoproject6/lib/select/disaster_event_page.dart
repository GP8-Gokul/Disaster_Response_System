import 'package:flutter/material.dart';
import 'package:demoproject6/services/api_service/api_select.dart';
import 'package:demoproject6/services/route_service/hero_dialog_route.dart';

class DisasterEventsPage extends StatefulWidget {
  const DisasterEventsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DisasterEventsPageState createState() => _DisasterEventsPageState();
}

class _DisasterEventsPageState extends State<DisasterEventsPage> {
  late Future<List<dynamic>> disasterEvents;

  @override
  void initState() {
    super.initState();
    disasterEvents = ApiService().getDisasterEvents();
  }

  @override
  Widget build(BuildContext context) {
    const Color color1 = Color.fromRGBO(248, 249, 250, 1);
    const Color color2 = Color.fromRGBO(173, 181, 189, 1);
    const Color color3 = Color.fromRGBO(16, 17, 18, 1);
    const Color color4 = Color.fromRGBO(52, 58, 64, 1);
    const Color color5 = Color.fromRGBO(108, 117, 125, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Disaster Events',
            style: TextStyle(
              color: Color.fromRGBO(248, 249, 250, 1),
              fontSize: 35,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: color3,
      ),
      backgroundColor: color5,
      body: FutureBuilder<List<dynamic>>(
        future: disasterEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                var event = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 15),
                  decoration: BoxDecoration(
                    color: color2,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      'Event Name: ${event['event_name']}',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Event ID: ${event['event_id']}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          'Event Type: ${event['event_type']}',
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                    onTap: () {
                      HeroDialogRoute(
                        builder: (context) => buildCard(event),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Widget buildCard(Map<String, dynamic> event) {
    const Color color1 = Color.fromRGBO(52, 58, 64, 1);

    return Card(
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      color: color1, // Card color
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event ID: ${event['event_id']}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Event Name: ${event['event_name']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Event Type: ${event['event_type']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Location: ${event['location']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start Date: ${event['start_date']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'End Date: ${event['end_date']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Description: ${event['description']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
