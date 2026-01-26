import 'dart:developer';

import 'package:get/get.dart';
import 'package:rupeeglobal/repo/auth_repo.dart';
import 'package:rupeeglobal/util/CommonFunction.dart';

import '../../util/Injection.dart';
import '../../util/RouteHelper.dart';
import '../../util/local_storage.dart';

class AuthController extends GetxController{

  var isLoading = false.obs;
  var checkBoxValue = false.obs;

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

  Future<void> userVerifyCode(String email,String verificationCode,String screenType)async{
    isLoading.value = true;
    DI<CommonFunction>().showLoading();
    Map<String, String> verifyMap = {
      "email" : email,
      "verification_code":verificationCode,

    };

    print("userVerifyCode :-- $verifyMap");

    try{
      var response = await DI<AuthRepo>().userVerifyCodeRepo(verifyMap);
      print("userVerifyCode response :-- $response");
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

      var responseData = response["data"];
      if(response["success"].toString() == "true"){
        DI<CommonFunction>().showSuccessSnackBar(response["message"].toString().toLowerCase());
        if(screenType == "FORGOTPASSWORD"){
          var data = {
            "email":email
          };

          Get.toNamed(DI<RouteHelper>().getResetPasswordScreen(),parameters: data);
        }else{

          DI<MyLocalStorage>().setBoolValue(DI<MyLocalStorage>().isLogin,true);
          Get.toNamed(DI<RouteHelper>().getHomeTabScreen());
        }


      }

    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("userVerifyCode exception :- ",error: e.toString());
    }


  }


  Future<void> userLogin(String email,String password)async{
    isLoading.value = true;
    DI<CommonFunction>().showLoading();
    Map<String, String> loginMap = {
      "login" : email,
      "password":password
    };

    print("userLogin  :-- $loginMap");

    try{
      var response = await DI<AuthRepo>().userLoginRepo(loginMap);
      print("userLogin response :-- $response");
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

      var responseData = response["data"];
      var userData = responseData["user"];
      if(response["success"].toString() == "true"){
        DI<CommonFunction>().showSuccessSnackBar(response["success"].toString().toLowerCase());

        DI<MyLocalStorage>().setBoolValue(DI<MyLocalStorage>().isLogin,true);
        DI<MyLocalStorage>().setStringValue(DI<MyLocalStorage>().userName,userData["name"]);
        DI<MyLocalStorage>().setStringValue(DI<MyLocalStorage>().emailOrPhone,userData["email"]);
        DI<MyLocalStorage>().setStringValue(DI<MyLocalStorage>().userPhone,userData["phone"]);
        DI<MyLocalStorage>().setStringValue(DI<MyLocalStorage>().userBalance,userData["balance"]);
        DI<MyLocalStorage>().setStringValue(DI<MyLocalStorage>().authToken,responseData["access_token"]);

        Get.toNamed(DI<RouteHelper>().getHomeTabScreen());
      }

    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("userLogin exception :- ",error: e.toString());
    }


  }

  Future<void> sendForgotPasswordCode(String email)async{
    isLoading.value = true;
    DI<CommonFunction>().showLoading();
    Map<String, String> forgotPasswordMap = {
      "email" : email,
    };

    print("forgotPasswordMap :-- $forgotPasswordMap");

    try{
      var response = await DI<AuthRepo>().userSendVerificationCodeRepo(forgotPasswordMap);
      print("sendForgotPasswordCode response :-- $response");
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

      var responseData = response["data"];
      if(response["success"].toString() == "true"){
        DI<CommonFunction>().showSuccessSnackBar(response["message"].toString().toLowerCase());

         var data = {
                "email": email,
                "screenType": "FORGOTPASSWORD",
              };
              Get.toNamed(DI<RouteHelper>().getVerificationScreen(),parameters: data);
      }

    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("sendForgotPasswordCode exception :- ",error: e.toString());
    }
  }

  Future<void> resetPasswordCode(String email,String password,String passwordConfirmation)async{
    isLoading.value = true;
    DI<CommonFunction>().showLoading();
    Map<String, String> resetPasswordMap = {
      "email" : email,
      "password" : password,
      "password_confirmation" : passwordConfirmation,
    };

    print("resetPasswordCode :-- $resetPasswordMap");

    try{
      var response = await DI<AuthRepo>().userResetPasswordRepo(resetPasswordMap);
      print("sendResetPasswordCode response :-- $response");
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

      var responseData = response["data"];
      if(response["success"].toString() == "true"){
        DI<CommonFunction>().showSuccessSnackBar(response["message"].toString().toLowerCase());
        Get.offAllNamed(DI<RouteHelper>().getLoginScreen());
      }

    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("sendResetPasswordCode exception :- ",error: e.toString());
    }
  }


  Future<void> resendVerificationCode(String email)async{
    isLoading.value = true;
    DI<CommonFunction>().showLoading();
    Map<String, String> resendCodeMap = {
      "email" : email,
    };

    print("resendVerificationCode :-- $resendCodeMap");

    try{
      var response = await DI<AuthRepo>().resendVerificationCodeRepo(resendCodeMap);
      print("resendVerificationCode response :-- $response");
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

      var responseData = response["data"];
      if(response["success"].toString() == "true"){
        DI<CommonFunction>().showSuccessSnackBar(response["message"].toString().toLowerCase());
      }

    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("resendVerificationCode exception :- ",error: e.toString());
    }
  }
}