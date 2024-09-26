import 'dart:convert';
import 'package:drs/services/api/root_api.dart';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:developer' as devtools show log;

final _box = Hive.box('DBMSBox');

Future<List<Map<String, dynamic>>> fetchAidDistribution() async {
  final response = await http.post(
    Uri.parse('${url}select'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'table': 'aid_distribution'}),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = jsonDecode(response.body);
    return data
        .map((rsc) => {
              'distribution_id': rsc['distribution_id'],
              'event_id': rsc['event_id'],
              'resource_id': rsc['resource_id'],
              'volunteer_id': rsc['volunteer_id'],
              'quantity_distributed': rsc['quantity_distributed'],
              'distribution_date': rsc['distribution_date'],
              'location': rsc['location'],
            })
        .toList();
  } else {
    throw Exception('Failed to load aid distribution');
  }
}

Future addAidDistribution(aidEventId, aidResourceId, aidVolunteerId,
    aidQuantity, aidDistributionDate, aidLocation) async {
  devtools.log('addAidDistribution');
  if (_box.get('role') == 'admin') {
    final response = await http.post(
      Uri.parse('${url}insert'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_box.get('token')}'
      },
      body: jsonEncode({
        'table': 'aid_distribution',
        'event_id': aidEventId,
        'resource_id': aidResourceId,
        'volunteer_id': aidVolunteerId,
        'quantity_distributed': aidQuantity,
        'distribution_date': aidDistributionDate,
        'location': aidLocation,
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
    throw Exception('You are not authorized to add aid distribution');
  }
}

Future deleteAidDistribution(distributionId) async {
  if (_box.get('role') == 'admin') {
    devtools.log('deleteAidDistribution');
    final response = await http.post(
      Uri.parse('${url}delete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_box.get('token')}'
      },
      body: jsonEncode({
        'table': 'aid_distribution',
        'column': 'distribution_id',
        'value': distributionId,
      }),
    );

    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to delete aid distribution');
    }
  } else {
    throw Exception('You are not authorized to delete aid distribution');
  }
}

Future updateAidDistribution(distributionId, aidEventId, aidResourceId,
    aidVolunteerId, aidQuantity, aidDistributionDate, aidLocation) async {
  devtools.log('updateAidDistribution');
  devtools.log(_box.get('token'));
  if (_box.get('role' == 'admin')) {
    final response = await http.post(
      Uri.parse('${url}update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${_box.get('token')}'
      },
      body: jsonEncode({
        'table': 'aid_distribution',
        'distribution_id': distributionId,
        'event_id': aidEventId,
        'resource_id': aidResourceId,
        'volunteer_id': aidVolunteerId,
        'quantity_distributed': aidQuantity,
        'distribution_date': aidDistributionDate,
        'location': aidLocation,
      }),
    );
    devtools.log(response.body);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to update aid distribution');
    }
  } else {
    throw Exception('You are not authorized to update aid distribution');
  }
}
