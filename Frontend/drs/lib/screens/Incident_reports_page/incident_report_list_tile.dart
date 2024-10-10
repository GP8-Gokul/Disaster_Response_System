import 'package:drs/services/api/root_api.dart';
import 'package:drs/services/authorization/check_access.dart';
import 'package:drs/widgets/custom_snack_bar.dart';
import 'package:drs/widgets/custom_text.dart';
import 'package:drs/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools;

dynamic response;

var events = {};
Future<void> getEventIds(String volunteerName, String eventController) async {
  events.clear();
  List<Map<String, dynamic>> value = await fetchdata('disaster_events');
  for (var event in value) {
    events[event['event_id']] = event['event_name'];
  }
  devtools.log(events.toString());
  devtools.log(eventController);
  devtools.log(volunteerName);
  if (!(checkAcess('volunteers', volunteerName))) {
    events.removeWhere(
        (key, value) => key.toString() != eventController.toString());
  }
  devtools.log(events.toString());
}

class IncidentReportListTile extends StatefulWidget {
  final dynamic content;
  final VoidCallback onChange;
  const IncidentReportListTile({
    super.key,
    required this.content,
    required this.onChange,
  });

  @override
  IncidentReportListTileState createState() => IncidentReportListTileState();
}

class IncidentReportListTileState extends State<IncidentReportListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color.fromARGB(255, 153, 153, 43), width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: ListTile(
        title: Text("Name: ${widget.content['report_name']}"),
        subtitle: Text("ID: ${widget.content['report_id']}"),
        tileColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.05),
        contentPadding:
            const EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
        textColor: const Color.fromARGB(255, 255, 255, 255),
        titleTextStyle:
            const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        subtitleTextStyle:
            const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        onTap: () {
          bool readonly = true;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController incidentReportNameController =
                  TextEditingController(
                      text: widget.content['report_name'].toString());
              TextEditingController incidentReportDateController =
                  TextEditingController(
                      text: widget.content['report_date'].toString());
              TextEditingController incidentReportedByController =
                  TextEditingController(
                      text: widget.content['reported_by'].toString());
              TextEditingController incidentReportDescriptionController =
                  TextEditingController(
                      text: widget.content['description'].toString());
              TextEditingController eventController = TextEditingController(
                  text: widget.content['event_id'].toString());

              getEventIds(
                  incidentReportNameController.text, eventController.text);
              String? selectedEventId = eventController.text;

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text('Report Details',
                        style: TextStyle(
                            color: Colors.lime,
                            fontSize: 24,
                            fontWeight: FontWeight.bold)),
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 255, 255, 255),
                          width: 3.0),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Visibility(
                            visible: readonly,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Divider(color: Colors.white),
                              Center(child: Text(widget.content['report_name'].toString().toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 24, 
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                  ),
                              )),
                              Divider(color: Colors.white),
                              CustomText(text: 'Date: ${widget.content['report_date']}'),
                              const SizedBox(height: 6),
                              CustomText(text: 'Reported By: ${widget.content['reported_by']}'),
                              const SizedBox(height: 6),
                              Divider(color: Colors.grey,),
                              CustomText(text: '${widget.content['description']}'),
                              Divider(color: Colors.grey,),
                              const SizedBox(height: 15),
                              ],
                            ),
                            ),
                            Visibility(
                            visible: !readonly,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              CustomText(text:'Report ID: ${widget.content['report_id']}'),
                              const SizedBox(height: 12),
                              CustomTextField(
                                hintText: '${widget.content['report_name']}',
                                labelText: 'Report Name',
                                controller: incidentReportNameController,
                                readOnly: readonly),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: TextField(
                                  controller: incidentReportDateController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                  hintText: 'Start Date',
                                  labelText: 'Start Date',
                                  labelStyle: TextStyle(color: Colors.white),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide:
                                      const BorderSide(color: Colors.lime),
                                  ),
                                  ),
                                  readOnly: readonly,
                                  onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime(2100),
                                  );
                                  if (pickedDate != null) {
                                    incidentReportDateController.text = pickedDate
                                      .toIso8601String()
                                      .substring(0, 10);
                                  }
                                  },
                                ),
                              ),
                              CustomTextField(
                                hintText: '${widget.content['reported_by']}',
                                labelText: 'Reported By',
                                controller: incidentReportedByController,
                                readOnly: readonly,
                              ),
                              CustomTextField(
                                hintText: '${widget.content['description']}',
                                labelText: 'Description',
                                controller: incidentReportDescriptionController,
                                readOnly: readonly,
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: FutureBuilder<void>(
                                    future: getEventIds(
                                        incidentReportNameController.text,
                                        eventController.text),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<void> snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const CircularProgressIndicator();
                                      } else if (snapshot.hasError) {
                                        return const Text('Error loading events');
                                      } else {
                                        return DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            labelText: 'Event Name',
                                            labelStyle:
                                                const TextStyle(color: Colors.white),
                                            enabledBorder: const OutlineInputBorder(
                                              borderSide:
                                                  BorderSide(color: Colors.lime),
                                            ),
                                            focusedBorder: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 200, 99, 92)),
                                            ),
                                          ),
                                          value: selectedEventId,
                                          style: const TextStyle(color: Colors.white),
                                          dropdownColor:
                                              const Color.fromARGB(255, 38, 36, 36),
                                          items: events.keys.map((key) {
                                            return DropdownMenuItem<String>(
                                              value: key.toString(),
                                              child: Text(events[key]!),
                                            );
                                          }).toList(),
                                          onChanged: (String? newValue) {
                                            setState(() {
                                              selectedEventId = newValue;
                                            });
                                          },
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                            ),
                          
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          setState(() {
                            readonly = !readonly;
                          });
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Icon(Icons.update, color: Colors.blue),
                        onPressed: () async {
                          if (selectedEventId == null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text('Please select an event ID'),
                              backgroundColor: Colors.red,
                            ));
                            return;
                          }
                          if (checkAcess('incident_reports',
                              incidentReportNameController.text)) {
                            response = await updateData(
                              {
                                'table': 'incident_reports',
                                'report_id': widget.content['report_id'],
                                'report_name':
                                    incidentReportNameController.text,
                                'report_date':
                                    incidentReportDateController.text,
                                'reported_by':
                                    incidentReportedByController.text,
                                'report_description':
                                    incidentReportDescriptionController.text,
                                'event_id': selectedEventId,
                              },
                            );
                            if (response != null && context.mounted) {
                              widget.onChange();
                              Navigator.pop(context);
                            }
                          } else {
                            Navigator.pop(context);
                            customSnackBar(
                                context: context,
                                message:
                                    'You do not have access to update this incident report');
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
