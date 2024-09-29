import 'package:drs/services/api/root_api.dart';
import 'dart:developer' as devtools show log;

bool checkAcess(tableName, conditionName) {
  devtools.log(userRole);
  if (userRole.toString().toLowerCase() == 'administrator') {
    return true;
  } else if (userRole == 'volunteer') {
    if (tableName == 'volunteers' && conditionName == userName) {
      return true;
    } else {
      return false;
    }
  } else {
    return false;
  }
}
