import 'package:drs/screens/disaster_events_page/display_disaster_events.dart';
import 'package:drs/screens/disaster_events_page/insert_disaster_events.dart';
import 'package:drs/services/api/disaster_event_api.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:drs/screens/hero_dialog_route.dart';
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
                color: Colors.white,
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
                                      onPressed: (context) {
                                        devtools.log('Slide action pressed');
                                      },
                                      backgroundColor: const Color.fromARGB(
                                          255, 255, 102, 102),
                                      icon: Icons.delete,
                                      label: 'Delete',
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
                                              .withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(15.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
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
                                                  color: Colors.white,
                                                ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 6),
                                              Text(
                                                "ID: ${event['event_id']}",
                                                style: const TextStyle(
                                                  fontSize: 14.0,
                                                  color: Colors.white70,
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
                                          onPressed: () {
                                            devtools.log('Event updated');
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
                final result = await showDisasterEventsDialog(
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
              backgroundColor: Colors.redAccent,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
