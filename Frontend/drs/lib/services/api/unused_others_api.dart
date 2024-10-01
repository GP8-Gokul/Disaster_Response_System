

import 'package:drs/services/api/root_api.dart';
import 'package:http/http.dart' as http;

Future<String> fetchEventNameId() async {
  final response = await http.get(
    Uri.parse('${url}others'),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to load data');
  }
}
