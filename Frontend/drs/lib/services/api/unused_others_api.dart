import 'dart:convert';
import 'package:drs/services/api/root_api.dart';
import 'package:http/http.dart' as http;

Future<Map<dynamic,dynamic>> fetchEventNameId() async {
  final response = await http.get(
    Uri.parse('${url}others'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load data');
  }
}
