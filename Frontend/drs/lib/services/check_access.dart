import 'package:drs/services/api/demo_login_api.dart';

bool checkAcess(tableName, conditionName){
  if(userRole == 'admin'){
    return true;
  }
  else if(userRole == 'volunteer'){
    if(tableName == 'volunteers' && conditionName == userName){
      return true;
    }
    else{
      return false;
    }
  }
  else{
    return false;
  }
}