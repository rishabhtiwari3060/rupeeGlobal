import 'package:get/get.dart';
import 'package:rupeeglobal/network/ApiService.dart';
import 'package:rupeeglobal/network/WebService.dart';

import '../util/Injection.dart';

class AuthRepo extends GetxService{


  Future<dynamic> userRegisterRepo(Map<String, String> body)async{
    var response = await DI<ApiService>().postMethod(DI<WebService>().BASE_URL, body);
    return response.data;
  }

}