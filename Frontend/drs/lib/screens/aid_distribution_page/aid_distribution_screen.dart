import 'package:drs/screens/aid_distribution_page/aid_distribution_list_tile.dart';
import 'package:drs/services/authorization/check_access.dart';
import 'package:drs/services/api/root_api.dart';
import 'package:drs/widgets/background_image.dart';
import 'package:drs/widgets/custom_appbar.dart';
import 'package:drs/widgets/custom_loading_animation.dart';
import 'package:drs/widgets/custom_snack_bar.dart';
import 'package:drs/widgets/custom_text_field.dart';
import 'package:drs/widgets/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:developer' as devtools;

bool changeInState = false;
var events = {};
var resources = {};
var volunteers = {};
Future<void> getEventIds(String location, String eventController) async {
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

Future<void> getResourceIds(String resourceController) async {
  resources.clear();
  List<Map<String, dynamic>> value = await fetchdata('resources');
  for (var resource in value) {
    resources[resource['resource_id']] = resource['resource_name'];
  }
  devtools.log(resources.toString());
  devtools.log(resourceController);
  if (!(checkAcess('aid_distribution', ''))) {
    resources.removeWhere(
        (key, value) => key.toString() != resourceController.toString());
  }
  devtools.log(resources.toString());
}

Future<void> getVolunteerIds(String volunteerController) async {
  volunteers.clear();
  List<Map<String, dynamic>> value = await fetchdata('volunteers');
  for (var volunteer in value) {
    volunteers[volunteer['volunteer_id']] = volunteer['volunteer_name'];
  }
  devtools.log(volunteers.toString());
  devtools.log(volunteerController);
  if (!(checkAcess('aid_distribution', ''))) {
    volunteers.removeWhere(
        (key, value) => key.toString() != volunteerController.toString());
  }
  devtools.log(volunteers.toString());
}

class AidDistributionScreen extends StatefulWidget {
  const AidDistributionScreen({super.key});
  static String routeName = 'aid_distribution';

  @override
  State<AidDistributionScreen> createState() => _AidDistributionScreenState();
}

class _AidDistributionScreenState extends State<AidDistributionScreen> {
  late Future<List<Map<String, dynamic>>> futureGetAidDistribution;
  dynamic response;

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    super.initState();
    futureGetAidDistribution = fetchdata('aid_distribution');
    futureGetAidDistribution.then((content) {
      setState(() {
        allData = content;
        filteredData = content;
      });
    });
    searchController.addListener(_filterData);
  }

  void _filterData() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredData = allData.where((element) {
        final location = element['location'].toString().toLowerCase();
        return location.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          const BackgroundImage(imageName: 'page_background'),
          Scaffold(
            appBar: const CustomAppbar(text: 'Aid Distribution'),
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
        SearchTextField(
            labelText: 'Search Location',
            hintText: 'Enter Location Name',
            searchController: searchController),
        Expanded(
          child: FutureBuilder(
            future: futureGetAidDistribution,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CustomLoadingAnimation());
              } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No location found.'));
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
      future: futureGetAidDistribution,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No location found.'));
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
                    if (checkAcess('aid_distribution', ' ')) {
                      response = await deleteData(
                          'aid_distribution',
                          'distribution_id',
                          content['distribution_id'].toString());
                      if (response != null) {
                        setState(() {
                          futureGetAidDistribution =
                              fetchdata('aid_distribution');
                          futureGetAidDistribution.then((content) {
                            setState(() {
                              allData = content;
                              filteredData = content;
                            });
                          });
                          searchController.addListener(_filterData);
                        });
                      }
                    } else {
                      customSnackBar(
                          context: context,
                          message:
                              'You do not have access to delete this data.');
                    }
                  },
                ),
              ],
            ),

            //Display Volunteer Details

            child: AidDistributionListTile(
              content: content,
              onChange: () {
                setState(() {
                  futureGetAidDistribution = fetchdata('aid_distribution');
                  futureGetAidDistribution.then((content) {
                    setState(() {
                      allData = content;
                      filteredData = content;
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
        if (checkAcess('aid_distribution', '')) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController eventController = TextEditingController();
              TextEditingController resourceController =
                  TextEditingController();
              TextEditingController volunteerController =
                  TextEditingController();
              TextEditingController locationController =
                  TextEditingController();
              TextEditingController quantityDistributedController =
                  TextEditingController();
              TextEditingController distributionDateController =
                  TextEditingController();

              getEventIds(locationController.text, eventController.text);
              getResourceIds(resourceController.text);
              getVolunteerIds(volunteerController.text);
              String? selectedEventId;
              String? selectedResourceId;
              String? selectedVolunteerId;

              return AlertDialog(
                title: const Text('Add New Aid'),
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
                      CustomTextField(
                          hintText: 'Location',
                          labelText: 'Location',
                          controller: locationController,
                          readOnly: false),
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
                              borderSide: const BorderSide(color: Colors.lime),
                            ),
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100),
                            );
                            if (pickedDate != null) {
                              distributionDateController.text =
                                  pickedDate.toIso8601String().substring(0, 10);
                            }
                          },
                        ),
                      ),
                      CustomTextField(
                          hintText: 'Quantity Distributed',
                          labelText: 'Quantity Distributed',
                          controller: quantityDistributedController,
                          readOnly: false
                        ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: FutureBuilder<void>(
                          future: getEventIds(
                              locationController.text, eventController.text),
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
                                        color: Color.fromARGB(255, 200, 99, 92)),
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
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: FutureBuilder<void>(
                          future: getResourceIds(resourceController.text),
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
                                    borderSide: BorderSide(color: Colors.lime),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 200, 99, 92)),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.lime, width: 2.0),
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
                      Padding(
                        padding: EdgeInsets.all(4.0),
                        child: FutureBuilder(
                          future: getVolunteerIds(volunteerController.text),
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
                                    borderSide: BorderSide(color: Colors.lime),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 200, 99, 92)),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                        color: Colors.lime, width: 2.0),
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
                      devtools.log(selectedEventId.toString());
                      devtools.log(selectedResourceId.toString());
                      devtools.log(selectedVolunteerId.toString());
                      if (selectedVolunteerId == null) {
                        customSnackBar(
                            context: context,
                            message: 'Please Enter Volunteer Name');
                      } else if (selectedResourceId == null) {
                        customSnackBar(
                            context: context,
                            message: 'Please Enter Resource Name');
                      } else if (selectedEventId == null) {
                        customSnackBar(
                            context: context,
                            message: 'Please Select Event Name');
                      } else {
                        if (checkAcess('aid_distribution', '')) {
                          response = await insertData({
                            'table': 'aid_distribution',
                            'event_id': selectedEventId,
                            'resource_id': selectedResourceId,
                            'volunteer_id': selectedVolunteerId,
                            'quantity_distributed':
                                quantityDistributedController.text,
                            'distribution_date':
                                distributionDateController.text,
                            'location': locationController.text,
                          });
                          if (response != null) {
                            setState(() {
                              futureGetAidDistribution =
                                  fetchdata('aid_distribution');
                              futureGetAidDistribution.then((events) {
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
              message: 'You do not have access to add new aid_distribution.');
        }
      },
    );
  }
}
