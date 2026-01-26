import 'dart:convert';

import 'package:get/get.dart';
import 'package:rupeeglobal/model/news_model.dart';
import 'package:rupeeglobal/util/Extension.dart';

import '../network/ApiService.dart';
import '../network/WebService.dart';
import '../util/Injection.dart';

class AccountRepo extends GetxService{


  Future<dynamic> getNewsListRepo(String query)async{
    var response = await DI<ApiService>().getMethod("${DI<WebService>().NEWS_END_POINT}$query",header: mainHeader());

    print("getNewsList response :-- $response");
    return newsModelFromJson(jsonEncode(response.data));
  }

}
