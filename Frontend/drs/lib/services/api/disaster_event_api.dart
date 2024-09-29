import 'dart:convert';
import 'package:drs/services/api/root_api.dart';
import 'package:http/http.dart' as http;
import 'package:drs/services/AuthoriztionDemo/check_access.dart';
import 'dart:developer' as devtools show log;

Future<List<Map<String, dynamic>>> fetchDisasterEvents() async {
  final response = await http.post(
    Uri.parse('${url}select'),
    headers: {
      'Content-Type': 'application/json',
    },
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
  if (checkAcess('disaster_events', userName)) {
    final response = await http.post(
      Uri.parse('${url}insert'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': "Bearer $authenticationToken",
      },
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
  } else {
    devtools.log('You are not authorized to add disaster event');
    return 0;
  }
}

Future deleteDisasterEvent(eventId) async {
  if (checkAcess('disaster_events', userName)) {
    final response = await http.post(
      Uri.parse('${url}delete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authenticationToken',
      },
      body: jsonEncode({
        'table': 'disaster_events',
        'column': 'event_id',
        'value': eventId,
      }),
    );

    if (response.statusCode == 200) {
      devtools.log('Disaster event deleted');
      return response;
    } else {
      devtools.log('Failed to delete disaster event');
    }
  } else {
    devtools.log('You are not authorized to delete disaster event');
    return 0;
  }
}

Future updateDisasterEvents(
    eventId,
    disasterName,
    disasterType,
    disasterLocation,
    disasterStartDate,
    disasterEndDate,
    disasterDescription) async {
  if (checkAcess('disaster_events', userName)) {
    final response = await http.post(
      Uri.parse('${url}update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authenticationToken',
      },
      body: jsonEncode({
        'table': 'disaster_events',
        'event_id': eventId,
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
      devtools.log('Event updated');
      return response;
    } else {
      devtools.log('Failed to update event');
    }
  } else {
    devtools.log('You are not authorized to update disaster event');
    return 0;
  }
}
