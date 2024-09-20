import 'package:flutter/material.dart';
import 'package:demoproject6/services/api_service/api_select.dart';

class AidDistributionPage extends StatefulWidget {
  const AidDistributionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AidDistributionPageState createState() => _AidDistributionPageState();
}

class _AidDistributionPageState extends State<AidDistributionPage> {
  // ignore: non_constant_identifier_names
  late Future<List<dynamic>> aid_distribution;

  @override
  void initState() {
    super.initState();
    aid_distribution = ApiService().getAidDistribution();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aid Distribution'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: aid_distribution,
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
                var aid = snapshot.data![index];
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Aid ID: ${aid['distribution_id']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Event ID: ${aid['event_id']}',
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          'Resource ID: ${aid['resource_id']}',
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
