import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;

const url = 'http://10.0.2.2:5000/';

Future<List<Map<String, dynamic>>> fetchDisasterEvents() async {
  final response = await http.post(
    Uri.parse('${url}select'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'table': 'disaster_events'}),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data
        .map((event) => {
              'event_id': event['event_id'],
              'event_name': event['event_name'],
              'event_type': event['event_type'],
              'location': event['location'],
              'start_date': event['start_date'],
              'end_date': event['end_date'],
              'description': event['description'],
            })
        .toList();
  } else {
    throw Exception('Failed to load disaster events');
  }
}

Future addDisasterEvents(disasterName, disasterType, disasterLocation,
    disasterStartDate, disasterEndDate, disasterDescription) async {
  devtools.log('addDisasterEvents');
  final response = await http.post(
    Uri.parse('${url}insert'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'table': 'disaster_events',
      'event_name': disasterName,
      'event_type': disasterType,
      'location': disasterLocation,
      'start_date': disasterStartDate,
      'end_date': disasterEndDate,
      'description': disasterDescription,
    }),
  );
  devtools.log(response.body);
  if (response.statusCode == 200) {
    devtools.log('Event added');
    return response;
  } else {
    devtools.log('Failed to add event');
  }
}

Future deleteDisasterEvent(eventId) async {
  final response = await http.post(
    Uri.parse('${url}delete'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'table': 'disaster_events',
      'event_id': eventId,
    }),
  );

  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to delete disaster event');
  }
}
