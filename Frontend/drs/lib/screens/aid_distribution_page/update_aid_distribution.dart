import 'package:drs/services/api/disaster_event_api.dart';
import 'package:flutter/material.dart';
import 'dart:async';

Future<Map<String, String>?> updateAidDistributionDialog(BuildContext context,
    Function fetchAidDistribution, Map<String, dynamic> rsc, response) async {
  Completer<Map<String, String>?> completer = Completer();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController aidEventIdController =
          TextEditingController(text: rsc['event_id']);
      TextEditingController aidResourceIdController =
          TextEditingController(text: rsc['resource_id']);
      TextEditingController aidVolunteerIdController =
          TextEditingController(text: rsc['volunteer_id']);
      TextEditingController aidQuantityController =
          TextEditingController(text: rsc['quantity_distributed']);
      TextEditingController aidDistributionDateController =
          TextEditingController(text: rsc['distribution_date']);
      TextEditingController aidLocationController =
          TextEditingController(text: rsc['location']);

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text(
          'Update Aids',
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
                controller: 
aidDistributionDateController,
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
              await updateAids(
                rsc['distribution_id'],
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
                'distributionId': rsc['distribution_id'],
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