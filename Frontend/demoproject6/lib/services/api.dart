import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'https://127.0.0.1:5000/select';

  Future<List<dynamic>> getDisasterEvents() async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'table': 'disaster_events',
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load disaster events');
    }
  }

  Future<List<dynamic>> getResources() async {
    final url = Uri.parse(baseUrl);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'table': 'resources',
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load resources');
    }
  }
}
