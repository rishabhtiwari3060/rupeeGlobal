import 'dart:convert';

import 'package:get/get.dart';
import 'package:rupeeglobal/model/FundModel.dart';
import 'package:rupeeglobal/model/HoldingModel.dart';
import 'package:rupeeglobal/model/MarketIndicesModel.dart';
import 'package:rupeeglobal/model/PortfolioModel.dart';

import '../network/ApiService.dart';
import '../network/WebService.dart';
import '../util/Extension.dart';
import '../util/Injection.dart';

class HomeTabRepo extends GetxService{

  Future<dynamic> getHoldingRepo(String query)async{
    var response = await DI<ApiService>().getMethod("${DI<WebService>().HOLDING_POINT}$query",
        header: mainHeader());

    print("getHoldingRepo response :-- $response");
    return holdingModelFromJson(jsonEncode(response.data));
  }


  Future<dynamic> getPortfolioRepo()async{
    var response = await DI<ApiService>().getMethod(DI<WebService>().REPORT_POINT,
        header: mainHeader());

    print("getPortfolioRepo response :-- $response");
    return portfolioModelFromJson(jsonEncode(response.data));
  }

  Future<dynamic> getFundRepo(String query)async{
    var response = await DI<ApiService>().getMethod("${DI<WebService>().FUNDS_POINT}$query",
        header: mainHeader());

    print("getFundRepo response :-- $response");
    return fundModelFromJson(jsonEncode(response.data));
  }

  Future<dynamic> addFundRepo(Map<String,String> body)async{
    var response = await DI<ApiService>().postMethod(DI<WebService>().ADD_FUNDS_POINT,body,
        header: mainHeader());

    print("addFundRepo response :-- $response");
    return response.data;
  }

  Future<dynamic> withdrawFundRepo(Map<String,String> body)async{
    var response = await DI<ApiService>().postMethod(DI<WebService>().WITHDRAW_FUNDS_POINT,body,
        header: mainHeader());

    print("withdrawFundRepo response :-- $response");
    return response.data;
  }

  Future<dynamic> getMarketIndicesRepo()async{
    var response = await DI<ApiService>().getMethod(DI<WebService>().MARKET_INDICES_POINT,
        header: mainHeader());

    print("marketIndicesRepo response :-- $response");
    return marketIndicesModelFromJson(jsonEncode(response.data));
  }

}