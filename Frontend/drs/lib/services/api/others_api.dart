import 'dart:convert';

import 'package:drs/services/api/root_api.dart';
import 'package:http/http.dart' as http;

Future<List<Map<String, dynamic>>> fetchEventNameId() async {
  final response = await http.get(
    Uri.parse('${url}select'),
    headers: {'Content-Type': 'application/json'},
  
  );
  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
      return data.map((content) => {
        'event_id': content['event_id'],
        'event_name': content['event_name'],
      }).toList();
  } else {
    throw Exception('Failed to load data');
  }
}