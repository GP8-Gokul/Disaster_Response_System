import 'package:drs/services/api/root_api.dart';
import 'dart:developer' as devtools show log;

bool checkAcess(tableName, conditionName) {
  devtools.log(userRole);
  if (userRole.toString().toLowerCase() == 'admin') {
    return true;
  }else if(tableName == 'messages'){
    if (userRole == 'volunteer') {
      return true;
    }
    else if(userRole == 'reporter'){
      return true;
    }
    else {
      return false;
    }
  } 
  else if (userRole == 'volunteer') {
    if (tableName == 'volunteers' && conditionName == userName) {
      return true;
    } else {
      return false;
    }
  } else if(userRole == 'reporter'){
    if (tableName == 'incident_reports' && conditionName == 'insert') {
      return true;
    } 
    else if (tableName == 'incident_reports' && conditionName == userName) {
      return true;
    } 
    else {
      return false;
    }
  } 
  else {
    return false;
  }
}

bool chatDeleteAccess(conditionName){
  if(userRole == 'admin'){
    return true;
  }
  else if(conditionName == userName){
    return true;
  }
  else{
    return false;
  }
}
