import 'dart:convert';
import 'package:drs/services/api/json_decode.dart';
import 'package:drs/services/api/json_encode.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools;

const url = 'https://localhost:5000';
dynamic userRole;
dynamic userName;
dynamic authenticationToken;

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

Future deleteData(tableName, columnName, value) async {
  final response = await http.post(
    Uri.parse('${url}delete'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authenticationToken',
    },
    body: jsonEncode({
      'table': tableName,
      'column': columnName,
      'value': value,
    }),
  );

  if (response.statusCode == 200) {
    devtools.log('Data deleted');
    return response;
  } else {
    devtools.log('Failed to delete data');
  }
}

Future updateData(data) async {
  final response = await http.post(
    Uri.parse('${url}update'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authenticationToken',
    },
    body: dataEncode(data),
  );
  if (response.statusCode == 200) {
    devtools.log('Data updated');
    devtools.log(response.body);
    return response;
  } else {
    devtools.log(response.body);
    devtools.log('Failed to update data');
  }
}

Future insertData(data) async {
  final response = await http.post(
    Uri.parse('${url}insert'),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authenticationToken',
    },
    body: dataEncode(data),
  );
  if (response.statusCode == 200) {
    devtools.log('Data inserted');
    devtools.log(response.body);
    return response;
  } else {
    devtools.log('Failed to insert data');
  }
}
