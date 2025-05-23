import 'package:drs/services/authorization/check_access.dart';
import 'package:drs/services/api/root_api.dart';
import 'package:drs/widgets/custom_snack_bar.dart';
import 'package:drs/widgets/custom_text.dart';
import 'package:drs/widgets/custom_text_field.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

dynamic response;
var events = {};
Future<void> getEventIdsForEdit(String volunteerName, String eventController) async {
  events.clear();
  List<Map<String, dynamic>> value = await fetchdata('disaster_events');
  for (var event in value) {
    events[event['event_id']] = event['event_name'];
  }
  devtools.log(events.toString());
  devtools.log(eventController);
  devtools.log(volunteerName);
  if (!(checkAcess('volunteers', volunteerName))) {
    events.removeWhere((key, value) => key.toString() != eventController.toString());
  }
  devtools.log(events.toString());
}

Future<void> getEventIdsNoEdit(String volunteerName, String eventController) async {
  events.clear();
  List<Map<String, dynamic>> value = await fetchdata('disaster_events');
  for (var event in value) {
    events[event['event_id']] = event['event_name'];
  }
  devtools.log(events.toString());
  devtools.log(eventController);
  devtools.log(volunteerName);
  events.removeWhere((key, value) => key.toString() != eventController.toString());
}

void sendMessageToWhatsApp(String phoneNumber, String message, BuildContext context) async {
  final Uri whatsappUri = Uri.parse("https://wa.me/+91$phoneNumber?text=${Uri.encodeComponent(message)}");
  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri);
  } else {
    if (context.mounted) {
      devtools.log('Could not launch WhatsApp with URL: $whatsappUri');
      Navigator.pop(context);
      customSnackBar(context: context, message: 'Could not launch WhatsApp');
    }
  }
}

class VolunteerListTile extends StatefulWidget {
  final dynamic content;
  final VoidCallback onChange;
  const VolunteerListTile({
    super.key,
    required this.content,
    required this.onChange,
  });

  @override
  VolunteerListTileState createState() => VolunteerListTileState();
}

class VolunteerListTileState extends State<VolunteerListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 153, 153, 43), width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),

      //Main details of volunteer

      child: ListTile(
        title: Text("Name: ${widget.content['volunteer_name']}"),
        subtitle: Text("ID: ${widget.content['volunteer_id']}"),
        tileColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
        textColor: const Color.fromARGB(255, 255, 255, 255),
        titleTextStyle: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        subtitleTextStyle: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
        onTap: () {

          //Additional Details of volunteer

          bool readonly = true;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController volunteerNameController = TextEditingController(
                      text: widget.content['volunteer_name'].toString());
              TextEditingController volunteerContactInfoController = TextEditingController(
                      text: widget.content['volunteer_contact_info'].toString());
              TextEditingController volunteerSkillsController =
                  TextEditingController(
                      text: widget.content['volunteer_skills'].toString());
              TextEditingController volunteerAvailabilityStatusController = TextEditingController(
                      text: widget.content['volunteer_availability_status'].toString());
              TextEditingController eventController = TextEditingController(
                  text: widget.content['event_id'].toString());

              getEventIdsForEdit(volunteerNameController.text, eventController.text);
              String? selectedEventId = eventController.text;

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text('Volunteer Details',
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
                                  text: 'Volunteer ID: ${widget.content['volunteer_id']}'),
                              Spacer(),
                              Container(
                                height: 40,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: FloatingActionButton(
                                  backgroundColor:const Color.fromARGB(255, 1, 255, 9),
                                  mini: true,
                                  child: const Icon(Icons.message),
                                  onPressed: () async {
                                    sendMessageToWhatsApp(
                                      widget.content['volunteer_contact_info'], 
                                      'Hi ${widget.content['volunteer_name']},You were sited as a volunteer in DRS App.',
                                      context,
                                      );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                              'Availability Status:',
                              style: TextStyle(color: Colors.white),
                              ),
                              Checkbox(
                              value: volunteerAvailabilityStatusController.text.toLowerCase() == 'yes',
                              onChanged: readonly
                              ? null
                              : (bool? newValue) {
                                setState(() {
                                volunteerAvailabilityStatusController.text = newValue! ? 'Yes' : 'No';
                                });
                                },
                              activeColor: Colors.green,
                              checkColor: Colors.white,
                              ),
                              Text(
                              volunteerAvailabilityStatusController.text,
                              style: TextStyle(
                              color: volunteerAvailabilityStatusController.text.toLowerCase() == 'yes'
                                ? Colors.green
                                : Colors.red,
                              ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                          hintText: '${widget.content['volunteer_name']}',
                          labelText: 'Volunteer Name',
                          controller: volunteerNameController,
                          readOnly: readonly,
                          ),
                          CustomTextField(
                            hintText: '${widget.content['volunteer_contact_info']}',
                            labelText: 'Contact Info',
                            controller: volunteerContactInfoController,
                            readOnly: readonly,
                          ),
                          CustomTextField(
                            hintText: '${widget.content['volunteer_skills']}',
                            labelText: 'Skills',
                            controller: volunteerSkillsController,
                            readOnly: readonly,
                          ),
                          Visibility(
                            visible: readonly,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FutureBuilder<void>(
                                future: getEventIdsNoEdit(volunteerNameController.text,eventController.text),
                                builder: (BuildContext context,AsyncSnapshot<void> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                                      dropdownColor:const Color.fromARGB(255, 38, 36, 36),
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
                          ),
                          Visibility(
                            visible: !readonly,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FutureBuilder<void>(
                                future: getEventIdsForEdit(volunteerNameController.text,eventController.text),
                                builder: (BuildContext context,AsyncSnapshot<void> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                                      dropdownColor:const Color.fromARGB(255, 38, 36, 36),
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
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[

                      //Edit Functionality

                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          if (checkAcess('volunteers', volunteerNameController.text)) {
                            setState(() {
                              readonly = !readonly;
                            });
                          } else {
                            Navigator.pop(context);
                            customSnackBar(context: context, message: 'You cannot Edit this data');
                          }
                        },
                      ),

                      //Update Functionality

                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Icon(Icons.update, color: Colors.blue),
                        onPressed: () async {
                          if (selectedEventId == null) {
                            customSnackBar(context: context, message: 'Please select an event ID');
                          }
                          if (checkAcess('volunteers', volunteerNameController.text)) {
                            response = await updateData(
                              {
                                'table': 'volunteers',
                                'volunteer_id': widget.content['volunteer_id'],
                                'volunteer_name': volunteerNameController.text,
                                'volunteer_contact_info': volunteerContactInfoController.text,
                                'volunteer_skills': volunteerSkillsController.text,
                                'volunteer_availability_status': volunteerAvailabilityStatusController.text,
                                'event_id': selectedEventId,
                              },
                            );
                            if (response != null && context.mounted) {
                              widget.onChange();
                              Navigator.pop(context);
                            }
                          } else {
                            Navigator.pop(context);
                            customSnackBar(context: context, message: 'You cannot Update this data');
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
