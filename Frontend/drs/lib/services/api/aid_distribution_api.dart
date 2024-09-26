import 'dart:convert';
import 'package:drs/services/api/root_api.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as devtools show log;

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
  final response = await http.post(
    Uri.parse('${url}insert'),
    headers: {'Content-Type': 'application/json'},
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
}

Future deleteAidDistribution(distributionId) async {
  final response = await http.post(
    Uri.parse('${url}delete'),
    headers: {'Content-Type': 'application/json'},
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
}

Future updateAidDistribution(
    distributionId,
    aidEventId,
    aidResourceId,
    aidVolunteerId,
    aidQuantity,
    aidDistributionDate,
    aidLocation) async {
  devtools.log('updateAidDistribution');
  final response = await http.post(
    Uri.parse('${url}update'),
    headers: {'Content-Type': 'application/json'},
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
}