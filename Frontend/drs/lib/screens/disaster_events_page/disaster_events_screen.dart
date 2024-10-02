import 'package:drs/screens/disaster_events_page/insert_disaster_events.dart';
import 'package:drs/screens/disaster_events_page/update_disaster_events.dart';
import 'package:drs/services/api/root_api.dart';
import 'package:drs/widgets/background_image.dart';
import 'package:drs/widgets/custom_appbar.dart';
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
          BackgroundImage(imageName: 'page_background',),
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
                    child: filteredEvents.isEmpty
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
                                              // ignore: use_build_context_synchronously
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      'Failed to delete event'),
                                                  backgroundColor: Colors.red,
                                                ),
                                              );
                                            }
                                          } else {
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'You do not have access to delete events'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
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
                                                  "Name: ${event['event_name']}",
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
                                                  "ID: ${event['event_id']}",
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
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please fill all the fields'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    // ignore: use_build_context_synchronously
                    Navigator.of(context).pop();
                  }
                } else {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('You do not have access to add events'),
                      backgroundColor: Colors.red,
                    ),
                  );
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
