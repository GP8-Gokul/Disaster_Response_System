
import 'dart:convert';
import 'package:drs/services/api/json_decode.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const url = 'http://10.0.2.2:5000/';

Future<List<Map<String, dynamic>>> fetchVolunteers() async {
    final response = await http.post(
      Uri.parse('${url}select'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'table': 'volunteers'}),
    );

    if (response.statusCode == 200) {
      return insertVolunteers(response);
    } else {
      throw Exception('Failed to load volunteers');
    }
}

Future addVolunteer(volunteerName, volunteerContactInfo, volunteerSkills, volunteerAvailabilityStatus, eventId) async {
     final response = await http.post(
      Uri.parse('${url}insert'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'table': 'volunteers',
        'volunteer_name': volunteerName,
        'volunteer_contact_info': volunteerContactInfo,
        'volunteer_skills': volunteerSkills,
        'volunteer_availability_status': volunteerAvailabilityStatus,
        'event_id': eventId,
      }),
     );

        return response;
        
      
}
    

