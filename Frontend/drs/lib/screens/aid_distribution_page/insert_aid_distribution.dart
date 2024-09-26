import 'package:drs/services/api/disaster_event_api.dart';
import 'package:flutter/material.dart';
import 'dart:async';

Future<Map<String, String>?> insertAidDistributionDialog(
    BuildContext context, Function fetchAidDistribution, response) async {
  Completer<Map<String, String>?> completer = Completer();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController aidEventIdController = TextEditingController();
      TextEditingController aidResourceIdController = TextEditingController();
      TextEditingController aidVolunteerIdController =
          TextEditingController();
      TextEditingController aidQuantityController =
          TextEditingController();
      TextEditingController aidDistributionDateController = TextEditingController();
      TextEditingController aidLocationController =
          TextEditingController();

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text(
          'Add Aids',
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
                controller: aidEventIdController,
                decoration: InputDecoration(
                  labelText: 'Event ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: aidResourceIdController,
                decoration: InputDecoration(
                  labelText: 'Resource ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: aidVolunteerIdController,
                decoration: InputDecoration(
                  labelText: 'Volunteer ID',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller:
aidQuantityController,
                decoration: InputDecoration(
                  labelText: 'Quantity Distributed',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: aidDistributionDateController,
                decoration: InputDecoration(
                  labelText: 'Distribution Date',
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
                    aidDistributionDateController.text =
                        pickedDate.toIso8601String().substring(0, 10);
                  }
                },
              ),
              const SizedBox(height: 15),
              TextField(
                controller: aidLocationController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Location',
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
              await addAids(
                aidEventIdController.text,
                aidResourceIdController.text,
                aidVolunteerIdController.text,
                aidQuantityController.text,
                aidDistributionDateController.text,
                aidLocationController.text,
              );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
              completer.complete({
                'aidEventId': aidEventIdController.text,
                'aidResourceId': aidResourceIdController.text,
                'aidVolunteerId': aidVolunteerIdController.text,
                'aidQuantity': aidQuantityController.text,
                'aidDistributionDate': aidDistributionDateController.text,
                'aidLocation': aidLocationController.text,
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