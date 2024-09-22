import 'dart:convert';
import 'package:drs/services/api/disaster_event/disaster_event_api.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

class DisasterEventsScreen extends StatefulWidget {
  const DisasterEventsScreen({super.key});
  static String routeName = 'disaster-events';

  @override
  State<DisasterEventsScreen> createState() => _DisasterEventsScreenState();
}

class _DisasterEventsScreenState extends State<DisasterEventsScreen> {
  late Future<List<Map<String, dynamic>>> futureDisasterEvents;

  @override
  void initState() {
    super.initState();
    futureDisasterEvents = fetchDisasterEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          appBar: AppBar(
            title: const Text('Disaster Events'),
            centerTitle: true,
            backgroundColor: Colors.transparent,
          ),
          body: FutureBuilder<List<Map<String, dynamic>>>(
            future: futureDisasterEvents,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No disaster events found.'));
              } else {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final event = snapshot.data![index];
                    return ListTile(
                      title: Text(event['event_name']),
                      subtitle: Text(event['location']),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(event['event_name']),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Type: ${event['event_type']}'),
                                  Text('Location: ${event['location']}'),
                                  Text('Start Date: ${event['start_date']}'),
                                  Text('End Date: ${event['end_date']}'),
                                  Text('Description: ${event['description']}'),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        TextEditingController
                                            eventTypeController =
                                            TextEditingController(
                                                text: event['event_type']);
                                        TextEditingController
                                            locationController =
                                            TextEditingController(
                                                text: event['location']);
                                        TextEditingController
                                            startDateController =
                                            TextEditingController(
                                                text: event['start_date']);
                                        TextEditingController
                                            endDateController =
                                            TextEditingController(
                                                text: event['end_date']);
                                        TextEditingController
                                            descriptionController =
                                            TextEditingController(
                                                text: event['description']);

                                        return AlertDialog(
                                          title: Text(
                                              'Edit ${event['event_name']}'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text('Event Type:'),
                                              TextField(
                                                controller: eventTypeController,
                                              ),
                                              Text('Location:'),
                                              TextField(
                                                controller: locationController,
                                              ),
                                              Text('Start Date:'),
                                              TextField(
                                                controller: startDateController,
                                              ),
                                              Text('End Date:'),
                                              TextField(
                                                controller: endDateController,
                                              ),
                                              Text('Description:'),
                                              TextField(
                                                controller:
                                                    descriptionController,
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                // Implement save functionality here
                                                http.post(
                                                  Uri.parse(
                                                      'http://10.0.2.2:5000/update'),
                                                  headers: {
                                                    'Content-Type':
                                                        'application/json'
                                                  },
                                                  body: jsonEncode({
                                                    'table': 'disaster_events',
                                                    'column': 'event_type',
                                                    'value': eventTypeController
                                                        .text,
                                                    'condition_column':
                                                        'event_id',
                                                    'condition_value':
                                                        event['event_id'],
                                                  }),
                                                );

                                                http
                                                    .post(
                                                  Uri.parse(
                                                      'http://10.0.2.2:5000/update'),
                                                  headers: {
                                                    'Content-Type':
                                                        'application/json'
                                                  },
                                                  body: jsonEncode({
                                                    'table': 'disaster_events',
                                                    'column': 'location',
                                                    'value':
                                                        locationController.text,
                                                    'condition_column':
                                                        'event_id',
                                                    'condition_value':
                                                        event['event_id'],
                                                  }),
                                                )
                                                    .then((response) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                        content: Text(
                                                            'Response: ${response.body}')),
                                                  );
                                                });

                                                http.post(
                                                  Uri.parse(
                                                      'http://10.0.2.2:5000/update'),
                                                  headers: {
                                                    'Content-Type':
                                                        'application/json'
                                                  },
                                                  body: jsonEncode({
                                                    'table': 'disaster_events',
                                                    'column': 'start_date',
                                                    'value': startDateController
                                                        .text,
                                                    'condition_column':
                                                        'event_id',
                                                    'condition_value':
                                                        event['event_id'],
                                                  }),
                                                );

                                                http.post(
                                                  Uri.parse(
                                                      'http://10.0.2.2:5000/update'),
                                                  headers: {
                                                    'Content-Type':
                                                        'application/json'
                                                  },
                                                  body: jsonEncode({
                                                    'table': 'disaster_events',
                                                    'column': 'end_date',
                                                    'value':
                                                        endDateController.text,
                                                    'condition_column':
                                                        'event_id',
                                                    'condition_value':
                                                        event['event_id'],
                                                  }),
                                                );

                                                http.post(
                                                  Uri.parse(
                                                      'http://10.0.2.2:5000/update'),
                                                  headers: {
                                                    'Content-Type':
                                                        'application/json'
                                                  },
                                                  body: jsonEncode({
                                                    'table': 'disaster_events',
                                                    'column': 'description',
                                                    'value':
                                                        descriptionController
                                                            .text,
                                                    'condition_column':
                                                        'event_id',
                                                    'condition_value':
                                                        event['event_id'],
                                                  }),
                                                );
                                                setState(() {
                                                  futureDisasterEvents =
                                                      fetchDisasterEvents();
                                                });
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text('Edit'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                );
              }
            },
          ),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }
}
