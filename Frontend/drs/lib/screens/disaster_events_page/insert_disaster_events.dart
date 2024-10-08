import 'package:drs/services/api/root_api.dart';
import 'package:drs/widgets/custom_snack_bar.dart';
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
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
          side: BorderSide(color: Colors.white, width: 2.0),
        ),
        title: const Text(
          'Add Disaster Event',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: disasterNameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Disaster Name',
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: disasterTypeController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Disaster Type',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: disasterLocationController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Location',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: disasterStartDateController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  labelStyle: TextStyle(color: Colors.white),
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
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'End Date',
                  labelStyle: TextStyle(color: Colors.white),
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
                style: TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white),
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
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              if (disasterNameController.text.isNotEmpty &&
                  disasterTypeController.text.isNotEmpty &&
                  disasterLocationController.text.isNotEmpty &&
                  disasterStartDateController.text.isNotEmpty &&
                  disasterEndDateController.text.isNotEmpty &&
                  disasterDescriptionController.text.isNotEmpty) {
                final response = await insertData({
                  'table': 'disaster_events',
                  'event_name': disasterNameController.text,
                  'event_type': disasterTypeController.text,
                  'location': disasterLocationController.text,
                  'start_date': disasterStartDateController.text,
                  'end_date': disasterEndDateController.text,
                  'description': disasterDescriptionController.text,
                });
                if (response != 0) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  // ignore: use_build_context_synchronously
                  customSnackBar(
                      // ignore: use_build_context_synchronously
                      context: context,
                      message: 'Failed to add disaster event');
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
                customSnackBar(
                    context: context, message: 'Please fill all the fields');
                Navigator.of(context).pop();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(201, 3, 39, 68),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );

  return completer.future;
}
