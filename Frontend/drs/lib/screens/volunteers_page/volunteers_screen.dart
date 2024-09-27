import 'package:drs/services/api/root_api.dart';
import 'package:drs/screens/volunteers_page/volunteer_api.dart';
import 'package:drs/widgets/background_image.dart';
import 'package:drs/widgets/custom_appbar.dart';
import 'package:drs/screens/volunteers_page/volunteer_list_tile.dart';
import 'package:drs/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';


bool changeInState = false;
class VolunteersScreen extends StatefulWidget {
  const VolunteersScreen({super.key});
  static String routeName = 'volunteers';

  @override
  State<VolunteersScreen> createState() => _VolunteersScreenState();
}

class _VolunteersScreenState extends State<VolunteersScreen> {
  late Future<List<Map<String, dynamic>>> futureGetVolunteers;
  dynamic response;
  
  @override
  void initState() {
    super.initState();
    futureGetVolunteers = fetchdata('volunteers');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          const BackgroundImage(),
          Scaffold(
            appBar: const CustomAppbar(text: 'Volunteers'),
            body: buildFutureBuilder(),
            floatingActionButton: buildFloatingActionButton(),
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }


  FutureBuilder buildFutureBuilder(){
    return FutureBuilder(
      future: futureGetVolunteers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No volunteers found.'));
        } else {
          return buildListview(snapshot); 
        }
      },
    );
  }

  Widget buildListview(snapshot){
    return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final content = snapshot.data![index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  changeInState = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return VolunteerListTile(content: content);
                    },
                  ) ?? false; // Ensure changeInState is not null
                  if (changeInState) {
                    setState(() {
                      futureGetVolunteers = fetchdata('volunteers');
                    });
                  }
                },
                child: VolunteerListTile(content: content),
              ),
            );
  },
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: Colors.green.withOpacity(0.7),
      child: const Icon(Icons.add),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController volunteerNameController = TextEditingController();
            TextEditingController volunteerContactInfoController = TextEditingController();
            TextEditingController volunteerSkillsController = TextEditingController();
            TextEditingController volunteerAvailabilityStatusController = TextEditingController();
            TextEditingController eventIdController = TextEditingController();

            return AlertDialog(
              title: const Text('Add New Volunteer'),
              titleTextStyle: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              backgroundColor: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: const BorderSide(color: Colors.white, width: 2.0),
                ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomTextField(labelText: 'Volunteer Name', controller: volunteerNameController, readOnly: false),
                  CustomTextField(labelText: 'Contact Info', controller: volunteerContactInfoController, readOnly: false),
                  CustomTextField(labelText: 'Skills', controller: volunteerSkillsController, readOnly: false),
                  CustomTextField(labelText: 'Availability Status', controller: volunteerAvailabilityStatusController, readOnly: false),
                  CustomTextField(labelText: 'Event ID', controller: eventIdController, readOnly: false),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  child: const Text('Submit', style: TextStyle(color: Colors.black)),
                  onPressed: () async {
                    response = await addVolunteer(
                      volunteerNameController.text,
                      volunteerContactInfoController.text,
                      volunteerSkillsController.text,
                      volunteerAvailabilityStatusController.text,
                      eventIdController.text,
                    );
                    if (response != null) {
                      setState(() {
                        futureGetVolunteers = fetchdata('volunteers');
                      });
                    }
                    if (context.mounted) {
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
  }
}