import 'package:flutter/material.dart';

class DisplayVolunteer extends StatelessWidget {
  final Map<String, dynamic> volunteer;

  const DisplayVolunteer({super.key, required this.volunteer});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: const Color.fromARGB(255, 35, 33, 33),
      color: const Color.fromARGB(255, 67, 63, 63),
      margin: const EdgeInsets.all(16.0), // Card color
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Volunteer ID: ${volunteer['volunteer_id']}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Volunteer Name: ${volunteer['volunteer_name']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Contact : ${volunteer['volunteer_contact_info']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Skills: ${volunteer['volunteer_skills']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Availability : ${volunteer['volunteer_availability_status']}',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Event ID : ${volunteer['event_id']}',
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
