import 'package:drs/screens/incident_reports_page/incident_reports_screen.dart';
import 'package:drs/services/api/incident_report_api.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class UpdateIncidentReportsDialog extends StatefulWidget {
  final Function fetchIncidentReports;
  final Map<String, dynamic> report;
  final dynamic response;

  const UpdateIncidentReportsDialog({
    super.key,
    required this.fetchIncidentReports,
    required this.report,
    required this.response,
  });

  @override
  _UpdateIncidentReportsDialogState createState() =>
      _UpdateIncidentReportsDialogState();
}

class _UpdateIncidentReportsDialogState
    extends State<UpdateIncidentReportsDialog> {
  late TextEditingController reportNameController; 
  late TextEditingController reportDateController;
  late TextEditingController descriptionController;
  late TextEditingController reportedByController;
  late TextEditingController eventIdController;
  bool readOnly = true;
  final Completer<Map<String, String>?> completer = Completer();

  @override
  void initState() {
    super.initState();
    reportNameController =
        TextEditingController(text: widget.report['report_name']); 
    reportDateController =
        TextEditingController(text: widget.report['report_date']);
    descriptionController =
        TextEditingController(text: widget.report['description']);
    reportedByController =
        TextEditingController(text: widget.report['reported_by']);
    eventIdController =
        TextEditingController(text: widget.report['event_id']);
  }

  @override
  void dispose() {
    reportNameController.dispose();
    reportDateController.dispose();
    descriptionController.dispose();
    reportedByController.dispose();
    eventIdController.dispose();
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
        'Update Incident Report',
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
                controller: reportNameController, 
                label: 'Report Name',
                readOnly: readOnly,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: eventIdController,
                label: 'Event ID',
                readOnly: readOnly,
              ),
              const SizedBox(height: 15),
              _buildDateField(
                controller: reportDateController,
                label: 'Report Date',
                context: context,
                readOnly: readOnly,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: descriptionController,
                label: 'Description',
                readOnly: readOnly,
                maxLines: 3,
              ),
              const SizedBox(height: 15),
              _buildTextField(
                controller: reportedByController,
                label: 'Reported By',
                readOnly: readOnly,
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
                      if (reportNameController.text.isNotEmpty &&
                          eventIdController.text.isNotEmpty &&
                          reportDateController.text.isNotEmpty &&
                          descriptionController.text.isNotEmpty &&
                          reportedByController.text.isNotEmpty) {
                        final response = await updateIncidentReport(
                          widget.report['report_id'],
                          reportNameController.text, 
                          eventIdController.text,
                          reportDateController.text,
                          descriptionController.text,
                          reportedByController.text,
                        );
                        if (response != 0) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => IncidentReportsScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to update incident report'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                        completer.complete({
                          'reportId': widget.report['report_id'],
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
