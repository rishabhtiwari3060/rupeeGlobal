import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/repo/account_repo.dart';
import 'package:rupeeglobal/util/CommonFunction.dart';

import '../../util/Injection.dart';

class AccountController extends GetxController{


  var isLoading = false.obs;
  var index = 0;


  Future<void> getNewsList(String index)async{

    isLoading.value = true;
    DI<CommonFunction>().showLoading();

    String query = "?limit=$index";

    try{

      var response = await DI<AccountRepo>().getNewsListRepo(query);

      print("getNewsList response :-- $response");
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception getNewsList :- ",error: e.toString());
    }

  }


}