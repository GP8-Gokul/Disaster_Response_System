import 'package:drs/screens/incident_reports_page/insert_incident_reports.dart';
import 'package:drs/screens/incident_reports_page/update_incident_reports.dart';
import 'package:drs/services/api/root_api.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:drs/services/hero_dialog_route.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class IncidentReportsScreen extends StatefulWidget {
  const IncidentReportsScreen({super.key});
  static String routeName = 'incident-reports';

  @override
  State<IncidentReportsScreen> createState() => _IncidentReportsScreenState();
}

class _IncidentReportsScreenState extends State<IncidentReportsScreen> {
  late Future<List<Map<String, dynamic>>> futureGetIncidentReports;
  dynamic response;
  List<Map<String, dynamic>> allReports = [];
  List<Map<String, dynamic>> filteredReports = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureGetIncidentReports = fetchdata('incident_reports');
    futureGetIncidentReports.then((reports) {
      setState(() {
        allReports = reports;
        filteredReports = reports;
      });
    });
    searchController.addListener(_filterReports);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterReports() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredReports = allReports
          .where((report) => report['report_name'].toLowerCase().contains(query))
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
              'assets/images/background.jpg', // background image
              fit: BoxFit.cover,
            ),
          ),
          Scaffold(
            appBar: AppBar(
              title: const Text('Incident Reports'),
              centerTitle: true,
              backgroundColor: const Color.fromARGB(244, 250, 174, 68),
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
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Search Reports',
                      hintText: 'Enter report name',
                      hintStyle: const TextStyle(color: Colors.white),
                      labelStyle: const TextStyle(color: Colors.white),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 85.0),
                    child: filteredReports.isEmpty
                        ? const Center(
                            child: Text(
                              'No reports found.',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Color.fromARGB(255, 222, 211, 211),
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredReports.length,
                            itemBuilder: (context, index) {
                              final report = filteredReports[index];
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
                                          final result = await deleteIncidentReport(
                                              report['report_id']);
                                          if (result != 0) {
                                            setState(() {
                                              allReports.remove(report);
                                              filteredReports.remove(report);
                                            });
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'Failed to delete report'),
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
                                    onTap: () {
                                      devtools.log('Report tapped');
                                      Navigator.of(context).push(
                                        HeroDialogRoute(
                                          builder: (context) =>
                                              UpdateIncidentReportsDialog(
                                            fetchIncidentReports:
                                                fetchIncidentReports,
                                            report: report,
                                            response: response,
                                          ),
                                        ),
                                      );
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
                                                  "Report Name: ${report['report_name']}",
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
                                                  "Report ID: ${report['report_id']}",
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
                final result = await insertIncidentReportsDialog(
                    context, fetchIncidentReports, response);
                if (result != 0) {
                  setState(() {
                    futureGetIncidentReports = fetchIncidentReports();
                    futureGetIncidentReports.then((reports) {
                      setState(() {
                        allReports = reports;
                        filteredReports = reports;
                      });
                    });
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all the fields'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  Navigator.of(context).pop();
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

