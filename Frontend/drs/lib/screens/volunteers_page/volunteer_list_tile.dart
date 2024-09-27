import 'package:drs/services/api/root_api.dart';
import 'package:drs/widgets/custom_text.dart';
import 'package:flutter/material.dart';

dynamic response;
class VolunteerListTile extends StatelessWidget {
  final dynamic content;
  const VolunteerListTile({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 153, 153, 43), width: 2.0),
        borderRadius: BorderRadius.circular(25.0),
      ),
      child: ListTile(
                  title: Text("Name: ${content['volunteer_name']}"),
                  subtitle: Text("ID: ${content['volunteer_id']}"),
                  tileColor: const Color.fromARGB(255, 204, 194, 194).withOpacity(0.2),
                  contentPadding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
                  textColor: const Color.fromARGB(255, 0, 0, 0),
                  titleTextStyle: const TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                  subtitleTextStyle: const TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Volunteer Details',style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold)),
                          backgroundColor: Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: const BorderSide(color: Colors.black, width: 3.0),
                          ),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomText(text: 'Volunteer ID: ${content['volunteer_id']}'),
                              const SizedBox(height: 12),
                              CustomText(text: 'Volunteer Name: ${content['volunteer_name']}'),
                              const SizedBox(height: 12),
                              CustomText(text: 'Contact : ${content['volunteer_contact_info']}'),
                              const SizedBox(height: 12),
                              CustomText(text: 'Skills: ${content['volunteer_skills']}'),
                              const SizedBox(height: 12),
                              CustomText(text: 'Availability : ${content['volunteer_availability_status']}'),
                              const SizedBox(height: 12),
                              CustomText(text: 'Event ID : ${content['event_id']}'),
                            ],
                          ),
                      actions: <Widget>[
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                                child: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                response = await deleteData('volunteers','volunteer_id',content['volunteer_id']);
                                if (response != null && context.mounted) {
                                    Navigator.pop(context,true);
                                }
                              },
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                                child: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () async {
                                
                              }, 
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
    );
  }
}
