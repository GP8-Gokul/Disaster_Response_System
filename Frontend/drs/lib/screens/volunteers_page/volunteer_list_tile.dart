import 'package:flutter/material.dart';

class VolunteerListTile extends StatelessWidget {
  final dynamic event;
  const VolunteerListTile({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.yellowAccent, width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: ListTile(
                  title: Text("Name: ${event['volunteer_name']}"),
                  subtitle: Text("ID: ${event['volunteer_id']}"),
                  tileColor: Colors.grey.withOpacity(0.1),
                  contentPadding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
                  textColor: const Color.fromARGB(255, 0, 0, 0),
                  titleTextStyle: const TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                  subtitleTextStyle: const TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                  onTap: () {
                  },
                ),
    );
  }
}
