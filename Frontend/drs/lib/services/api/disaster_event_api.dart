import 'dart:convert';
import 'package:http/http.dart' as http;

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
