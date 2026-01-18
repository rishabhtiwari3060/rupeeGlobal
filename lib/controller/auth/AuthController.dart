import 'dart:developer';

import 'package:get/get.dart';
import 'package:rupeeglobal/repo/auth_repo.dart';
import 'package:rupeeglobal/util/CommonFunction.dart';

import '../../util/Injection.dart';
import '../../util/RouteHelper.dart';

class AuthController extends GetxController{

  var isLoading = false.obs;

  Future<void> userRegister(String name,String email,String phone,String panNo,String password,String passwordConfirmation)async{
    isLoading.value = true;
    DI<CommonFunction>().showLoading();
    Map<String, String> registerMap = {
      "name" : name,
      "email":email,
      "phone":phone,
      "pan_no":panNo,
      "password":password,
      "password_confirmation":passwordConfirmation,
    };

    print("userRegister :-- $registerMap");

    try{
      var response = await DI<AuthRepo>().userRegisterRepo(registerMap);
      print("User Register response :-- $response");
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

      var responseData = response["data"];
      if(response["success"].toString() == "true"){
        var data = {
          "email": email,
          "screenType": "SIGNUP",
        };
        Get.toNamed(DI<RouteHelper>().getVerificationScreen(),
            parameters: data);
      }

    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("userRegister exception :- ",error: e.toString());
    }


  }



}