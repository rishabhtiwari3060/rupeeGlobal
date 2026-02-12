import 'dart:developer';

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
import 'package:rupeeglobal/repo/home_tab_repo.dart';

import '../../util/CommonFunction.dart';
import '../../util/Injection.dart';


class HomeTabController extends GetxService{

  var isLoading = false.obs;


  var holdingModel = Rxn<HoldingModel>();
  var holdingList = <Holding>[].obs;
  var isBottomLoading = false.obs;
  bool isScroll = true;

  var portfolioModel = Rxn<PortfolioModel>();

  //Funds
  var fundsModel = Rxn<FundModel>();
  var fundsList = <Transaction>[].obs;

  // Payment QR (Pay Amount tab)
  var paymentQrModel = Rxn<PaymentQrModel>();
  var paymentQrList = <PaymentQrCode>[].obs;
  var isPaymentQrLoading = false.obs;

  // Payment QR Detail
  var paymentQrDetailModel = Rxn<PaymentQrDetailModel>();
  var isPaymentQrDetailLoading = false.obs;

  var marketIndicesModel = Rxn<MarketIndicesModel>();
  var forexPairsModel = Rxn<ForexPairsModel>();
  var selectedHomeTab = 0.obs; // 0 = Market Indices, 1 = Forex Pairs

  // Market Index Detail
  var marketIndexDetailModel = Rxn<MarketIndexDetailModel>();
  
  // Forex Pair Detail
  var forexPairDetailModel = Rxn<ForexPairDetailModel>();

  // Positions
  var positionModel = Rxn<PositionModel>();
  var positionList = <Position>[].obs;
  var selectedPositionType = "Regular".obs; // Regular, MTF, Strategy
  var selectedPositionStatus = "CF".obs; // CF, Closed
  bool isPositionScroll = true;
  var positionPage = 1.obs;

  Future<void> getHoldingList(String page)async{


    String query = "?page=$page&per_page=20";

    if(page.toString() == "1"){
      holdingList.clear();
      isLoading.value = true;
      DI<CommonFunction>().showLoading();
    }else{
      isBottomLoading.value = true;
    }

    try{

      var response = await DI<HomeTabRepo>().getHoldingRepo(query);


      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      isBottomLoading.value = false;
      holdingModel.value = response;

      holdingList.addAll(holdingModel.value?.data.holdings??[]);

      if(holdingModel.value?.data.holdings.isEmpty??true){
        isScroll = false;
      }

    }catch(e){
      isLoading.value = false;
      isBottomLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception getHoldingList :- ",error: e.toString());
    }

  }

  Future<void> getPortfolio()async{

    isLoading.value = true;
    DI<CommonFunction>().showLoading();
    portfolioModel.value = null;

    try{

      var response = await DI<HomeTabRepo>().getPortfolioRepo();
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

      portfolioModel.value = response;

    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception getPortfolio :- ",error: e.toString());
    }



  }


  Future<void> getFundList(String page)async{

    String query = "?page=$page&per_page=20";

    if(page.toString() == "1"){
      fundsList.clear();
      isLoading.value = true;
      DI<CommonFunction>().showLoading();
    }else{
      isBottomLoading.value = true;
    }

    try{
      var response = await DI<HomeTabRepo>().getFundRepo(query);
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      isBottomLoading.value = false;
      fundsModel.value = response;

      fundsList.addAll(fundsModel.value?.data.transactions??[]);

      if(fundsModel.value?.data.transactions.isEmpty??true){
        isScroll = false;
      }

    }catch(e){
      isLoading.value = false;
      isBottomLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception getFundList :- ",error: e.toString());
    }

  }


  Future<bool> addFund(amount)async{
    isLoading.value = true;
    DI<CommonFunction>().showLoading();

    Map<String,String> addFundMap = {
      "amount" : amount
    };
    print("addFundMap :-- $addFundMap");

    try{
      var response = await DI<HomeTabRepo>().addFundRepo(addFundMap);
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

      if(response["success"].toString() == "true"){

        DI<CommonFunction>().showSuccessSnackBar(response["message"].toString());
        getFundList("1");
        return true;
      }
      return false;
    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception addFund :- ",error: e.toString());
      return false;
    }
    return false;
  }


  Future<bool> withdrawFund(String amount,upiId,upiName,notes)async{
    isLoading.value = true;
    DI<CommonFunction>().showLoading();

    Map<String,String> withdrawFundMap = {
      "amount" : amount,
      "upi_id" : upiId,
      "upi_name" : upiName,
      "user_notes" : notes,
    };
    print("addFundMap :-- $withdrawFundMap");

    try{
      var response = await DI<HomeTabRepo>().withdrawFundRepo(withdrawFundMap);
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

      if(response["success"].toString() == "true"){

        DI<CommonFunction>().showSuccessSnackBar(response["message"].toString());
        getFundList("1");
        return true;
      }
      return false;
    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception withdrawFund :- ",error: e.toString());
      return false;
    }
    return false;
  }

  Future<void> getPaymentQrList()async{
    isPaymentQrLoading.value = true;
    paymentQrList.clear();
    paymentQrModel.value = null;

    try{
      var response = await DI<HomeTabRepo>().getPaymentQrRepo();
      isPaymentQrLoading.value = false;
      paymentQrModel.value = response;
      paymentQrList.addAll(paymentQrModel.value?.data.paymentQrCodes ?? []);
    }catch(e){
      isPaymentQrLoading.value = false;
      log("Exception getPaymentQrList :- ",error: e.toString());
    }
  }

  Future<void> getPaymentQrDetail(int id)async{
    isPaymentQrDetailLoading.value = true;
    paymentQrDetailModel.value = null;
    DI<CommonFunction>().showLoading();

    try{
      var response = await DI<HomeTabRepo>().getPaymentQrDetailRepo(id);
      isPaymentQrDetailLoading.value = false;
      DI<CommonFunction>().hideLoader();
      paymentQrDetailModel.value = response;
    }catch(e){
      isPaymentQrDetailLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception getPaymentQrDetail :- ",error: e.toString());
    }
  }

  Future<void> markPaymentQrPaid(int id)async{
    DI<CommonFunction>().showLoading();
    try{
      var response = await DI<HomeTabRepo>().markPaymentQrPaidRepo(id);
      DI<CommonFunction>().hideLoader();
      if(response != null && response["success"] == true){
        final idx = paymentQrList.indexWhere((e) => e.id == id);
        if(idx >= 0){
          final item = paymentQrList[idx];
          paymentQrList[idx] = PaymentQrCode(
            id: item.id,
            amount: item.amount,
            status: "paid",
            paymentDate:response["data"]["payment_date"],
            createdAt: item.createdAt,
          );
          paymentQrList.refresh();
        }
        DI<CommonFunction>().showSuccessSnackBar(
            response["message"]?.toString() ?? "Payment marked as paid successfully");
        Get.back();
      } else {
        DI<CommonFunction>().showErrorSnackBar(
            response?["message"]?.toString() ?? "Failed to mark payment as paid");
      }
    }catch(e){
      DI<CommonFunction>().hideLoader();
      DI<CommonFunction>().showErrorSnackBar("Failed to mark payment as paid");
      log("Exception markPaymentQrPaid :- ",error: e.toString());
    }
  }

  Future<void> getMarketIndices()async{
    isLoading.value = true;
    DI<CommonFunction>().showLoading();
    marketIndicesModel.value = null;

    try{
      var response = await DI<HomeTabRepo>().getMarketIndicesRepo();
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      marketIndicesModel.value = response;
    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception getMarketIndices :- ",error: e.toString());
    }
  }

  Future<void> getForexPairs()async{
    isLoading.value = true;
    DI<CommonFunction>().showLoading();
    forexPairsModel.value = null;

    try{
      var response = await DI<HomeTabRepo>().getForexPairsRepo();
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      forexPairsModel.value = response;
    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception getForexPairs :- ",error: e.toString());
    }
  }

  // Get Market Index Detail
  Future<void> getMarketIndexDetail(String symbol)async{
    isLoading.value = true;
    DI<CommonFunction>().showLoading();
    marketIndexDetailModel.value = null;

    try{
      var response = await DI<HomeTabRepo>().getMarketIndexDetailRepo(symbol);
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      marketIndexDetailModel.value = response;
    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception getMarketIndexDetail :- ",error: e.toString());
    }
  }

  // Get Forex Pair Detail
  Future<void> getForexPairDetail(String symbol)async{
    isLoading.value = true;
    DI<CommonFunction>().showLoading();
    forexPairDetailModel.value = null;

    try{
      var response = await DI<HomeTabRepo>().getForexPairDetailRepo(symbol);
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      forexPairDetailModel.value = response;
    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception getForexPairDetail :- ",error: e.toString());
    }
  }

  // Get Positions with filters and pagination
  Future<void> getPositionList(String page, {String? type, String? status})async{
    
    // Build query string with filters
    String query = "?page=$page&per_page=20";
    if(type != null && type.isNotEmpty){
      query += "&type=$type";
    }
    if(status != null && status.isNotEmpty){
      query += "&status=$status";
    }

    if(page.toString() == "1"){
      positionList.clear();
      isLoading.value = true;
      DI<CommonFunction>().showLoading();
      isPositionScroll = true;
    }else{
      isBottomLoading.value = true;
    }

    try{
      var response = await DI<HomeTabRepo>().getPositionsRepo(query);
      
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      isBottomLoading.value = false;
      positionModel.value = response;

      positionList.addAll(positionModel.value?.data.positions??[]);

      if(positionModel.value?.data.positions.isEmpty??true){
        isPositionScroll = false;
      }

    }catch(e){
      isLoading.value = false;
      isBottomLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception getPositionList :- ",error: e.toString());
    }
  }

  // Reset positions and fetch with new filters
  void refreshPositions(){
    positionPage.value = 1;
    getPositionList("1", type: selectedPositionType.value, status: selectedPositionStatus.value);
  }

  // Change position type filter
  void changePositionType(String type){
    selectedPositionType.value = type;
    refreshPositions();
  }

  // Change position status filter
  void changePositionStatus(String status){
    selectedPositionStatus.value = status;
    refreshPositions();
  }

}