import 'dart:convert';

import 'package:get/get.dart';
import 'package:rupeeglobal/model/FundModel.dart';
import 'package:rupeeglobal/model/HoldingModel.dart';
import 'package:rupeeglobal/model/ForexPairsModel.dart';
import 'package:rupeeglobal/model/MarketIndicesModel.dart';
import 'package:rupeeglobal/model/PortfolioModel.dart';
import 'package:rupeeglobal/model/PositionModel.dart';
import 'package:rupeeglobal/model/MarketIndexDetailModel.dart';
import 'package:rupeeglobal/model/ForexPairDetailModel.dart';
import 'package:rupeeglobal/model/PaymentQrModel.dart';
import 'package:rupeeglobal/model/PaymentQrDetailModel.dart';

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

  Future<dynamic> getPaymentQrRepo()async{
    var response = await DI<ApiService>().getMethod(DI<WebService>().PAY_AMOUNT_POINT,
        header: mainHeader());

    print("getPaymentQrRepo response :-- $response");
    return paymentQrModelFromJson(jsonEncode(response.data));
  }

  Future<dynamic> getPaymentQrDetailRepo(int id)async{
    var response = await DI<ApiService>().getMethod(
        DI<WebService>().getPaymentQrDetailEndpoint(id),
        header: mainHeader());

    print("getPaymentQrDetailRepo response :-- $response");
    return paymentQrDetailModelFromJson(jsonEncode(response.data));
  }

  Future<dynamic> markPaymentQrPaidRepo(int id)async{
    var response = await DI<ApiService>().postMethod(
        DI<WebService>().getPaymentQrMarkPaidEndpoint(id),
        {},
        header: mainHeader());

    print("markPaymentQrPaidRepo response :-- $response");
    return response.data;
  }

  Future<dynamic> getMarketIndicesRepo()async{
    var response = await DI<ApiService>().getMethod(DI<WebService>().MARKET_INDICES_POINT,
        header: mainHeader());

    print("marketIndicesRepo response :-- $response");
    return marketIndicesModelFromJson(jsonEncode(response.data));
  }

  Future<dynamic> getForexPairsRepo()async{
    var response = await DI<ApiService>().getMethod(DI<WebService>().FOREX_PARIS_POINT,
        header: mainHeader());

    print("getForexPairsRepo response :-- $response");
    return forexPairsModelFromJson(jsonEncode(response.data));
  }

  // Market Index Detail API
  Future<dynamic> getMarketIndexDetailRepo(String symbol)async{
    var response = await DI<ApiService>().getMethod(
        DI<WebService>().getMarketIndexDetailEndpoint(symbol),
        header: mainHeader());

    print("getMarketIndexDetailRepo response :-- $response");
    return marketIndexDetailModelFromJson(jsonEncode(response.data));
  }

  // Forex Pair Detail API
  Future<dynamic> getForexPairDetailRepo(String symbol)async{
    var response = await DI<ApiService>().getMethod(
        DI<WebService>().getForexPairDetailEndpoint(symbol),
        header: mainHeader());

    print("getForexPairDetailRepo response :-- $response");
    return forexPairDetailModelFromJson(jsonEncode(response.data));
  }

  // Positions API with filters and pagination
  Future<dynamic> getPositionsRepo(String query)async{
    var response = await DI<ApiService>().getMethod(
        "${DI<WebService>().POSITIONS_POINT}$query",
        header: mainHeader());

    print("getPositionsRepo response :-- $response");
    return positionModelFromJson(jsonEncode(response.data));
  }

  // Position Detail API
  Future<dynamic> getPositionDetailRepo(String id)async{
    var response = await DI<ApiService>().getMethod(
        DI<WebService>().getPositionDetailEndpoint(id),
        header: mainHeader());

    print("getPositionDetailRepo response :-- $response");
    return response.data;
  }

}