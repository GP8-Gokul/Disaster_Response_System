import 'package:drs/screens/aid_distribution_page/display_aid_distribution.dart';
import 'package:drs/screens/aid_distribution_page/insert_aid_distribution.dart';
import 'package:drs/screens/aid_distribution_page/update_aid_distribution.dart';
import 'package:drs/services/api/aid_distribution_api.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:drs/screens/hero_dialog_route.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AidDistributionScreen extends StatefulWidget {
  const AidDistributionScreen({super.key});
  static String routeName = 'aid-distribution';

  @override
  State<AidDistributionScreen> createState() => _AidDistributionScreenState();
}

class _AidDistributionScreenState extends State<AidDistributionScreen> {
  late Future<List<Map<String, dynamic>>> futureGetAidDistribution;
  dynamic response;
  List<Map<String, dynamic>> allAids = [];

  @override
  void initState() {
    super.initState();
    futureGetAidDistribution = fetchAidDistribution();
    futureGetAidDistribution.then((aids) {
      setState(() {
        allAids = aids;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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
              title: const Text('Aid Distribution'),
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
                Expanded(
                  child: ListView.builder(
                    itemCount: allAids.length,
                    itemBuilder: (context, index) {
                      final rsc = allAids[index];
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
                                  deleteAidDistribution(rsc['distribution_id']);
                                  setState(() {
                                    allAids.remove(rsc);
                                  });
                                },
                                backgroundColor:
                                    const Color.fromARGB(148, 226, 125, 125),
                                icon: Icons.delete,
                                foregroundColor:
                                    const Color.fromARGB(255, 74, 71, 71),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              devtools.log('Event for aid tapped');
                              Navigator.of(context).push(
                                HeroDialogRoute(
                                  builder: (context) => DisplayAidDistribution(
                                    rsc: rsc,
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 70, 70, 70)
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
                                          "Distribution ID: ${rsc['distribution_id']}",
                                          style: const TextStyle(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Color.fromARGB(255, 41, 39, 39),
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
                                          await updateAidDistributionDialog(
                                              context,
                                              fetchAidDistribution,
                                              rsc,
                                              response);
                                      if (result != null) {
                                        setState(() {
                                          futureGetAidDistribution =
                                              fetchAidDistribution();
                                          futureGetAidDistribution
                                              .then((events) {
                                            setState(() {
                                              allAids = events;
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
                final result = await insertAidDistributionDialog(
                    context, fetchAidDistribution, response);
                if (result != null) {
                  setState(() {
                    futureGetAidDistribution = fetchAidDistribution();
                    futureGetAidDistribution.then((aids) {
                      setState(() {
                        allAids = aids;
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
