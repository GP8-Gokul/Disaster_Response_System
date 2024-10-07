import 'package:drs/services/authorization/check_access.dart';
import 'package:drs/services/api/root_api.dart';
import 'package:drs/widgets/background_image.dart';
import 'package:drs/widgets/custom_appbar.dart';
import 'package:drs/screens/volunteers_page/volunteer_list_tile.dart';
import 'package:drs/widgets/custom_snack_bar.dart';
import 'package:drs/widgets/custom_text_field.dart';
import 'package:drs/widgets/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:developer' as devtools;

bool changeInState = false;
var events = {};

Future<void> getEventIds(String eventController) async {

  events.clear();
  List<Map<String, dynamic>> value = await fetchdata('disaster_events');
  for (var event in value) {
    events[event['event_id']] = event['event_name'];
  }
  devtools.log(events.toString());
  devtools.log(eventController);
  devtools.log(volunteerName);
  if (!(checkAcess('aid_distribution', ""))) {
    events.removeWhere((key, value) => key.toString() != eventController.toString());
  }
  devtools.log(events.toString());
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
    futureGetAidDistribution.then((events) {
      setState(() {
        allData = events;
        filteredData = events;
      });
    });
    searchController.addListener(_filterData);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          const BackgroundImage(imageName: 'page_background'),
          Scaffold(
            appBar: const CustomAppbar(text: 'Aid Distribution Details'),
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
        
              : buildFutureBuilder(),
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
          return const Center(child: Text('No aids found.'));
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
                    if (checkAcess('aid_distribution', "")) {
                      response = await deleteData('aid_distribution', 'distribution_id',content['distribution_id'].toString());
                      if (response != null) {
                            setState(() {
                              futureGetAidDistribution = fetchdata('aid_distribution');
                              futureGetAidDistribution.then((events) {
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
                          message:'You do not have access to delete this aid.'
                          );
                    }
                  },

                ),
              ],
            ),

            //Display Aid Details

            child: AidDistributionListTile(
              content: content,
              onChange: () {
                setState(() {
                  futureGetAidDistribution = fetchdata('aid_distribution');
                  futureGetAidDistribution.then((events) {
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
        if(checkAcess('aid_distribution', '')){
          showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController aidDistributionIdController = TextEditingController();
            TextEditingController aidDistributionResourceIdController = TextEditingController();
            TextEditingController aidDistributionVolunteerIdController = TextEditingController();
            TextEditingController aidDistributionQuantityController = TextEditingController();
            TextEditingController aidDistributionEventController = TextEditingController();
aidDistributionDateController = TextEditingController();
aidDistributionLocationController = TextEditingController();
            getEventIds( eventController.text);
            String? selectedEventId; 

            return AlertDialog(
              title: const Text('Add New Aid'),
              titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold
              ),
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
                      readOnly: false
                  ),
                  CustomTextField(
                      hintText: 'Contact Info',
                      labelText: 'Contact Info',
                      controller: volunteerContactInfoController,
                      readOnly: false
                  ),
                  CustomTextField(
                      hintText: 'Skills',
                      labelText: 'Skills',
                      controller: volunteerSkillsController,
                      readOnly: false
                  ),
                  CustomTextField(
                      hintText: 'Availability Status',
                      labelText: 'Availability Status',
                      controller: volunteerAvailabilityStatusController,
                      readOnly: false
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: FutureBuilder<void>(
                      future: getEventIds(volunteerNameController.text,eventController.text),
                      builder: (BuildContext context,AsyncSnapshot<void> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return const Text('Error loading events');
                        } else {
                          return DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Event Name',
                              labelStyle: const TextStyle(color: Colors.white),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.lime),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Color.fromARGB(255, 200, 99, 92)),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: const BorderSide(color: Colors.lime, width: 2.0),
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
                ],
              ),
              actions: <Widget>[

                // Insert Cancel Button

                TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                //Insert Button

                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Submit', style: TextStyle(color: Colors.black)),
                  onPressed: () async {
                    if(volunteerNameController.text.isEmpty){
                      customSnackBar(context: context, message: 'Please Enter Volunteer Name');
                    } else if(selectedEventId == null){
                      customSnackBar(context: context, message: 'Please Select Event Name');
                    } 
                    else{
                      if (checkAcess('aid_distribution', '')) {
                        response = await insertData({
                          'table': 'aid_distribution',
                          'name': volunteerNameController.text,
                          'contact_info': volunteerContactInfoController.text,
                          'skills': volunteerSkillsController.text,
                          'availability_status': volunteerAvailabilityStatusController.text,
                          'event_id': selectedEventId,
                        });
                        if (response != null) {
                          setState(() {
                            futureGetAidDistribution = fetchdata('aid_distribution');
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
                    if(mounted){
                      // ignore: use_build_context_synchronously
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            );
          },
        );
        }
        else{
          customSnackBar(context: context, message: 'You do not have access to add new aids.');
        }
      },
    );
  }
}