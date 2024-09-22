import 'package:drs/services/api/volunteer_api.dart';
import 'package:drs/screens/inserting/insert_volunteer.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:flutter_slidable/flutter_slidable.dart';

class VolunteersScreen extends StatefulWidget {
  const VolunteersScreen({super.key});
  static String routeName = 'volunteers';

  @override
  State<VolunteersScreen> createState() => _VolunteersScreenState();
}

class _VolunteersScreenState extends State<VolunteersScreen> {
  late Future<List<Map<String, dynamic>>> futureGetVolunteers;
  dynamic response;

  @override
  void initState() {
    super.initState();
    futureGetVolunteers = fetchVolunteers();
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
              title: const Text('Volunteers'),
              centerTitle: true,
              backgroundColor: const Color.fromARGB(57, 0, 0, 0),
              titleTextStyle: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            body: FutureBuilder(
              future: futureGetVolunteers,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No volunteers found.'));
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final event = snapshot.data![index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 8.0, right: 8.0),
                        child: Slidable(
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (context) {
                                  devtools.log('Slide action pressed');
                                },
                                backgroundColor:
                                    const Color.fromARGB(0, 206, 201, 201)
                                        .withOpacity(0.0),
                                foregroundColor:
                                    const Color.fromARGB(255, 93, 13, 13),
                                icon: Icons.delete,
                                label: 'Delete',
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 50, 48, 48)
                                  .withOpacity(0.4),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Name: ${event['volunteer_name']}",
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      "ID: ${event['volunteer_id']}",
                                      style: const TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.drive_file_rename_outline,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                  onPressed: () {
                                    devtools.log('Volunteer updated');
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final result = await showVolunteerDialog(
                    context, fetchVolunteers, response);
                if (result != null) {
                  setState(() {
                    futureGetVolunteers = fetchVolunteers();
                  });
                }
              },
              backgroundColor:
                  const Color.fromARGB(255, 84, 80, 80).withOpacity(1.0),
              child: const Icon(Icons.add),
            ),
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
          ),
        ],
      ),
    );
  }
}
