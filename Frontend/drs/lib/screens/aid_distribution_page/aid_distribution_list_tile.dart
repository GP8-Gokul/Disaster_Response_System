import 'package:drs/services/authorization/check_access.dart';
import 'package:drs/services/api/root_api.dart';
import 'package:drs/widgets/custom_snack_bar.dart';
import 'package:drs/widgets/custom_text.dart';
import 'package:drs/widgets/custom_text_field.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter/material.dart';

dynamic response;
var events = {};
var resources = {};
var volunteers = {};
Future<void> getEventIdsForEdit(String location, String eventController) async {
  events.clear();
  List<Map<String, dynamic>> value = await fetchdata('disaster_events');
  for (var event in value) {
    events[event['event_id']] = event['event_name'];
  }
  devtools.log(events.toString());
  devtools.log(eventController);
  devtools.log(location);
  if (!(checkAcess('aid_distribution', location))) {
    events.removeWhere(
        (key, value) => key.toString() != eventController.toString());
  }
  devtools.log(events.toString());
}

Future<void> getResourceIdsForEdit(String resourceController) async {
  resources.clear();
  List<Map<String, dynamic>> value = await fetchdata('resources');
  for (var resource in value) {
    resources[resource['resource_id']] = resource['resource_name'];
  }
  devtools.log(resources.toString());
  devtools.log(resourceController);
  if (!(checkAcess('aid_distribution', ''))) {
    events.removeWhere(
        (key, value) => key.toString() != resourceController.toString());
  }
  devtools.log(resources.toString());
}

Future<void> getEventIdsNoEdit(String location, String eventController) async {
  events.clear();
  List<Map<String, dynamic>> value = await fetchdata('disaster_events');
  for (var event in value) {
    events[event['event_id']] = event['event_name'];
  }
  devtools.log(events.toString());
  devtools.log(eventController);
  devtools.log(location);
  
  events.removeWhere((key, value) => key.toString() != eventController.toString());
  
  devtools.log(events.toString());
}

Future<void> getResourceIdsNoEdit(String location,String resourceController) async {
  resources.clear();
  List<Map<String, dynamic>> value = await fetchdata('resources');
  for (var resource in value) {
    resources[resource['resource_id']] = resource['resource_name'];
  }
  devtools.log(resources.toString());
  devtools.log(resourceController);
  events.removeWhere((key, value) => key.toString() == resourceController.toString());
  devtools.log(resources.toString());
}

Future<void> getVolunteerIdsForEdit(String volunteerController) async {
  volunteers.clear();
  List<Map<String, dynamic>> value = await fetchdata('volunteers');
  for (var volunteer in value) {
    volunteers[volunteer['volunteer_id']] = volunteer['volunteer_name'];
  }
  devtools.log(volunteers.toString());
  devtools.log(volunteerController);
  if (!(checkAcess('aid_distribution', ''))) {
    events.removeWhere(
        (key, value) => key.toString() != volunteerController.toString());
  }
  devtools.log(volunteers.toString());
}

Future<void> getVolunteerIdsNoEdit(String volunteerController) async {
  volunteers.clear();
  List<Map<String, dynamic>> value = await fetchdata('volunteers');
  for (var volunteer in value) {
    volunteers[volunteer['volunteer_id']] = volunteer['volunteer_name'];
  }
  devtools.log(volunteers.toString());
  devtools.log(volunteerController);

  events.removeWhere((key, value) => key.toString() != volunteerController.toString());
  devtools.log(volunteers.toString());
}

class AidDistributionListTile extends StatefulWidget {
  final dynamic content;
  final VoidCallback onChange;
  const AidDistributionListTile({
    super.key,
    required this.content,
    required this.onChange,
  });

  @override
  AidDistributionTileState createState() => AidDistributionTileState();
}

class AidDistributionTileState extends State<AidDistributionListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color.fromARGB(255, 153, 153, 43), width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),

      //Main details of aid distribution

      child: ListTile(
        title: Text("location: ${widget.content['location']}"),
        subtitle: Text("Quantity: ${widget.content['quantity_distributed']}"),
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
          //Additional Details of aid distribution

          bool readonly = true;
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController eventController = TextEditingController(
                  text: widget.content['event_id'].toString());
              TextEditingController resourceController = TextEditingController(
                  text: widget.content['resource_id'].toString());
              TextEditingController volunteerController = TextEditingController(
                  text: widget.content['volunteer_id'].toString());
              TextEditingController locationController = TextEditingController(
                  text: widget.content['location'].toString());
              TextEditingController quantityDistributedController =
                  TextEditingController(
                      text: widget.content['quantity_distributed'].toString());
              TextEditingController distributionDateController =
                  TextEditingController(
                      text: widget.content['distribution_date'].toString());
              getEventIdsForEdit(locationController.text, eventController.text);
              getResourceIdsForEdit(resourceController.text);
              getVolunteerIdsForEdit(volunteerController.text);
              String? selectedEventId = eventController.text;
              String? selectedResourceId = resourceController.text;
              String? selectedVolunteerId = volunteerController.text;

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text('Distribution Details',
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
                          CustomText(
                              text:
                                  'distribution ID: ${widget.content['distribution_id']}'),
                          const SizedBox(height: 12),
                          CustomTextField(
                              hintText: '${widget.content['location']}',
                              labelText: 'Location',
                              controller: locationController,
                              readOnly: readonly),
                          CustomTextField(
                              hintText: 'Quantity Distributed',
                              labelText: 'Quantity Distributed',
                              controller: quantityDistributedController,
                              readOnly: readonly),
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: TextField(
                              controller: distributionDateController,
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
                              readOnly: true,
                              onTap: () async {
                              if(!readonly){
                                DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                distributionDateController.text = pickedDate
                                  .toIso8601String()
                                  .substring(0, 10);
                              }
                              }
                              },
                            ),
                          ),
                          Visibility(
                            visible: readonly,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FutureBuilder(
                                future: getVolunteerIdsNoEdit(volunteerController.text),
                                builder: (BuildContext context,
                                    AsyncSnapshot<void> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Text('Error loading volunteers');
                                  } else {
                                    return DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Volunteer Name',
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
                                      value: selectedVolunteerId,
                                      style: const TextStyle(color: Colors.white),
                                      dropdownColor:
                                          const Color.fromARGB(255, 38, 36, 36),
                                      items: volunteers.keys.map((key) {
                                        return DropdownMenuItem<String>(
                                          value: key.toString(),
                                          child: Text(volunteers[key]!),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedVolunteerId = newValue!;
                                        });
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          
                          Visibility(
                            visible: readonly,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FutureBuilder<void>(
                                future: getResourceIdsNoEdit(locationController.text,resourceController.text),
                                builder: (BuildContext context,
                                    AsyncSnapshot<void> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Text('Error loading resources');
                                  } else {
                                    return DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Resource Name',
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
                                      value: selectedResourceId,
                                      style: const TextStyle(color: Colors.white),
                                      dropdownColor:
                                          const Color.fromARGB(255, 38, 36, 36),
                                      items: resources.keys.map((key) {
                                        return DropdownMenuItem<String>(
                                          value: key.toString(),
                                          child: Text(resources[key]!),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedResourceId = newValue!;
                                        });
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                          Visibility(
                            visible: readonly,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FutureBuilder<void>(
                                future: getEventIdsNoEdit(locationController.text,
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
                          ),
                          Visibility(
                            visible: !readonly,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: FutureBuilder(
                                future: getVolunteerIdsForEdit(volunteerController.text),
                                builder: (BuildContext context,
                                    AsyncSnapshot<void> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Text('Error loading volunteers');
                                  } else {
                                    return DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Volunteer Name',
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
                                      value: selectedVolunteerId,
                                      style: const TextStyle(color: Colors.white),
                                      dropdownColor:
                                          const Color.fromARGB(255, 38, 36, 36),
                                      items: volunteers.keys.map((key) {
                                        return DropdownMenuItem<String>(
                                          value: key.toString(),
                                          child: Text(volunteers[key]!),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedVolunteerId = newValue!;
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
                                future: getResourceIdsForEdit(resourceController.text),
                                builder: (BuildContext context,
                                    AsyncSnapshot<void> snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Text('Error loading resources');
                                  } else {
                                    return DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        labelText: 'Resource Name',
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
                                      value: selectedResourceId,
                                      style: const TextStyle(color: Colors.white),
                                      dropdownColor:
                                          const Color.fromARGB(255, 38, 36, 36),
                                      items: resources.keys.map((key) {
                                        return DropdownMenuItem<String>(
                                          value: key.toString(),
                                          child: Text(resources[key]!),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedResourceId = newValue!;
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
                                future: getEventIdsForEdit(locationController.text,
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
                          if (checkAcess(
                              'aid_distribution', locationController.text)) {
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
                          if (checkAcess(
                              'aid_distribution', locationController.text)) {
                            response = await updateData(
                              {
                                'table': 'aid_distribution',
                                'distribution_id':
                                    widget.content['distribution_id'],
                                'event_id': selectedEventId,
                                'resource_id': resourceController.text,
                                'volunteer_id': volunteerController.text,
                                'quantity_distributed':
                                    quantityDistributedController.text,
                                'distribution_date':
                                    distributionDateController.text,
                                'location': locationController.text,
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
