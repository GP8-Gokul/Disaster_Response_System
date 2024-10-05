import 'package:drs/services/AuthoriztionDemo/check_access.dart';
import 'package:drs/services/api/disaster_event_api.dart';
import 'package:drs/services/api/root_api.dart';
import 'package:drs/widgets/custom_text.dart';
import 'package:drs/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

dynamic response;

var events = {};

void getEventIds() {
  late Future<List<Map<String, dynamic>>> futureGetDisasterEvents;
  futureGetDisasterEvents = fetchDisasterEvents();
  futureGetDisasterEvents.then((value) {
    for (var event in value) {
      events[event['event_id']] = event['event_name'];
    }
  });
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
                      text: widget.content['incident_report_date'].toString());
              TextEditingController incidentReportedByController =
                  TextEditingController(
                      text: widget.content['incident_reported_By'].toString());
              TextEditingController incidentReportDescriptionController =
                  TextEditingController(
                      text: widget.content['incident_report_description']
                          .toString());

              getEventIds();
              String? selectedEventId;

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text('Report Details',
                        style: TextStyle(
                            color: Colors.white,
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
                          Row(
                            children: [
                              CustomText(
                                  text:
                                      'Report ID: ${widget.content['report_id']}'),
                              Spacer(),
                              Container(
                                height: 40,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: FloatingActionButton(
                                  backgroundColor:
                                      const Color.fromARGB(255, 1, 255, 9),
                                  mini: true,
                                  child: const Icon(Icons.call),
                                  onPressed: () async {
                                    final Uri launchUri = Uri(
                                      scheme: 'tel',
                                      path: widget
                                          .content['incident_report_date'],
                                    );
                                    if (await canLaunchUrl(launchUri)) {
                                      await launchUrl(launchUri);
                                    } else {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Could not launch phone dialer')),
                                        );
                                      }
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                              hintText: '${widget.content['report_name']}',
                              labelText: 'Report Name',
                              controller: incidentReportNameController,
                              readOnly: readonly),
                          CustomTextField(
                            hintText:
                                '${widget.content['incident_report_date']}',
                            labelText: 'Report Date',
                            controller: incidentReportDateController,
                            readOnly: readonly,
                          ),
                          CustomTextField(
                            hintText:
                                '${widget.content['incident_reported_By']}',
                            labelText: 'Reported By',
                            controller: incidentReportedByController,
                            readOnly: readonly,
                          ),
                          CustomTextField(
                            hintText:
                                '${widget.content['incident_report_description']}',
                            labelText: 'Description',
                            controller: incidentReportDescriptionController,
                            readOnly: readonly,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.lime.withOpacity(0.5),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: 'Report Name',
                                enabled: !readonly,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: const BorderSide(
                                      color: Colors.lime, width: 2.0),
                                ),
                              ),
                              value: selectedEventId ??
                                  widget.content['event_id'].toString(),
                              style: const TextStyle(color: Colors.white),
                              dropdownColor: Colors.black,
                              items: events.keys.map((key) {
                                return DropdownMenuItem<String>(
                                  value: key.toString(),
                                  child: Container(
                                    color: Colors.black.withOpacity(0.5),
                                    child: Text(events[key]!),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                selectedEventId = newValue;
                              },
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
                                'incident_report_date':
                                    incidentReportDateController.text,
                                'incident_reported_By':
                                    incidentReportedByController.text,
                                'incident_report_description':
                                    incidentReportDescriptionController.text,
                                'event_id': selectedEventId!,
                              },
                            );
                            if (response != null && context.mounted) {
                              widget.onChange();
                              Navigator.pop(context);
                            }
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Access Denied',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                  backgroundColor:
                                      const Color.fromARGB(255, 0, 0, 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                        width: 3.0),
                                  ),
                                  content: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomText(
                                          text:
                                              'You do not have access to update this data'),
                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.white,
                                      ),
                                      child: const Text('OK',
                                          style:
                                              TextStyle(color: Colors.black)),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
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
