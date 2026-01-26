import 'package:get/get.dart';
import 'package:rupeeglobal/network/ApiService.dart';
import 'package:rupeeglobal/network/WebService.dart';

import '../util/Injection.dart';

class AuthRepo extends GetxService{


  Future<dynamic> userRegisterRepo(Map<String, String> body)async{
    var response = await DI<ApiService>().postMethod(DI<WebService>().REGISTER_END_POINT, body);
    return response.data;
  }

  Future<dynamic> userVerifyCodeRepo(Map<String, String> body)async{
    var response = await DI<ApiService>().postMethod(DI<WebService>().VERIFY_RESET_CODE_END_POINT, body);
    return response.data;
  }

  Future<dynamic> userLoginRepo(Map<String, String> body)async{
    var response = await DI<ApiService>().postMethod(DI<WebService>().LOGIN_END_POINT, body);
    return response.data;
  }

  Future<dynamic> userSendVerificationCodeRepo(Map<String, String> body)async{
    var response = await DI<ApiService>().postMethod(DI<WebService>().FORGOT_PASSWORD_END_POINT, body);
    return response.data;
  }

  Future<dynamic> userResetPasswordRepo(Map<String, String> body)async{
    var response = await DI<ApiService>().postMethod(DI<WebService>().RESET_PASSWORD_END_POINT, body);
    return response.data;
  }


  Future<dynamic> resendVerificationCodeRepo(Map<String, String> body)async{
    var response = await DI<ApiService>().postMethod(DI<WebService>().RESEND_VERIFICATION_END_POINT, body);
    return response.data;
  }

}