import 'package:drs/screens/disaster_events_page/insert_disaster_events.dart';
import 'package:drs/screens/disaster_events_page/update_disaster_events.dart';
import 'package:drs/services/api/root_api.dart';
import 'package:drs/widgets/background_image.dart';
import 'package:drs/widgets/custom_appbar.dart';
import 'package:drs/widgets/custom_loading_animation.dart';
import 'package:drs/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:drs/services/authorization/check_access.dart';
import 'dart:developer' as devtools show log;
import 'package:flutter_slidable/flutter_slidable.dart';

class DisasterEventsScreen extends StatefulWidget {
  const DisasterEventsScreen({super.key});
  static String routeName = 'disaster-events';

  @override
  State<DisasterEventsScreen> createState() => _DisasterEventsScreenState();
}

class _DisasterEventsScreenState extends State<DisasterEventsScreen> {
  late Future<List<Map<String, dynamic>>> futureGetDisasterEvents;
  dynamic response;
  List<Map<String, dynamic>> allEvents = [];
  List<Map<String, dynamic>> filteredEvents = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureGetDisasterEvents = fetchdata('disaster_events');
    futureGetDisasterEvents.then((events) {
      setState(() {
        allEvents = events;
        filteredEvents = events;
      });
    });
    searchController.addListener(_filterEvents);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterEvents() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredEvents = allEvents
          .where((event) => event['event_name'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          const BackgroundImage(
            imageName: 'page_background',
          ),
          Scaffold(
            appBar: CustomAppbar(text: 'Disaster Events'),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchController,
                    style: const TextStyle(
                        color: Colors.white), // Set text color to white
                    decoration: InputDecoration(
                      labelText: 'Search Events',
                      hintText: 'Enter event name',
                      hintStyle: const TextStyle(
                          color: Colors.white), // Set hint text color to white
                      labelStyle: const TextStyle(
                          color: Colors.white), // Set label text color to white
                      iconColor: const Color.fromARGB(255, 240, 235, 235),
                      prefixIcon: const Icon(Icons.search,
                          color: Colors.white), // Set icon color to white
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                  padding: const EdgeInsets.only(bottom: 85.0),
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: futureGetDisasterEvents,
                    builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                      child: CustomLoadingAnimation(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                      child: Text(
                        'Error loading events.',
                        style: TextStyle(
                        fontSize: 18.0,
                        color: Color.fromARGB(255, 222, 211, 211),
                        ),
                      ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                      child: Text(
                        'Record not present.',
                        style: TextStyle(
                        fontSize: 18.0,
                        color: Color.fromARGB(255, 222, 211, 211),
                        ),
                      ),
                      );
                    } else {
                      return ListView.builder(
                      itemCount: filteredEvents.length,
                      itemBuilder: (context, index) {
                        final event = filteredEvents[index];
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
                              if (checkAcess(
                                'disaster_events', userName)) {
                              final result = await deleteData(
                                'disaster_events',
                                'event_id',
                                event['event_id']);
                              if (result != 0) {
                                setState(() {
                                allEvents.remove(event);
                                filteredEvents.remove(event);
                                });
                              } else {
                                customSnackBar(
                                  // ignore: use_build_context_synchronously
                                  context: context,
                                  message:
                                    'Failed to delete event');
                              }
                              } else {
                              // ignore: use_build_context_synchronously
                              customSnackBar(
                                context: context,
                                message:
                                  'You do not have access to delete events');
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
                                fetchdata('disaster_events'),
                              event: event,
                              response:
                                null, // Pass any additional data you need
                            ),
                            );
                            devtools.log(updatedEvent.toString());
                            if (updatedEvent != null) {
                            devtools.log('change reflected');
                            setState(() {
                              futureGetDisasterEvents =
                                fetchdata('disaster_events');
                              futureGetDisasterEvents
                                .then((events) {
                              setState(() {
                                allEvents = events;
                                filteredEvents = events;
                              });
                              });
                            });
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color.fromARGB(
                                255, 153, 153, 43),
                              width: 2.0),
                            color: const Color.fromARGB(
                                255, 227, 217, 217)
                              .withOpacity(0.1),
                            borderRadius:
                              BorderRadius.circular(25.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 24.0),
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
                                "Name: ${event['event_name']}",
                                style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(
                                255, 229, 219, 219),
                                ),
                                overflow:
                                TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "ID: ${event['event_id']}",
                                style: const TextStyle(
                                fontSize: 14.0,
                                color: Color.fromARGB(
                                209, 180, 172, 172),
                                ),
                                overflow:
                                TextOverflow.ellipsis,
                              ),
                              ],
                              ),
                              ),
                              IconButton(
                              icon: const Icon(Icons.chat_bubble, color: Colors.white),
                              onPressed: () {
                              if(checkAcess('messages', '')){
                                Navigator.pushNamed(
                                  context, 
                                  'chat-room', 
                                  arguments: {'event_id': event['event_id']}
                                );
                              } else {
                                customSnackBar(context: context, message: 'You do not have access to chat');
                              }
                              },
                              ),
                            ],
                            ),
                          ),
                          ),
                        ),
                        );
                      },
                      );
                    }
                    },
                  ),
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                devtools.log('Floating action button pressed');
                if (checkAcess('disaster_events', userName) == true) {
                  final result = await insertDisasterEventsDialog(
                      context, () => fetchdata('disaster_events'), response);
                  // ignore: unrelated_type_equality_checks
                  if (result != 0) {
                    setState(() {
                      futureGetDisasterEvents = fetchdata('disaster_events');
                      futureGetDisasterEvents.then((events) {
                        setState(() {
                          allEvents = events;
                          filteredEvents = events;
                        });
                      });
                    });
                  } else {
                    customSnackBar(
                        // ignore: use_build_context_synchronously
                        context: context,
                        message: 'Please fill all the fields');
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                } else {
                  // ignore: use_build_context_synchronously
                  customSnackBar(
                      context: context,
                      message: 'You do not have access to add events');
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
