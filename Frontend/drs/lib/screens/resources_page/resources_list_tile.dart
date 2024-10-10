import 'package:drs/services/authorization/check_access.dart';
import 'package:drs/services/api/root_api.dart';
import 'package:drs/widgets/custom_snack_bar.dart';
import 'package:drs/widgets/custom_text.dart';
import 'package:drs/widgets/custom_text_field.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';

dynamic response;
var events = {};
Future<void> getEventIds(String resourceType, String eventController) async {
  events.clear();
  List<Map<String, dynamic>> value = await fetchdata('disaster_events');
  for (var event in value) {
    events[event['event_id']] = event['event_name'];
  }
  devtools.log(events.toString());
  devtools.log(eventController);
  devtools.log(resourceType);
  if (checkAcess('resources', userName) == true) {
    events.removeWhere(
        (key, value) => key.toString() != eventController.toString());
  }
  devtools.log(events.toString());
}

class ResourceListTile extends StatefulWidget {
  final dynamic content;
  final VoidCallback onChange;
  const ResourceListTile({
    super.key,
    required this.content,
    required this.onChange,
  });

  @override
  ResourceListTileState createState() => ResourceListTileState();
}

class ResourceListTileState extends State<ResourceListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color.fromARGB(255, 153, 153, 43), width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),

      //Main details of Resource

      child: ListTile(
        title: Text("Name: ${widget.content['resource_name']}"),
        subtitle: Text("ID: ${widget.content['resource_id']}"),
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
          //Additional Details of Resource

          bool readonly = true;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController resourcenamecontroller =
                  TextEditingController(
                      text: widget.content['resource_name'].toString());
              TextEditingController resourcetypecontroller =
                  TextEditingController(
                      text: widget.content['resource_type'].toString());
              TextEditingController quantitycontroller = TextEditingController(
                  text: widget.content['quantity'].toString());
              TextEditingController availabilityStatusController =
                  TextEditingController(
                      text: widget.content['availability_status'].toString());
              TextEditingController eventController = TextEditingController(
                  text: widget.content['event_id'].toString());

              getEventIds(resourcenamecontroller.text, eventController.text);
              String? selectedEventId = eventController.text;

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text('Resorce Details',
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
                                      'Resource ID: ${widget.content['resource_id']}'),
                              Spacer(),
                              Container(
                                height: 40,
                                width: 80,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          CustomTextField(
                              hintText: '${widget.content['resource_name']}',
                              labelText: 'resource Name',
                              controller: resourcenamecontroller,
                              readOnly: readonly),
                          CustomTextField(
                            hintText: '${widget.content['resource_type']}',
                            labelText: 'Resource type',
                            controller: resourcetypecontroller,
                            readOnly: readonly,
                          ),
                          CustomTextField(
                            hintText: '${widget.content['quantity']}',
                            labelText: 'Quantity',
                            controller: quantitycontroller,
                            readOnly: readonly,
                          ),
                          CustomTextField(
                            hintText:
                                '${widget.content['availability_status']}',
                            labelText: 'Availability Status',
                            controller: availabilityStatusController,
                            readOnly: readonly,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: FutureBuilder<void>(
                              future: getEventIds(resourcetypecontroller.text,
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
                    actions: <Widget>[
                      //Edit Functionality

                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                        ),
                        child: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          if (checkAcess('resources', userName) == true) {
                            setState(() {
                              readonly = !readonly;
                            });
                          } else {
                            Navigator.pop(context);
                            customSnackBar(
                                context: context,
                                message: 'You cannot Edit this data');
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
                            customSnackBar(
                                context: context,
                                message: 'Please select an event ID');
                          }
                          if (checkAcess('resources', userName) == true) {
                            devtools.log(resourcenamecontroller.text);
                            response = await updateData(
                              {
                                'table': 'resources',
                                'resource_name': resourcenamecontroller.text,
                                'resource_type': resourcetypecontroller.text,
                                'quantity': quantitycontroller.text,
                                'availability_status':
                                    availabilityStatusController.text,
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
                                message: 'You cannot Update this data');
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
