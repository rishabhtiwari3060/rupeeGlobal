import 'dart:developer';

import 'package:get/get.dart';
import 'package:rupeeglobal/model/FundModel.dart';
import 'package:rupeeglobal/model/HoldingModel.dart';
import 'package:rupeeglobal/model/PortfolioModel.dart';
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


  Future<void> addFund(amount)async{
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

    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception addFund :- ",error: e.toString());
    }

  }

}