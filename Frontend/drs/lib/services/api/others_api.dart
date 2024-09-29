import 'dart:convert';

import 'package:drs/services/api/root_api.dart';
import 'package:http/http.dart' as http;

Future<Map<String, String>> fetchEventNameId() async {
  final response = await http.get(
    Uri.parse('${url}others'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    return Map<String, String>.from(data);
  } else {
    throw Exception('Failed to load data');
  }
}
