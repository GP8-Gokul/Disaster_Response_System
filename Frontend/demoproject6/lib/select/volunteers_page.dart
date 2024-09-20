import 'package:flutter/material.dart';
import 'package:demoproject6/services/api_service/api_select.dart';

class VolunteersPage extends StatefulWidget {
  const VolunteersPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _VolunteersPageState createState() => _VolunteersPageState();
}

class _VolunteersPageState extends State<VolunteersPage> {
  late Future<List<dynamic>> volunteer;

  @override
  void initState() {
    super.initState();
    volunteer = ApiService().getVolunteers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteers'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: volunteer,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var volunteers = snapshot.data![index];
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Volunteer ID: ${volunteers['volunteer_id']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Volunteer Name: ${volunteers['volunteer_name']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
