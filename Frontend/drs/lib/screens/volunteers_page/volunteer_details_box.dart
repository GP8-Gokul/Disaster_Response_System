import 'package:drs/services/api/root_api.dart';
import 'package:drs/widgets/custom_text.dart';
import 'package:drs/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';

dynamic response;
class VolunteerListTile extends StatefulWidget {
  final dynamic content;
  final VoidCallback onChange;
  const VolunteerListTile({
    super.key,
    required this.content,
    required this.onChange,
  });

  @override
  VolunteerListTileState createState() => VolunteerListTileState();
}

class VolunteerListTileState extends State<VolunteerListTile> {
  
  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color.fromARGB(255, 153, 153, 43), 
          width: 2.0
          ),
        borderRadius:  BorderRadius.circular(25.0),
      ),

      child: ListTile(
                  title: Text("Name: ${widget.content['volunteer_name']}"),
                  subtitle: Text("ID: ${widget.content['volunteer_id']}"),
                  tileColor: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.05),
                  contentPadding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 16.0),
                  textColor: const Color.fromARGB(255, 255, 255, 255),
                  titleTextStyle: const TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),
                  subtitleTextStyle: const TextStyle(fontSize: 14.0,fontWeight: FontWeight.w500),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),

                  onTap: () {
                    bool readonly = true;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        TextEditingController volunteerNameController = 
                          TextEditingController(text: widget.content['volunteer_name'].toString());
                        TextEditingController volunteerContactInfoController = 
                          TextEditingController(text: widget.content['volunteer_contact_info'].toString());
                        TextEditingController volunteerSkillsController = 
                          TextEditingController(text: widget.content['volunteer_skills'].toString());
                        TextEditingController volunteerAvailabilityStatusController = 
                          TextEditingController(text: widget.content['volunteer_availability_status'].toString());
                        TextEditingController eventIdController = 
                          TextEditingController(text: widget.content['event_id'].toString());

                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter setState) {
                            return AlertDialog(
                              title: const Text('Volunteer Details',style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255), 
                                  width: 3.0
                                  ),
                              ),

                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CustomText(text: 'Volunteer ID: ${widget.content['volunteer_id']}'),
                                  const SizedBox(height: 12),
                                  CustomTextField(
                                    hintText:'${widget.content['volunteer_name']}',
                                    labelText: 'Volunteer Name', 
                                    controller: volunteerNameController, 
                                    readOnly: readonly),
                                  CustomTextField(
                                    hintText: '${widget.content['volunteer_contact_info']}',
                                    labelText: 'Contact Info',
                                    controller: volunteerContactInfoController,
                                    readOnly: readonly,
                                  ),
                                  CustomTextField(
                                    hintText: '${widget.content['volunteer_skills']}',
                                    labelText: 'Skills',
                                    controller: volunteerSkillsController,
                                    readOnly: readonly,
                                  ),
                                  CustomTextField(
                                    hintText: '${widget.content['volunteer_availability_status']}',
                                    labelText: 'Availability Status',
                                    controller: volunteerAvailabilityStatusController,
                                    readOnly: readonly,
                                  ),
                                  CustomTextField(
                                    hintText: '${widget.content['event_id']}',
                                    labelText: 'Event ID',
                                    controller: eventIdController,
                                    readOnly: readonly,
                                  ),                            
                                ],
                              ),

                          actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                  ),
                                  child: const Icon(Icons.delete, color: Colors.red),
                                  
                                  onPressed: () async {
                                    response = await deleteData('volunteers','volunteer_id',widget.content['volunteer_id']);
                                    if (response != null && context.mounted) {
                                        widget.onChange();
                                        Navigator.pop(context);
                                    }
                                  },
                                ),

                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                  ),
                                  child: const Icon(Icons.edit, color: Colors.blue),

                                  onPressed: () {
                                    setState(() {
                                      readonly = !readonly;
                                    });
                                  }, 
                                ),

                                TextButton(
                                 style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                  ),
                                  child: const Icon(Icons.update, color: Colors.blue),
                                  onPressed: () async {
                                    response = await updateData(
                                      {
                                      'table': 'volunteers',
                                      'volunteer_id':widget.content['volunteer_id'],
                                      'volunteer_name': volunteerNameController.text,
                                      'volunteer_contact_info': volunteerContactInfoController.text,
                                      'volunteer_skills': volunteerSkillsController.text,
                                      'volunteer_availability_status': volunteerAvailabilityStatusController.text,
                                      'event_id': eventIdController.text,
                                      },
                                    );
                                    if (response != null && context.mounted) {
                                      widget.onChange();
                                      Navigator.pop(context);
                                    }
                                  }, 
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
    );
  }
}
