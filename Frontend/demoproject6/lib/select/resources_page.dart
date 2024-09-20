import 'package:flutter/material.dart';
import 'package:demoproject6/services/api.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ResourcesPageState createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage> {
  late Future<List<dynamic>> resources;

  @override
  void initState() {
    super.initState();
    resources = ApiService().getResources();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: resources,
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
                var resource = snapshot.data![index];
                return ListTile(
                  title: Text(resource['resource_name']),
                  subtitle: Text('Type: ${resource['resource_type']}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}
