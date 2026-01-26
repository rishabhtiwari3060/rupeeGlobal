import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/model/news_model.dart';
import 'package:rupeeglobal/repo/account_repo.dart';
import 'package:rupeeglobal/util/CommonFunction.dart';

import '../../util/Injection.dart';

class AccountController extends GetxController{


  var isLoading = false.obs;
  var page = 1;

  var newsModel = Rxn<NewsModel>();
  var newsList = <News>[].obs;
  bool isScroll = true;
  var isBottomLoading = false.obs;


  Future<void> getNewsList(String page)async{




    String query = "?page=$page&per_page=20";

    if(page.toString() == "1"){
      newsList.clear();
      isLoading.value = true;
      DI<CommonFunction>().showLoading();
    }else{
      isBottomLoading.value = true;
    }

    try{

      var response = await DI<AccountRepo>().getNewsListRepo(query);


      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      isBottomLoading.value = false;
      newsModel.value = response;

      newsList.addAll(newsModel.value?.data.news??[]);

      if(newsModel.value?.data.news.isEmpty??true){
        isScroll = false;
      }

    }catch(e){
      isLoading.value = false;
      isBottomLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception getNewsList :- ",error: e.toString());
    }

  }


}