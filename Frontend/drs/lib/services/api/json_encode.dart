import 'dart:convert';

String dataEncode(data){
  if(data['table'] == 'volunteers'){
    return encodeVolunteer(data);
  }
  else if(data['table'] == 'disaster_events'){
    return encodeDisasterEvents(data);
  }
  else if(data['table'] == 'aid_distribution'){
    return encodeAidDistribution(data);
  }
  else if(data['table'] == 'incident_reports'){
    return encodeIncidentReports(data);
  }
  else if(data['table'] == 'resources'){
    return encodeResources(data);
  }
  throw Exception('Unsupported table name: ${data['table']}');
}

String encodeVolunteer(data){
  return jsonEncode(data);
}

String encodeDisasterEvents(data){
  return jsonEncode(data);
}

String encodeAidDistribution(data){
  return jsonEncode(data);
}

String encodeIncidentReports(data){
  return jsonEncode(data);
}

String encodeResources(data){
  return jsonEncode(data);
}