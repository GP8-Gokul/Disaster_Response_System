import 'package:drs/services/authorization/check_access.dart';
import 'package:drs/services/api/unused_disaster_event_api.dart';
import 'package:drs/services/api/root_api.dart';
import 'package:drs/widgets/background_image.dart';
import 'package:drs/widgets/custom_appbar.dart';
import 'package:drs/screens/volunteers_page/volunteer_list_tile.dart';
import 'package:drs/widgets/custom_snack_bar.dart';
import 'package:drs/widgets/custom_text.dart';
import 'package:drs/widgets/custom_text_field.dart';
import 'package:drs/widgets/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

bool changeInState = false;
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          const BackgroundImage(),
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
        SearchTextField(
            labelText: 'Search Volunteers',
            hintText: 'Enter Volunteer Name',
            searchController: searchController),
        Expanded(
          child: filteredData.isEmpty
              ? const Center(child: Text('No volunteers found.'))
              : buildFutureBuilder(),
        ),
        SizedBox(
          height: 70,
        )
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
          return const Center(child: Text('No volunteers found.'));
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
                SlidableAction(
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
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Access Denied',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold
                                    )
                                    ),
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  width: 3.0),
                            ),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText(
                                    text:
                                        'You do not have access to delete this data'),
                                const SizedBox(height: 12),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                child: const Text('OK',
                                    style: TextStyle(color: Colors.black)),
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
                  backgroundColor: const Color.fromARGB(138, 236, 70, 70),
                  icon: Icons.delete,
                  foregroundColor: const Color.fromARGB(255, 238, 230, 230),
                ),
              ],
            ),
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

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.white.withOpacity(0.7),
      child: const Icon(Icons.add),
      onPressed: () {
        if(checkAcess('volunteers', '')){
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
                TextEditingController();
            getEventIds();
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
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  CustomTextField(
                      hintText: 'Availability Status',
                      labelText: 'Availability Status',
                      controller: volunteerAvailabilityStatusController,
                      readOnly: false),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Event Name',
                      labelStyle: const TextStyle(color: Colors.white),
                      enabled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.lime),
                      ),
                    ),
                    value: selectedEventId,
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
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Submit',
                      style: TextStyle(color: Colors.black)),
                  onPressed: () async {
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
                  },
                ),
              ],
            );
          },
        );
        }
        else{
          customSnackBar(context: context, message: 'You do not have access to add new volunteers.');
        }
      },
    );
  }
}
