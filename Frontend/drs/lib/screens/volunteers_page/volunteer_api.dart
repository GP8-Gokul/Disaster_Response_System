import 'dart:convert';
import 'package:drs/services/api/root_api.dart';
import 'dart:developer' as devtools show log;
import 'package:http/http.dart' as http;

Future addVolunteer(volunteerName, volunteerContactInfo, volunteerSkills,
    volunteerAvailabilityStatus, eventId) async {
  devtools.log('addVolunteer');
  final response = await http.post(
    Uri.parse('${url}insert'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'table': 'volunteers',
      'name': volunteerName,
      'contact_info': volunteerContactInfo,
      'skills': volunteerSkills,
      'availability_status': volunteerAvailabilityStatus,
      'event_id': eventId,
    }),
  );
  devtools.log(response.body);
  if (response.statusCode == 200) {
    devtools.log('Volunteer added');
    return response;
  } else {
    devtools.log('Failed to add volunteer');
  }
}
