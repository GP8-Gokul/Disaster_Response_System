import 'dart:convert';


List<Map<String, dynamic>> decodeTableSelect(String tableName, response){
  if(tableName == 'volunteers'){
    return decodeVolunteer(response);
  }
  else if(tableName == 'disaster_events'){
    return decodeDisasterEvents(response);
  }
  else if(tableName == 'aid_distribution'){
    return decodeAidDistribution(response);
  }
  else if(tableName == 'incident_reports'){
    return decodeIncidentReports(response);
  }
  else if(tableName == 'resources'){
    return decodeResources(response);
  }
  throw Exception('Unsupported table name: $tableName');
}


List<Map<String, dynamic>> decodeVolunteer(response){
  List<dynamic> data = jsonDecode(response.body);
      return data.map((content) => {
        'volunteer_id': content['volunteer_id'],
        'volunteer_name': content['volunteer_name'],
        'volunteer_contact_info': content['volunteer_contact_info'],
        'volunteer_skills': content['volunteer_skills'],
        'volunteer_availability_status': content['volunteer_availability_status'],
        'event_id': content['event_id'],
      }).toList();
}

List<Map<String, dynamic>> decodeDisasterEvents(response){
  List<dynamic> data = jsonDecode(response.body);
      return data.map((content) => {
        'event_id': content['event_id'],
        'event_name': content['event_name'],
        'event_type': content['event_type'],
        'location': content['location'],
        'start_date': content['start_date'],
        'end_date': content['end_date'],
        'description': content['description'],
      }).toList();
}

List<Map<String, dynamic>> decodeAidDistribution(response){
  List<dynamic> data = jsonDecode(response.body);
      return data.map((content) => {
        'distribution_id': content['distribution_id'],
        'event_id': content['event_id'],
        'resource_id': content['resource_id'],
        'volunteer_id': content['volunteer_id'],
        'quantity_distributed': content['quantity_distributed'],
        'distribution_date': content['distribution_date'],
        'location': content['location'],
      }).toList();
}

List<Map<String, dynamic>> decodeIncidentReports(response){
  List<dynamic> data = jsonDecode(response.body);
      return data.map((content) => {
        'incident_report_id': content['incident_report_id'].toString(),
        'incident_report_name': content['incident_report_name'].toString(),
        'incident_report_type': content['incident_report_type'].toString(),
        'location': content['location'].toString(),
        'start_date': content['start_date'].toString(),
        'end_date': content['end_date'].toString(),
        'description': content['description'].toString(),
      }).toList();
}

List<Map<String, dynamic>> decodeResources(response){
  List<dynamic> data = jsonDecode(response.body);
      return data.map((content) => {
        'resource_id': content['resource_id'].toString(),
        'resource_name': content['resource_name'].toString(),
        'resource_type': content['resource_type'].toString(),
        'location': content['location'].toString(),
        'start_date': content['start_date'].toString(),
        'end_date': content['end_date'].toString(),
        'description': content['description'].toString(),
      }).toList();
}


