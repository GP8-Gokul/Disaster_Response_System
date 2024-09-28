import 'dart:convert';
import 'package:drs/services/api/json_decode.dart';
import 'package:drs/services/api/json_encode.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools;

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

Future deleteData(tableName,columnName,value) async {
  final response = await http.post(
    Uri.parse('${url}delete'),
    headers: {
      'Content-Type': 'application/json',
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

Future updateData(data) async{
  final response = await http.post(
    Uri.parse('${url}update'),
    headers: {
      'Content-Type': 'application/json',
    },
    body: dataEncode(data),
  );
  if(response.statusCode == 200){
    devtools.log('Data updated');
    return response;
  } else {
    devtools.log('Failed to update data');
  }
}