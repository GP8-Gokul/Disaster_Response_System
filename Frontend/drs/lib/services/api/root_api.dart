import 'dart:convert';
import 'package:drs/services/api/json_decode.dart';
import 'package:http/http.dart' as http;

const url = 'http://10.0.2.2:5000/';

Future<List<Map<String, dynamic>>> fetchdata(tableName) async {
  final response = await http.post(
    Uri.parse('${url}select'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'table': tableName}),
  );

  if (response.statusCode == 200) {
    return decodeTableSelect(tableName, response);
  } else {
    throw Exception('Failed to load data');
  }
}