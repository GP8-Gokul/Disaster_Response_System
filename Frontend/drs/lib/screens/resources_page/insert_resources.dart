  import 'package:drs/services/api/root_api.dart';
import 'package:drs/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'dart:async';

Future<Map<String, String>?> insertResourcesDialog(
    BuildContext context, Function fetchResources, response) async {
  Completer<Map<String, String>?> completer = Completer();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      TextEditingController ResourceName_Controller = TextEditingController();
      TextEditingController resource_type_Controller = TextEditingController();
      TextEditingController quantity_Controller =
          TextEditingController();
      TextEditingController availability_status_Controller =
          TextEditingController();
      TextEditingController event_id_Controller = TextEditingController();
      

      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        title: const Text(
          'Add Resources',
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
                controller: ResourceName_Controller,
                decoration: InputDecoration(
                  labelText: 'Resource Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: resource_type_Controller,
                decoration: InputDecoration(
                  labelText: 'Resource Type',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: quantity_Controller,
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: availability_status_Controller,
                decoration: InputDecoration(
                  labelText: 'availability_status',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: event_id_Controller,
                decoration: InputDecoration(
                  labelText: 'event id',
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
              if (ResourceName_Controller.text.isNotEmpty &&
                  resource_type_Controller.text.isNotEmpty &&
                  quantity_Controller.text.isNotEmpty &&
                  availability_status_Controller.text.isNotEmpty &&
                  event_id_Controller.text.isNotEmpty ) 
                  {
                final response = await insertData({
                  'table': 'resources',
                  'resource_Name': ResourceName_Controller.text,
                  'resource_type':resource_type_Controller.text,
                  'quantity': quantity_Controller.text,
                  'availability_status': availability_status_Controller.text,
                  'event_id': event_id_Controller.text,
                  
                });
                if (response != 0) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                } else {
                  // ignore: use_build_context_synchronously
                  customSnackBar(context: context, message: 'Failed to add resources');
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
                completer.complete({
                  'resource_Name': ResourceName_Controller.text,
                  'resource_type':resource_type_Controller.text,
                  'quantity': quantity_Controller.text,
                  'availability_status': availability_status_Controller.text,
                  'event_id': event_id_Controller.text,
                });
              } else {
                customSnackBar(context: context, message: 'Please fill all the fields');
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

