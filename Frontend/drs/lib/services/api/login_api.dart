import 'dart:convert';
import 'package:drs/services/api/root_api.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;

Future loginUser(username, password) async {
  devtools.log('loginUser');
  final response = await http.post(
    Uri.parse('${url}login'),
    body: jsonEncode({'username': username, 'password': password}),
    headers: {'Content-Type': 'application/json'},
  );
  devtools.log(response.body);
  if (response.statusCode == 200) {
    devtools.log('Login successful');
  } else {
    devtools.log('Login failed');
  }
  return response;
}
