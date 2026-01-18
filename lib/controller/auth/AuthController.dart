import 'dart:developer';

import 'package:get/get.dart';
import 'package:rupeeglobal/repo/auth_repo.dart';
import 'package:rupeeglobal/util/CommonFunction.dart';

import '../../util/Injection.dart';

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
      var response = DI<AuthRepo>().userRegisterRepo(registerMap);
      print("User Register response :-- $response");
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("userRegister exception :- ",error: e.toString());
    }


  }



}