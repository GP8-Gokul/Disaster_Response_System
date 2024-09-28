import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:drs/services/api/root_api.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;

dynamic userRole;
dynamic userName;

Future loginUser(String username, String password) async {
  devtools.log('loginUser');
  final response = await http.post(
    Uri.parse('${url}login'),
    body: jsonEncode({'username': username, 'password': password}),
    headers: {'Content-Type': 'application/json'},
  );

  devtools.log(response.body);

  if (response.statusCode == 200) {
    devtools.log('Login successful');
    String jwt = response.body;
    userName = username;
    userRole = retrieveRole(jwt);
    devtools.log('User role: $userRole');
    devtools.log('User name: $userName');
  } else {
    devtools.log('Login failed');
  }

  return response;
}

dynamic retrieveRole(String jwt) {
  devtools.log('retrieveRole');
  try {
    final jwtDecoded = JWT.decode(jwt);
    devtools.log('Decoded JWT payload: ${jwtDecoded.payload}');
    return jwtDecoded.payload['sub'] ?? 'Unknown role';
  } catch (e) {
    devtools.log('Error decoding JWT: $e');
    return 'Error decoding token';
  }
}

