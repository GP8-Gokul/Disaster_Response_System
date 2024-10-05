import 'package:drs/screens/Incident_reports_page/incident_report_list_tile.dart';
import 'package:drs/services/api/root_api.dart';
import 'package:drs/services/api/unused_disaster_event_api.dart';
import 'package:drs/services/authorization/check_access.dart';
import 'package:drs/widgets/background_image.dart';
import 'package:drs/widgets/custom_appbar.dart';
import 'package:drs/widgets/custom_text.dart';
import 'package:drs/widgets/custom_text_field.dart';
import 'package:drs/widgets/search_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

bool changeInState = false;
var events = {};

void getEventIds() {
  late Future<List<Map<String, dynamic>>> futureGetDisasterEvents;
  futureGetDisasterEvents = fetchDisasterEvents();
  futureGetDisasterEvents.then((value) {
    for (var event in value) {
      events[event['event_id']] = event['event_name'];
    }
  });
}

class IncidentReportsScreen extends StatefulWidget {
  const IncidentReportsScreen({super.key});
  static String routeName = 'incident_reports';

  @override
  State<IncidentReportsScreen> createState() => _IncidentReportsScreenState();
}

class _IncidentReportsScreenState extends State<IncidentReportsScreen> {
  late Future<List<Map<String, dynamic>>> futureGetIncidentReports;
  dynamic response;

  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allData = [];
  List<Map<String, dynamic>> filteredData = [];

  @override
  void initState() {
    super.initState();
    futureGetIncidentReports = fetchdata('incident_reports');
    futureGetIncidentReports.then((reports) {
      setState(() {
        allData = reports;
        filteredData = reports;
      });
    });
    searchController.addListener(_filterData);
  }

  void _filterData() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredData = allData.where((element) {
        final reportName = element['report_name'].toString().toLowerCase();
        return reportName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          const BackgroundImage(imageName: 'page_background',),
          Scaffold(
            appBar: const CustomAppbar(text: 'Report Details'),
            body: bodyColumn(),
            floatingActionButton: buildFloatingActionButton(),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  Column bodyColumn() {
    return Column(
      children: [
        SearchTextField(
            labelText: 'Search Reports',
            hintText: 'Enter Report Name',
            searchController: searchController
            ),
        Expanded(
          child: filteredData.isEmpty
              ? const Center(child: Text('No Reports found.'))
              : buildFutureBuilder(),
        ),
        SizedBox(
          height: 70,
        )
      ],
    );
  }

  FutureBuilder buildFutureBuilder() {
    return FutureBuilder(
      future: futureGetIncidentReports,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No Reports found.'));
        } else {
          return buildListview(snapshot);
        }
      },
    );
  }

  Widget buildListview(snapshot) {
    return ListView.builder(
      itemCount: filteredData.length,
      itemBuilder: (context, index) {
        final content = filteredData[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Slidable(
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    if (checkAcess(
                        'incident_reports', content['report_name'])) {
                      response = await deleteData('incident_reports',
                          'report_id', content['report_id'].toString());
                      if (response != null) {
                        setState(() {
                          futureGetIncidentReports =
                              fetchdata('incident_reports');
                          futureGetIncidentReports.then((reports) {
                            setState(() {
                              allData = reports;
                              filteredData = reports;
                            });
                          });
                          searchController.addListener(_filterData);
                        });
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Access Denied',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  width: 3.0),
                            ),
                            content: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomText(
                                    text:
                                        'You do not have access to delete this data'),
                                const SizedBox(height: 12),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                child: const Text('OK',
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                  backgroundColor: const Color.fromARGB(138, 236, 70, 70),
                  icon: Icons.delete,
                  foregroundColor: const Color.fromARGB(255, 238, 230, 230),
                ),
              ],
            ),
            child: IncidentReportListTile(
              content: content,
              onChange: () {
                setState(() {
                  futureGetIncidentReports = fetchdata('incident_reports');
                  futureGetIncidentReports.then((reports) {
                    setState(() {
                      allData = reports;
                      filteredData = reports;
                    });
                  });
                  searchController.addListener(_filterData);
                });
              },
            ),
          ),
        );
      },
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.white.withOpacity(0.7),
      child: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController incidentReportNameController =
                TextEditingController();
            TextEditingController incidentReportDateController =
                TextEditingController();
            TextEditingController incidentReportDescriptionController =
                TextEditingController();
            TextEditingController incidentReportedByController =
                TextEditingController();
            getEventIds();
            String? selectedReportId;

            return AlertDialog(
              title: const Text('Add New Report'),
              titleTextStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
              backgroundColor: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(color: Colors.white, width: 2.0),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(
                      hintText: 'Report Name',
                      labelText: 'Report Name',
                      controller: incidentReportNameController,
                      readOnly: false),
                  CustomTextField(
                      hintText: 'Report Date',
                      labelText: 'Report Date',
                      controller: incidentReportDateController,
                      readOnly: false),
                  CustomTextField(
                      hintText: 'Reported By',
                      labelText: 'Reported By',
                      controller: incidentReportedByController,
                      readOnly: false),
                  CustomTextField(
                      hintText: 'Description',
                      labelText: 'Description',
                      controller: incidentReportDescriptionController,
                      readOnly: false),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Report Name',
                      labelStyle: const TextStyle(color: Colors.white),
                      enabled: true,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.lime),
                      ),
                    ),
                    value: selectedReportId,
                    style: const TextStyle(color: Colors.white),
                    dropdownColor: Colors.black,
                    items: events.keys.map((key) {
                      return DropdownMenuItem<String>(
                        value: key.toString(),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                          child: Text(events[key]!),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      selectedReportId = newValue;
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Cancel',
                      style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Submit',
                      style: TextStyle(color: Colors.black)),
                  onPressed: () async {
                    if (checkAcess('incident_reports', '')) {
                      response = await insertData({
                        'table': 'incident_reports',
                        'report_name': incidentReportNameController.text,
                        'report_date': incidentReportDateController.text,
                        'reported_by': incidentReportedByController.text,
                        'description': incidentReportDescriptionController.text,
                        'report_id': selectedReportId,
                      });
                      if (response != null) {
                        setState(() {
                          futureGetIncidentReports =
                              fetchdata('incident_reports');
                          futureGetIncidentReports.then((reports) {
                            setState(() {
                              allData = reports;
                              filteredData = reports;
                            });
                          });
                          searchController.addListener(_filterData);
                        });
                      }
                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } else {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Access Denied'),
                            titleTextStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                            backgroundColor: Colors.grey[900],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(
                                  color: Colors.white, width: 2.0),
                            ),
                            content: const CustomText(
                                text:
                                    'You do not have access to add new reports.'),
                            actions: <Widget>[
                              TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.white,
                                ),
                                child: const Text('OK',
                                    style: TextStyle(color: Colors.black)),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}
