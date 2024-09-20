import 'package:flutter/material.dart';
import 'package:demoproject6/services/api_service/api_select.dart';

class IncidentReportPage extends StatefulWidget {
  const IncidentReportPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IncidentReportPageState createState() => _IncidentReportPageState();
}

class _IncidentReportPageState extends State<IncidentReportPage> {
  // ignore: non_constant_identifier_names
  late Future<List<dynamic>> incident_report;

  @override
  void initState() {
    super.initState();
    incident_report = ApiService().getIncidentReports();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Volunteers'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: incident_report,
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
                var incidents = snapshot.data![index];
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Report ID: ${incidents['report_id']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Event ID: ${incidents['event_id']}',
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
