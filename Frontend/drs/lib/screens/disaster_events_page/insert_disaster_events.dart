import 'package:drs/services/api/disaster_event_api.dart';
import 'package:flutter/material.dart';
import 'dart:async';

Future<Map<String, String>?> insertDisasterEventsDialog(
    BuildContext context, Function fetchDisasterEvents, response) async {
  Completer<Map<String, String>?> completer = Completer();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController disasterNameController = TextEditingController();
      TextEditingController disasterTypeController = TextEditingController();
      TextEditingController disasterLocationController =
          TextEditingController();
      TextEditingController disasterStartDateController =
          TextEditingController();
      TextEditingController disasterEndDateController = TextEditingController();
      TextEditingController disasterDescriptionController =
          TextEditingController();

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text(
          'Add Disaster Event',
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
              if (disasterNameController.text.isNotEmpty &&
                  disasterTypeController.text.isNotEmpty &&
                  disasterLocationController.text.isNotEmpty &&
                  disasterStartDateController.text.isNotEmpty &&
                  disasterEndDateController.text.isNotEmpty &&
                  disasterDescriptionController.text.isNotEmpty) {
                final response = await addDisasterEvents(
                  disasterNameController.text,
                  disasterTypeController.text,
                  disasterLocationController.text,
                  disasterStartDateController.text,
                  disasterEndDateController.text,
                  disasterDescriptionController.text,
                );
                if (response != 0) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to add disaster event'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
                completer.complete({
                  'disasterName': disasterNameController.text,
                  'disasterType': disasterTypeController.text,
                  'disasterLocation': disasterLocationController.text,
                  'disasterStartDate': disasterStartDateController.text,
                  'disasterEndDate': disasterEndDateController.text,
                  'disasterDescription': disasterDescriptionController.text,
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Please fill all the fields'),
                    backgroundColor: Colors.red,
                  ),
                );
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 3, 39, 68),
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
