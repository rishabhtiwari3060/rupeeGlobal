import 'dart:convert';

import 'package:get/get.dart';
import 'package:rupeeglobal/model/TicketModel.dart';
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

  Future<dynamic> getUserProfileRepo()async{
    var response = await DI<ApiService>().getMethod(DI<WebService>().PROFILE_END_POINT,
        header: mainHeader());

    print("geUserProfileRepo response :-- $response");
    return response.data;
  }

  Future<dynamic> getTicketRepo(String query)async{
    var response = await DI<ApiService>().getMethod("${DI<WebService>().TICKETS_POINT}$query",
        header: mainHeader());

    print("getTicketRepo response :-- $response");
    return ticketModelFromJson(jsonEncode(response.data));
  }


  Future<dynamic> createTicketRepo(Map<String, String> body)async{
    var response = await DI<ApiService>().postMethod(DI<WebService>().TICKETS_POINT,body,
        header: mainHeader());

    print("createTicketRepo response :-- $response");
    return response.data;
  }


  Future<dynamic> updateProfileRepo(Map<String, String> body)async{
    var response = await DI<ApiService>().putMethod(DI<WebService>().PROFILE_END_POINT,body,
        header: mainHeader());

    print("updateProfileRepo response :-- $response");
    return response.data;
  }

}
