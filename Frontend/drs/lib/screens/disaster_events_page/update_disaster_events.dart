import 'package:drs/services/api/disaster_event_api.dart';
import 'package:flutter/material.dart';
import 'dart:async';

Future<Map<String, String>?> updateDisasterEventsDialog(BuildContext context,
    Function fetchDisasterEvents, Map<String, dynamic> event, response) async {
  Completer<Map<String, String>?> completer = Completer();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController disasterNameController =
          TextEditingController(text: event['event_name']);
      TextEditingController disasterTypeController =
          TextEditingController(text: event['event_type']);
      TextEditingController disasterLocationController =
          TextEditingController(text: event['location']);
      TextEditingController disasterStartDateController =
          TextEditingController(text: event['start_date']);
      TextEditingController disasterEndDateController =
          TextEditingController(text: event['end_date']);
      TextEditingController disasterDescriptionController =
          TextEditingController(text: event['description']);

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text(
          'Update Disaster Event',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: disasterNameController,
                decoration: InputDecoration(
                  labelText: 'Disaster Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: disasterTypeController,
                decoration: InputDecoration(
                  labelText: 'Disaster Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: disasterLocationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: disasterStartDateController,
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    disasterStartDateController.text =
                        pickedDate.toIso8601String().substring(0, 10);
                  }
                },
              ),
              const SizedBox(height: 15),
              TextField(
                controller: disasterEndDateController,
                decoration: InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                readOnly: true,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    disasterEndDateController.text =
                        pickedDate.toIso8601String().substring(0, 10);
                  }
                },
              ),
              const SizedBox(height: 15),
              TextField(
                controller: disasterDescriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              completer.complete(null);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await updateDisasterEvents(
                event['event_id'],
                disasterNameController.text,
                disasterTypeController.text,
                disasterLocationController.text,
                disasterStartDateController.text,
                disasterEndDateController.text,
                disasterDescriptionController.text,
              );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
              completer.complete({
                'eventId': event['event_id'],
                'disasterName': disasterNameController.text,
                'disasterType': disasterTypeController.text,
                'disasterLocation': disasterLocationController.text,
                'disasterStartDate': disasterStartDateController.text,
                'disasterEndDate': disasterEndDateController.text,
                'disasterDescription': disasterDescriptionController.text,
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Highlight the submit button
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );

  return completer.future;
}
