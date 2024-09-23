import 'package:drs/services/api/volunteer_api.dart';
import 'package:flutter/material.dart';
import 'dart:async';

Future<Map<String, String>?> showVolunteerDialog(
    BuildContext context, Function fetchVolunteers, response) async {
  Completer<Map<String, String>?> completer = Completer();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController volunteerNameController = TextEditingController();
      TextEditingController volunteerContactInfoController =
          TextEditingController();
      TextEditingController volunteerSkillsController = TextEditingController();
      TextEditingController volunteerAvailabilityStatusController =
          TextEditingController();
      TextEditingController eventIdController = TextEditingController();

      return AlertDialog(
        title: const Text('Add Volunteer'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: volunteerNameController,
              decoration: const InputDecoration(
                labelText: 'Volunteer Name',
              ),
            ),
            TextField(
              controller: volunteerContactInfoController,
              decoration: const InputDecoration(
                labelText: 'Contact Info',
              ),
            ),
            TextField(
              controller: volunteerSkillsController,
              decoration: const InputDecoration(
                labelText: 'Skills',
              ),
            ),
            TextField(
              controller: volunteerAvailabilityStatusController,
              decoration: const InputDecoration(
                labelText: 'Availability Status',
              ),
            ),
            TextField(
              controller: eventIdController,
              decoration: const InputDecoration(
                labelText: 'Event ID',
              ),
            ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              completer.complete(null);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await addVolunteer(
                volunteerNameController.text,
                volunteerContactInfoController.text,
                volunteerSkillsController.text,
                volunteerAvailabilityStatusController.text,
                eventIdController.text,
              );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
              completer.complete({
                'volunteerName': volunteerNameController.text,
                'contactInfo': volunteerContactInfoController.text,
                'skills': volunteerSkillsController.text,
                'availabilityStatus':
                    volunteerAvailabilityStatusController.text,
                'eventId': eventIdController.text,
              });
            },
            child: const Text('Submit'),
          ),
        ],
      );
    },
  );

  return completer.future;
}
