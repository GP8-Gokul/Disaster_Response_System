import 'package:drs/screens/resources_page/resources_list_tile.dart';
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
import 'package:rive/rive.dart';
import 'dart:developer' as devtools show log;

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

  if (!(checkAcess('resources', " "))) {
    events.removeWhere(
        (key, value) => key.toString() != eventController.toString());
  }

  devtools.log(events.toString());
}

class ResourceScreenB extends StatefulWidget {
  const ResourceScreenB({super.key});
  static String routeName = 'Resources';

  @override
  State<ResourceScreenB> createState() => _ResourceScreenBState();
}

class _ResourceScreenBState extends State<ResourceScreenB> {
  late Future<List<Map<String, dynamic>>> futureGetResources;
  dynamic response;
  bool shouldSort = false;
  StateMachineController? _controller;
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    super.initState();
    futureGetResources = fetchdata('resources');
    futureGetResources.then((events) {
      setState(() {
        allData = events;
        filteredData = events;
      });
    });
    devtools.log(allData.toString());
    searchController.addListener(_filterData);
  }

  void _filterData() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredData = allData.where((element) {
        final resourceName = element['resource_name'].toString().toLowerCase();
        return resourceName.contains(query);
      }).toList();
    });
  }

  void _sortData(bool shouldSort) {
    if (shouldSort) {
      setState(() {
        filteredData.sort((a, b) {
          int quantityA = int.tryParse(a['quantity'].toString()) ?? 0;
          int quantityB = int.tryParse(b['quantity'].toString()) ?? 0;
          String availabilityA =
              a['availability_status'].toString().toLowerCase();
          String availabilityB =
              b['availability_status'].toString().toLowerCase();

          if (availabilityA == 'yes' && availabilityB == 'yes') {
            return quantityB.compareTo(quantityA); // Descending order
          } else if (availabilityA == 'yes') {
            return -1;
          } else if (availabilityB == 'yes') {
            return 1;
          } else {
            return 0;
          }
        });
      });
    } else {
      setState(() {
        filteredData.sort((a, b) {
          int resourceIdA = int.tryParse(a['resource_id'].toString()) ?? 0;
          int resourceIdB = int.tryParse(b['resource_id'].toString()) ?? 0;
          return resourceIdA.compareTo(resourceIdB); // Ascending order
        });
      });
    }
    devtools.log(filteredData.toString());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          const BackgroundImage(imageName: 'page_background'),
          Scaffold(
            appBar: const CustomAppbar(text: 'Resources'),
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
              child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.0),
          child: SearchTextField(
            labelText: 'Search Resources',
            hintText: 'Enter item Name',
            searchController: searchController,
          ),
              ),
            ),
            GestureDetector(
              onTap: () {
          setState(() {
            shouldSort = !shouldSort;
            _sortData(shouldSort);

            // Update the Rive animation's 'check' input
            if (_controller != null) {
              final input = _controller?.findInput<bool>('check');
              if (input != null) {
                input.value = shouldSort;
              }
            }
          });
              },
              child: SizedBox(
          width: 80, // Increased width
          height: 100, // Increased height
          child: RiveAnimation.asset(
            'assets/rive/dbms_animation.riv',
            artboard: 'sort_button',
            onInit: (artboard) {
              final controller = StateMachineController.fromArtboard(
                artboard,
                'State Machine 1',
              );
              if (controller != null) {
                artboard.addController(controller);
                _controller =
              controller; // Save controller globally to access it in onTap

                final input = controller.findInput<bool>('check');
                if (input != null) {
            input.value = shouldSort;
                }
              }
            },
          ),
              ),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder(
            future: futureGetResources,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CustomLoadingAnimation());
              } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No resource found'));
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
      future: futureGetResources,
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
                    if (checkAcess('resources', userName) == true) {
                      response = await deleteData('resources', 'resource_id',
                          content['resource_id'].toString());
                      if (response != null) {
                        setState(() {
                          futureGetResources = fetchdata('resources');
                          futureGetResources.then((events) {
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
                          message: 'You do not have access to delete .');
                    }
                  },
                ),
              ],
            ),

            //Displaey Resource Details

            child: ResourceListTile(
              content: content,
              onChange: () {
                setState(() {
                  futureGetResources = fetchdata('resources');
                  futureGetResources.then((events) {
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
        if (checkAcess('resources', userName) == true) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              TextEditingController resourcenamecontroller =
                  TextEditingController();
              TextEditingController resourcetypecontroller =
                  TextEditingController();
              TextEditingController quantitycontroller =
                  TextEditingController();
              TextEditingController availabilityStatusController =
                  TextEditingController();
              TextEditingController eventController = TextEditingController();

              getEventIds(eventController.text);
              String? selectedEventId;

              return AlertDialog(
                title: const Text('Add New Resources'),
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
                        hintText: 'Resource Name',
                        labelText: 'Resource Name',
                        controller: resourcenamecontroller,
                        readOnly: false),
                    CustomTextField(
                        hintText: 'Resource Type',
                        labelText: 'Resource Type',
                        controller: resourcetypecontroller,
                        readOnly: false),
                    CustomTextField(
                        hintText: 'Quantity',
                        labelText: 'Quantity',
                        controller: quantitycontroller,
                        readOnly: false),
                    CustomTextField(
                        hintText: 'Availability Status',
                        labelText: 'Availability Status',
                        controller: availabilityStatusController,
                        readOnly: false),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: FutureBuilder<void>(
                        future: getEventIds(eventController.text),
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
                  ],
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
                      if (resourcenamecontroller.text.isEmpty) {
                        customSnackBar(
                            context: context,
                            message: 'Please Enter Resource Name');
                      } else {
                        if (checkAcess('resources', userName)) {
                          devtools.log('inserting data');
                          devtools.log(selectedEventId!);
                          response = await insertData({
                            'table': 'resources',
                            'resource_name': resourcenamecontroller.text,
                            'resource_type': resourcetypecontroller.text,
                            'quantity': quantitycontroller.text,
                            'availability_status':
                                availabilityStatusController.text,
                            'event_id': selectedEventId,
                          });
                          if (response != null) {
                            setState(() {
                              futureGetResources = fetchdata('resources');
                              futureGetResources.then((events) {
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
              message: 'You do not have access to add new resources.');
        }
      },
    );
  }
}
