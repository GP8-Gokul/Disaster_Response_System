import 'package:demoproject6/pages/select_page.dart';
import 'package:demoproject6/select/aid_distribution_page.dart';
import 'package:demoproject6/select/disaster_event_page.dart';
import 'package:demoproject6/select/incident_report_page.dart';
import 'package:demoproject6/select/record_by_id_page.dart';
import 'package:demoproject6/select/resources_page.dart';
import 'package:demoproject6/select/volunteers_page.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/selectpage': (context) => const SelectPage(),
        '/disaster_events': (context) => const DisasterEventsPage(),
        '/resources': (context) => const ResourcesPage(),
        '/volunteers': (context) => const VolunteersPage(),
        '/aid_distribution': (context) => const AidDistributionPage(),
        '/incident_reports': (context) => const IncidentReportPage(),
        '/record_by_id': (context) => const RecordByIDPage(),
      },
    );
  }
}
