import 'package:drs/screens/disaster_events_page/display_disaster_events.dart';
import 'package:drs/screens/disaster_events_page/insert_disaster_events.dart';
import 'package:drs/screens/disaster_events_page/update_disaster_events.dart';
import 'package:drs/services/api/disaster_event_api.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:drs/services/hero_dialog_route.dart';
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
    futureGetDisasterEvents = fetchDisasterEvents();
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
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Scaffold(
            appBar: AppBar(
              title: const Text('Disaster Events'),
              centerTitle: true,
              backgroundColor: const Color.fromARGB(100, 0, 0, 0),
              titleTextStyle: const TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 31, 29, 29),
              ),
              elevation: 5,
              shadowColor: Colors.black.withOpacity(0.3),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Events',
                      hintText: 'Enter event name',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: filteredEvents.isEmpty
                      ? const Center(
                          child: Text(
                            'Record not present.',
                            style: TextStyle(fontSize: 18.0),
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
                                      onPressed: (context) {
                                        devtools.log('Slide action pressed');
                                        deleteDisasterEvent(event['event_id']);
                                        setState(() {
                                          allEvents.remove(event);
                                          filteredEvents.remove(event);
                                        });
                                      },
                                      backgroundColor: const Color.fromARGB(
                                          148, 226, 125, 125),
                                      icon: Icons.delete,
                                      foregroundColor:
                                          const Color.fromARGB(255, 74, 71, 71),
                                    ),
                                  ],
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    devtools.log('Event tapped');
                                    Navigator.of(context).push(
                                      HeroDialogRoute(
                                        builder: (context) =>
                                            DisplayDisasterEvents(
                                          event: event,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          const Color.fromARGB(255, 70, 70, 70)
                                              .withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(25.0),
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
                                                      255, 41, 39, 39),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                "ID: ${event['event_id']}",
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: Color.fromARGB(
                                                      179, 47, 45, 45),
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.white,
                                          ),
                                          onPressed: () async {
                                            devtools.log('Edit button pressed');
                                            final result =
                                                await updateDisasterEventsDialog(
                                                    context,
                                                    fetchDisasterEvents,
                                                    event,
                                                    response);
                                            if (result != null) {
                                              setState(() {
                                                futureGetDisasterEvents =
                                                    fetchDisasterEvents();
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
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                devtools.log('Floating action button pressed');
                final result = await insertDisasterEventsDialog(
                    context, fetchDisasterEvents, response);
                if (result != null) {
                  setState(() {
                    futureGetDisasterEvents = fetchDisasterEvents();
                    futureGetDisasterEvents.then((events) {
                      setState(() {
                        allEvents = events;
                        filteredEvents = events;
                      });
                    });
                  });
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
