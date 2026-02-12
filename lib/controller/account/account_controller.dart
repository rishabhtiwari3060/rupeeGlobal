import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rupeeglobal/model/AgreementModel.dart';
import 'package:rupeeglobal/model/ChatDetailModel.dart';
import 'package:rupeeglobal/model/TicketModel.dart';
import 'package:rupeeglobal/model/news_model.dart';
import 'package:rupeeglobal/repo/account_repo.dart';
import 'package:rupeeglobal/util/CommonFunction.dart';
import 'package:rupeeglobal/util/local_storage.dart';

import '../../util/Injection.dart';

class AccountController extends GetxController{


  var isLoading = false.obs;
  var page = 1;

  var firstLetter = "".obs;
  var newsModel = Rxn<NewsModel>();
  var newsList = <News>[].obs;
  bool isScroll = true;
  var isBottomLoading = false.obs;

  //getUserProfile
  var userName = "".obs;
  var email = "",phone = "",panNo = "";

  /// Ticket
  var ticketModel = Rxn<TicketModel>();
  var ticketList = <Ticket>[].obs;

  ///Chat detail
  var chatModel = Rxn<ChatDetailModel>();
  var chatList = <Message>[].obs;


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

  Future<void> getUserProfile()async{
    isLoading.value = true;
    DI<CommonFunction>().showLoading();
    try {
      var response = await DI<AccountRepo>().getUserProfileRepo();
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      var responseData = response["data"];

      userName.value = responseData["name"];
      email = responseData["email"];
      phone = responseData["phone"];
      panNo = responseData["pan_no"];

    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

      log("Exception getUserProfile :- ",error: e.toString());
    }

  }

  Future<void> getTicketList(String status,String priority,String page)async{

    String query = "?status=$status&priority=$priority&page=$page&per_page=20";

    if(page.toString() == "1"){
      ticketList.clear();
      isLoading.value = true;
      ticketModel.value = null;
      DI<CommonFunction>().showLoading();
    }else{
      isBottomLoading.value = true;
    }

    try{

      var response = await DI<AccountRepo>().getTicketRepo(query);


      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      isBottomLoading.value = false;
      ticketModel.value = response;

      ticketList.addAll(ticketModel.value?.data.tickets??[]);

      if(ticketModel.value?.data.tickets.isEmpty??true){
        isScroll = false;
      }

    }catch(e){
      isLoading.value = false;
      isBottomLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception getTicketList :- ",error: e.toString());
    }

  }

  Future<void> createTicket(String priority,String message)async{

    DI<CommonFunction>().showLoading();

    Map<String, String> ticketBody = {
      "priority" : priority,
      "message" : message
    };

    print("ticketBody :- $ticketBody");

    try{

      var response = await DI<AccountRepo>().createTicketRepo(ticketBody);
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

      var responseData = response["data"];

      if(responseData != null){
        ticketList.insert(0,Ticket(id: responseData["id"],
            adminStatus:  responseData["admin_status"],
            createdAt:  responseData["created_at"],
            message:  responseData["message"],
            messagesCount: 0,
            priority: responseData["priority"],
            updatedAt: DateTime.now()));
        ticketList.refresh();
      }
    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception createTicket :- ",error: e.toString());
    }
  }

  Future<void> updateProfile(String name,String phone,String panNo)async{

    DI<CommonFunction>().showLoading();

    Map<String, String> profileBody = {
      "name" : name,
      "phone" : phone,
      "pan_no" : panNo,
    };

    print("profileBody :- $profileBody");

    try{

      var response = await DI<AccountRepo>().updateProfileRepo(profileBody);
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

      if(response["success"].toString() == "true"){
        userName.value = response["data"]["name"].toString();
        userName.refresh();
        firstLetter.value = userName.value[0];
        firstLetter.refresh();
        Get.back();
      }

    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception createTicket :- ",error: e.toString());
    }
  }

  Future<void> getChatDetail(String ticketId)async{
    isLoading.value = true;
    chatList.clear();
    DI<CommonFunction>().showLoading();
    try {
      var response = await DI<AccountRepo>().getChatDetailRepo(ticketId);
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

      chatModel.value = response;
      chatList.addAll(chatModel.value?.data?.messages??[]);

    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

      log("Exception getChatDetail :- ",error: e.toString());
    }
  }

  Future<void> sendChatMessage(String ticketId, String msg)async{
    isLoading.value = true;
    //DI<CommonFunction>().showLoading();

    Map<String,String> sendChatMap = {
      "message" : msg
    };
    print("sendChatMap :- $sendChatMap");

    try {
      var response = await DI<AccountRepo>().sendMessageRepo(ticketId,sendChatMap);
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();


    }catch(e){
      isLoading.value = false;
      DI<CommonFunction>().hideLoader();

      log("Exception sendChatMessage :- ",error: e.toString());
    }
  }

  // ========== AGREEMENT SECTION ==========
  var agreementListModel = Rxn<AgreementListModel>();
  var agreementList = <Agreement>[].obs;
  var selectedAgreement = Rxn<Agreement>();
  var isAgreementLoading = false.obs;
  var isUploadingAgreement = false.obs;

  Future<void> getAgreementsList() async {
    isAgreementLoading.value = true;
    agreementList.clear();
    DI<CommonFunction>().showLoading();

    try {
      var response = await DI<AccountRepo>().getAgreementsRepo();

      isAgreementLoading.value = false;
      DI<CommonFunction>().hideLoader();
      agreementListModel.value = response;

      agreementList.addAll(agreementListModel.value?.data.agreements ?? []);

    } catch (e) {
      isAgreementLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception getAgreementsList :- ", error: e.toString());
    }
  }

  Future<void> getAgreementDetail(int id) async {
    isAgreementLoading.value = true;
    DI<CommonFunction>().showLoading();

    try {
      var response = await DI<AccountRepo>().getAgreementDetailRepo(id);

      isAgreementLoading.value = false;
      DI<CommonFunction>().hideLoader();
      
      if (response != null && response is AgreementDetailModel) {
        selectedAgreement.value = response.data.agreement;
      }

    } catch (e) {
      isAgreementLoading.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception getAgreementDetail :- ", error: e.toString());
    }
  }

  Future<String> getAgreementDownloadUrl(int id) async {
    return await DI<AccountRepo>().getAgreementDownloadUrl(id);
  }

  Future<String> getAgreementViewSignedUrl(int id) async {
    return await DI<AccountRepo>().getAgreementViewSignedUrl(id);
  }

  Future<bool> uploadSignedAgreement(int id, String filePath) async {
    isUploadingAgreement.value = true;
    DI<CommonFunction>().showLoading();

    try {
      var response = await DI<AccountRepo>().uploadSignedAgreementRepo(id, filePath);

      isUploadingAgreement.value = false;
      DI<CommonFunction>().hideLoader();

      if (response != null && response["success"] == true) {
        // Update the agreement in the list
        int index = agreementList.indexWhere((a) => a.id == id);
        if (index != -1) {
          agreementList[index].status = "signed";
          agreementList[index].hasSignedDocument = true;
          agreementList.refresh();
        }
        
        // Refresh agreement detail if viewing
        if (selectedAgreement.value?.id == id) {
          selectedAgreement.value?.status = "signed";
          selectedAgreement.value?.hasSignedDocument = true;
          selectedAgreement.refresh();
        }
        
        return true;
      }
      return false;

    } catch (e) {
      isUploadingAgreement.value = false;
      DI<CommonFunction>().hideLoader();
      log("Exception uploadSignedAgreement :- ", error: e.toString());
      return false;
    }
  }

  // Helper getters for agreement stats
  int get pendingAgreementsCount => agreementList.where((a) => a.isPending).length;
  int get signedAgreementsCount => agreementList.where((a) => a.isSigned).length;

}
