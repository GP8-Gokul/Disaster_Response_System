import 'package:flutter/material.dart';

class DisplayDisasterEvents extends StatelessWidget {
  final Map<String, dynamic> event;

  const DisplayDisasterEvents({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      shadowColor: const Color.fromARGB(255, 35, 33, 33),
      color: const Color.fromARGB(255, 67, 63, 63),
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Event ID',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              event['event_id'].toString(),
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(color: Colors.white24, height: 24),
            const Text(
              'Event Name',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              event['event_name'],
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const Divider(color: Colors.white24, height: 24),
            const Text(
              'Event Type',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              event['event_type'],
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const Divider(color: Colors.white24, height: 24),
            const Text(
              'Location',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              event['location'],
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const Divider(color: Colors.white24, height: 24),
            const Text(
              'Start Date',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              event['start_date'],
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const Divider(color: Colors.white24, height: 24),
            const Text(
              'End Date',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              event['end_date'],
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const Divider(color: Colors.white24, height: 24),
            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              event['description'] ?? 'No description available',
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
