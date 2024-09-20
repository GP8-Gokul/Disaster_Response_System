import 'package:flutter/material.dart';
import 'package:demoproject6/services/api.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Disaster Events'),
      ),
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
              itemBuilder: (context, index) {
                var event = snapshot.data![index];
                return ListTile(
                  title: Text(event['event_name']),
                  subtitle: Text('Location: ${event['location']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
