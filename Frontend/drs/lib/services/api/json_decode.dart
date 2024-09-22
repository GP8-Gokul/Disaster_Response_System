import 'dart:convert';

List<Map<String, dynamic>> insertVolunteers(response){
  List<dynamic> data = jsonDecode(response.body);
      return data.map((event) => {
        'volunteer_id': event['volunteer_id'].toString(),
        'volunteer_name': event['volunteer_name'].toString(),
        'volunteer_contact_info': event['volunteer_contact_info'].toString(),
        'volunteer_skills': event['volunteer_skills'].toString(),
        'volunteer_availability_status': event['volunteer_availability_status'].toString(),
        'event_id': event['event_id'].toString(),
      }).toList();
}
