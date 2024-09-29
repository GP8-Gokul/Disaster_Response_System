import 'package:drs/services/api/incident_report_api.dart'; 
import 'package:flutter/material.dart';
import 'dart:async';

Future<Map<String, String>?> insertIncidentReportDialog(
    BuildContext context, Function fetchIncidentReports, response) async {
  Completer<Map<String, String>?> completer = Completer();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController reportNameController = TextEditingController();  
      TextEditingController reportDateController = TextEditingController();
      TextEditingController descriptionController = TextEditingController();
      TextEditingController reportedByController = TextEditingController();
      TextEditingController eventIdController = TextEditingController();

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text(
          'Add Incident Report',
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
                controller: reportNameController,  
                decoration: InputDecoration(
                  labelText: 'Report Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: eventIdController,
                decoration: InputDecoration(
                  labelText: 'Event ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: reportDateController,
                decoration: InputDecoration(
                  labelText: 'Report Date',
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
                    reportDateController.text =
                        pickedDate.toIso8601String().substring(0, 10);
                  }
                },
              ),
              const SizedBox(height: 15),
              TextField(
                controller: descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: reportedByController,
                decoration: InputDecoration(
                  labelText: 'Reported By',
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
              if (reportNameController.text.isNotEmpty &&
                  eventIdController.text.isNotEmpty &&
                  reportDateController.text.isNotEmpty &&
                  descriptionController.text.isNotEmpty &&
                  reportedByController.text.isNotEmpty) {
                final response = await addIncidentReport(
                  reportNameController.text,  
                  eventIdController.text,
                  reportDateController.text,
                  descriptionController.text,
                  reportedByController.text,
                );
                if (response != 0) {
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to add incident report'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.of(context).pop();
                }
                completer.complete({
                  'reportName': reportNameController.text,  
                  'eventId': eventIdController.text,
                  'reportDate': reportDateController.text,
                  'description': descriptionController.text,
                  'reportedBy': reportedByController.text,
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
