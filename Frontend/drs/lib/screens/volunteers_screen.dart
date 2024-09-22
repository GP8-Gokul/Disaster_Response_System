import 'package:drs/services/api/volunteers/volunteer_api.dart';
import 'package:drs/services/inserting/insert_volunteer.dart';
import 'package:flutter/material.dart';

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
    return Stack(
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
            backgroundColor: Colors.transparent,
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
                    return Container(
                      margin: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text("Name: ${event['volunteer_name']}"),
                        subtitle: Text("ID: ${event['volunteer_id']}"),
                        tileColor: Colors.white.withOpacity(0.3),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.grey),
                          onPressed: () {
                            //not implemented
                          },
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        textColor: Colors.black,
                        titleTextStyle: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                        subtitleTextStyle: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(
                              color: Colors.black.withOpacity(0.0), width: 1.0),
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final result =
                  await showVolunteerDialog(context, fetchVolunteers, response);
              if (result != null) {
                setState(() {
                  futureGetVolunteers = fetchVolunteers();
                });
              }
            },
            backgroundColor: Colors.white.withOpacity(0.5),
            child: const Icon(Icons.add),
          ),
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }
}
