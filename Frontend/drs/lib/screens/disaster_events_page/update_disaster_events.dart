import 'package:drs/services/api/disaster_event_api.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class UpdateDisasterEventsDialog extends StatefulWidget {
  final Function fetchDisasterEvents;
  final Map<String, dynamic> event;
  final dynamic response;

  const UpdateDisasterEventsDialog({
    super.key,
    required this.fetchDisasterEvents,
    required this.event,
    required this.response,
  });

  @override
  _UpdateDisasterEventsDialogState createState() =>
      _UpdateDisasterEventsDialogState();
}

class _UpdateDisasterEventsDialogState
    extends State<UpdateDisasterEventsDialog> {
  late TextEditingController disasterNameController;
  late TextEditingController disasterTypeController;
  late TextEditingController disasterLocationController;
  late TextEditingController disasterStartDateController;
  late TextEditingController disasterEndDateController;
  late TextEditingController disasterDescriptionController;
  bool readOnly = true;
  final Completer<Map<String, String>?> completer = Completer();

  @override
  void initState() {
    super.initState();
    disasterNameController =
        TextEditingController(text: widget.event['event_name']);
    disasterTypeController =
        TextEditingController(text: widget.event['event_type']);
    disasterLocationController =
        TextEditingController(text: widget.event['location']);
    disasterStartDateController =
        TextEditingController(text: widget.event['start_date']);
    disasterEndDateController =
        TextEditingController(text: widget.event['end_date']);
    disasterDescriptionController =
        TextEditingController(text: widget.event['description']);
  }

  @override
  void dispose() {
    disasterNameController.dispose();
    disasterTypeController.dispose();
    disasterLocationController.dispose();
    disasterStartDateController.dispose();
    disasterEndDateController.dispose();
    disasterDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      title: Text(
        'Update Disaster Event',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22.0,
          color: const Color.fromARGB(255, 17, 17, 17),
        ),
      ),
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                controller: disasterNameController,
                label: 'Disaster Name',
                readOnly: readOnly,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: disasterTypeController,
                label: 'Disaster Type',
                readOnly: readOnly,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: disasterLocationController,
                label: 'Location',
                readOnly: readOnly,
              ),
              const SizedBox(height: 15),
              _buildDateField(
                controller: disasterStartDateController,
                label: 'Start Date',
                context: context,
                readOnly: readOnly,
              ),
              const SizedBox(height: 15),
              _buildDateField(
                controller: disasterEndDateController,
                label: 'End Date',
                context: context,
                readOnly: readOnly,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: disasterDescriptionController,
                label: 'Description',
                readOnly: readOnly,
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    icon: Icons.edit,
                    color: Colors.blueGrey[700],
                    onPressed: () {
                      setState(() {
                        readOnly = !readOnly;
                      });
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.update,
                    color: Colors.blueAccent,
                    onPressed: () async {
                      if (disasterNameController.text.isNotEmpty &&
                          disasterTypeController.text.isNotEmpty &&
                          disasterLocationController.text.isNotEmpty &&
                          disasterStartDateController.text.isNotEmpty &&
                          disasterEndDateController.text.isNotEmpty &&
                          disasterDescriptionController.text.isNotEmpty) {
                        final response = await updateDisasterEvents(
                          widget.event['event_id'],
                          disasterNameController.text,
                          disasterTypeController.text,
                          disasterLocationController.text,
                          disasterStartDateController.text,
                          disasterEndDateController.text,
                          disasterDescriptionController.text,
                        );
                        if (response != 0) {
                          widget.fetchDisasterEvents();
                          Navigator.of(context).pop();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to update event'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                        completer.complete({
                          'eventId': widget.event['event_id'],
                          'disasterName': disasterNameController.text,
                          'disasterType': disasterTypeController.text,
                          'disasterLocation': disasterLocationController.text,
                          'disasterStartDate': disasterStartDateController.text,
                          'disasterEndDate': disasterEndDateController.text,
                          'disasterDescription':
                              disasterDescriptionController.text,
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Please fill all the fields'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool readOnly = true,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        fillColor: Colors.grey[100],
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[500]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required TextEditingController controller,
    required String label,
    required BuildContext context,
    bool readOnly = true,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600]),
        fillColor: Colors.grey[100],
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        suffixIcon: Icon(
          Icons.calendar_today,
          color: Colors.grey[500],
        ),
      ),
      onTap: () async {
        if (!readOnly) {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            controller.text = pickedDate.toIso8601String().substring(0, 10);
          }
        }
      },
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color? color,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[50],
        padding: EdgeInsets.all(10),
        shape: CircleBorder(),
        elevation: 3,
      ),
      onPressed: onPressed,
      child: Icon(icon, color: color, size: 28),
    );
  }
}
