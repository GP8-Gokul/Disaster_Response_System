import 'package:drs/services/api/root_api.dart';
import 'package:drs/services/authorization/check_access.dart';
import 'package:drs/widgets/background_image.dart';
import 'package:drs/widgets/custom_appbar.dart';
import 'package:drs/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools;

class ResourcesScreen extends StatefulWidget {
  const ResourcesScreen({super.key});
  static String routeName = 'resources';

  @override
  State<ResourcesScreen> createState() => _ResourcesScreenState();
}

class _ResourcesScreenState extends State<ResourcesScreen> {
   late Future<List<Map<String, dynamic>>> futureGetResources;
  dynamic response;
  List<Map<String, dynamic>> allResources = [];
  List<Map<String, dynamic>> filteredResources = [];

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          const BackgroundImage(imageName: 'page_background',),
          Scaffold(
            appBar: CustomAppbar(text: 'Resources'),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(
                        color: Colors.white), // Set text color to white
                    decoration: InputDecoration(
                      labelText: 'Search Resources',
                      hintText: 'Enter Resource',
                      hintStyle: const TextStyle(
                          color: Colors.white), // Set hint text color to white
                      labelStyle: const TextStyle(
                          color: Colors.white), // Set label text color to white
                      iconColor: const Color.fromARGB(255, 240, 235, 235),
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.white), // Set icon color to white
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.white)
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 85.0),
                    child: filteredResource.isEmpty
                        ? const Center(
                            child: Text(
                              'Record not present.',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Color.fromARGB(255, 222, 211, 211),
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredResource.length,
                            itemBuilder: (context, index) {
                              final event = filteredResource[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                child: Slidable(
                                  endActionPane: ActionPane(
                                    motion: const StretchMotion(),
                                    children: [
                                      SlidableAction(
                                        borderRadius: BorderRadius.circular(25),
                                        onPressed: (context) async {
                                          devtools.log('Slide action pressed');
                                          if (checkAcess('resources', userName) == true) {
                                            final result = await deleteData(
                                                'resources',
                                                resources['resource_id']);
                                            if (result != 0) {
                                              setState(() {
                                                allResources.remove(event);
                                                filteredResources.remove(event);
                                              });
                                            } else {
                                              // ignore: use_build_context_synchronously
                                              customSnackBar(context: context, message: 'Failed to delete resource');
                                            }
                                          } else {
                                            // ignore: use_build_context_synchronously
                                            customSnackBar(context: context, message: 'You do not have access to delete events');
                                          }
                                        },
                                        backgroundColor: const Color.fromARGB(
                                            138, 236, 70, 70),
                                        icon: Icons.delete,
                                        foregroundColor: const Color.fromARGB(
                                            255, 238, 230, 230),
                                      ),
                                    ],
                                  ),
                                  child: GestureDetector(
                                    onTap: () async {
                                      devtools.log('Event tapped');
                                      final updatedEvent = await showDialog<
                                          Map<String, dynamic>>(
                                        context: context,
                                        builder: (context) =>
                                            UpdateDisasterEventsDialog(
                                          fetchDisasterEvents: () =>
                                              fetchdata('resources'),
                                          event: event,
                                          response:
                                              null, // Pass any additional data you need
                                        ),
                                      );
                                      devtools.log(updatedEvent.toString());
                                      if (updatedEvent != null) {
                                        devtools.log('change reflected');
                                        setState(() {
                                          futureGetResources =
                                              fetchdata('resources');
                                          futureGetResources
                                              .then((events) {
                                            setState(() {
                                              allResources = events;
                                              filteredResources = events;
                                            });
                                          });
                                        });
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                                255, 227, 217, 217)
                                            .withOpacity(0.6),
                                        borderRadius:
                                            BorderRadius.circular(25.0),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0, horizontal: 24.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Name: ${event['resource_name']}",
                                                  style: const TextStyle(
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Color.fromARGB(
                                                        255, 23, 22, 22),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 6),
                                                Text(
                                                  "ID: ${event['resource_id']}",
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                    color: Color.fromARGB(
                                                        209, 31, 30, 30),
                                                  ),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                devtools.log('Floating action button pressed');
                if (checkAcess('resources', userName) == true) {
                  final result = await insertResourceDialog(
                      context, () => fetchdata('resources'), response);
                  // ignore: unrelated_type_equality_checks
                  if (result != 0) {
                    setState(() {
                      futureGetResources = fetchdata('resources');
                      futureGetDisasterEvents.then((events) {
                        setState(() {
                          allResources = events;
                          filteredResources = events;
                        });
                      });
                    });
                  } else {
                    // ignore: use_build_context_synchronously
                    customSnackBar(context: context, message: 'Please fill all the fields');
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                } else {
                  // ignore: use_build_context_synchronously
                  customSnackBar(context: context, message: 'You do not have access to add events');
                }
              },
              backgroundColor: const Color.fromARGB(255, 23, 22, 22),
              child: const Icon(Icons.add, color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}



