import 'package:drs/services/authorization/check_access.dart';
import 'package:drs/services/api/root_api.dart';
import 'package:drs/widgets/background_image.dart';
import 'package:drs/widgets/custom_appbar.dart';
import 'package:drs/screens/volunteers_page/volunteer_list_tile.dart';
import 'package:drs/widgets/custom_loading_animation.dart';
import 'package:drs/widgets/custom_snack_bar.dart';
import 'package:drs/widgets/custom_text_field.dart';
import 'package:drs/widgets/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:developer' as devtools;

bool changeInState = false;
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

class VolunteersScreen extends StatefulWidget {
  const VolunteersScreen({super.key});
  static String routeName = 'volunteers';

  @override
  State<VolunteersScreen> createState() => _VolunteersScreenState();
}

class _VolunteersScreenState extends State<VolunteersScreen> {
  late Future<List<Map<String, dynamic>>> futureGetVolunteers;
  dynamic response;

  TextEditingController searchController = TextEditingController();
  ValueNotifier<bool> isAvailable = ValueNotifier<bool>(false);
  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    super.initState();
    futureGetVolunteers = fetchdata('volunteers');
    futureGetVolunteers.then((events) {
      setState(() {
        allData = events;
        filteredData = events;
      });
    });
    searchController.addListener(_filterData);
    isAvailable.addListener(() {
      _isAvailable(isAvailable.value);
    });
  }

  void _filterData() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredData = allData.where((element) {
        final volunteerName =
            element['volunteer_name'].toString().toLowerCase();
        return volunteerName.contains(query);
      }).toList();
    });
  }

  void _isAvailable(bool isAvailable) {
    setState(() {
      if (isAvailable) {
        filteredData = allData.where((element) {
          final availabilityStatus = element['volunteer_availability_status']
              .toString()
              .trim()
              .toLowerCase();
          return availabilityStatus == 'yes';
        }).toList();
      } else {
        filteredData = allData;
      }
      devtools.log(filteredData.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          const BackgroundImage(imageName: 'page_background'),
          Scaffold(
            appBar: const CustomAppbar(text: 'Volunteer Details'),
            body: bodyColumn(),
            floatingActionButton: buildFloatingActionButton(),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  Column bodyColumn() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: SearchTextField(
                labelText: 'Search Volunteers',
                hintText: 'Enter Volunteer Name',
                searchController: searchController,
              ),
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isAvailable,
              builder: (context, value, child) {
                return GestureDetector(
                  child: Container(
                    height: 72,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: value
                          ? Colors.green
                          : const Color.fromARGB(255, 127, 120, 120),
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.white,
                        width: 2.0,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        value ? 'Available' : 'Everyone',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 20, 20, 20),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    isAvailable.value = !isAvailable.value;
                  },
                );
              },
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder(
            future: futureGetVolunteers,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CustomLoadingAnimation());
              } else if (filteredData.isEmpty) {
          return const Center(child: Text('No volunteers found.'));
              } else {
          return buildListview(snapshot);
              }
            },
          ),
        ),
        SizedBox(height: 70),
      ],
    );
  }

  FutureBuilder buildFutureBuilder() {
    return FutureBuilder(
      future: futureGetVolunteers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const CustomLoadingAnimation();
        } else {
          return buildListview(snapshot);
        }
      },
    );
  }

  Widget buildListview(snapshot) {
    return ListView.builder(
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final content = filteredData[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                //Delete Functionality

                SlidableAction(
                  backgroundColor: const Color.fromARGB(138, 236, 70, 70),
                  icon: Icons.delete,
                  foregroundColor: const Color.fromARGB(255, 238, 230, 230),
                  onPressed: (context) async {
                    if (checkAcess('volunteers', content['volunteer_name'])) {
                      response = await deleteData('volunteers', 'volunteer_id',
                          content['volunteer_id'].toString());
                      if (response != null) {
                        setState(() {
                          futureGetVolunteers = fetchdata('volunteers');
                          futureGetVolunteers.then((events) {
                            setState(() {
                              allData = events;
                              filteredData = events;
                            });
                          });
                          searchController.addListener(_filterData);
                        });
                      }
                    } else {
                      customSnackBar(
                          context: context,
                          message:
                              'You do not have access to delete this volunteer.');
                    }
                  },
                ),
              ],
            ),

            //Display Volunteer Details

            child: VolunteerListTile(
              content: content,
              onChange: () {
                setState(() {
                  futureGetVolunteers = fetchdata('volunteers');
                  futureGetVolunteers.then((events) {
                    setState(() {
                      allData = events;
                      filteredData = events;
                    });
                  });
                  searchController.addListener(_filterData);
                });
              },
            ),
          ),
        );
      },
    );
  }

  //Insert

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.white.withOpacity(0.7),
      child: const Icon(Icons.add),
      onPressed: () {
        if (checkAcess('volunteers', '')) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController volunteerNameController =
                  TextEditingController();
              TextEditingController volunteerContactInfoController =
                  TextEditingController();
              TextEditingController volunteerSkillsController =
                  TextEditingController();
              TextEditingController volunteerAvailabilityStatusController =
                  TextEditingController(text: 'Yes');
              TextEditingController eventController = TextEditingController();
              bool isAvailable = false;

              getEventIds(volunteerNameController.text, eventController.text);
              String? selectedEventId;

              return AlertDialog(
                title: const Text('Add New Volunteer'),
                titleTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
                backgroundColor: Colors.grey[900],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: const BorderSide(color: Colors.white, width: 2.0),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Row(
                            children: [
                              const Text(
                                'Availability Status:',
                                style: TextStyle(color: Colors.white),
                              ),
                              Checkbox(
                                value: isAvailable,
                                onChanged: (bool? newValue) {
                                  setState(() {
                                    isAvailable = newValue ?? false;
                                  });
                                },
                                activeColor: Colors.green,
                                checkColor: Colors.white,
                              ),
                              Text(
                                isAvailable ? 'Yes' : 'No',
                                style: TextStyle(
                                  color:
                                      isAvailable ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      CustomTextField(
                          hintText: 'Volunteer Name',
                          labelText: 'Volunteer Name',
                          controller: volunteerNameController,
                          readOnly: false),
                      CustomTextField(
                          hintText: 'Contact Info',
                          labelText: 'Contact Info',
                          controller: volunteerContactInfoController,
                          readOnly: false),
                      CustomTextField(
                          hintText: 'Skills',
                          labelText: 'Skills',
                          controller: volunteerSkillsController,
                          readOnly: false),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: FutureBuilder<void>(
                          future: getEventIds(volunteerNameController.text,
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
                                    borderSide: BorderSide(color: Colors.lime),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Color.fromARGB(255, 200, 99, 92)),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.lime, width: 2.0),
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
                  // Insert Cancel Button

                  TextButton(
                    style: TextButton.styleFrom(backgroundColor: Colors.white),
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.black)),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),

                  //Insert Button

                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    child: const Text('Submit',
                        style: TextStyle(color: Colors.black)),
                    onPressed: () async {
                      if (volunteerNameController.text.isEmpty) {
                        customSnackBar(
                            context: context,
                            message: 'Please Enter Volunteer Name');
                      } else if (selectedEventId == null) {
                        customSnackBar(
                            context: context,
                            message: 'Please Select Event Name');
                      } else {
                        if (checkAcess('volunteers', '')) {
                          response = await insertData({
                            'table': 'volunteers',
                            'name': volunteerNameController.text,
                            'contact_info': volunteerContactInfoController.text,
                            'skills': volunteerSkillsController.text,
                            'availability_status':
                                volunteerAvailabilityStatusController.text,
                            'event_id': selectedEventId,
                          });
                          if (response != null) {
                            setState(() {
                              futureGetVolunteers = fetchdata('volunteers');
                              futureGetVolunteers.then((events) {
                                setState(() {
                                  allData = events;
                                  filteredData = events;
                                });
                              });
                              searchController.addListener(_filterData);
                            });
                          }
                        }
                      }
                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      }
                    },
                  ),
                ],
              );
            },
          );
        } else {
          customSnackBar(
              context: context,
              message: 'You do not have access to add new volunteers.');
        }
      },
    );
  }
}
