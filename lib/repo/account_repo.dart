import 'dart:convert';

import 'package:dio/dio.dart' as DIO;
import 'package:get/get.dart';
import 'package:rupeeglobal/model/AgreementModel.dart';
import 'package:rupeeglobal/model/ChatDetailModel.dart';
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

  Future<dynamic> getChatDetailRepo(String ticketId)async{
    var response = await DI<ApiService>().getMethod("${DI<WebService>().TICKETS_POINT}/$ticketId",
        header: mainHeader());

    print("getChatDetailRepo response :-- $response");
    return chatDetailModelFromJson(jsonEncode(response.data));
  }

  Future<dynamic> sendMessageRepo(String ticketId,Map<String,String> body)async{
    var response = await DI<ApiService>().postMethod("${DI<WebService>().TICKETS_POINT}/$ticketId/message",
        body,
        header: mainHeader());

    print("sendMessageRepo response :-- $response");
    return response.data;
  }

  // Agreement APIs
  Future<dynamic> getAgreementsRepo() async {
    var response = await DI<ApiService>().getMethod(
      DI<WebService>().AGREEMENTS_POINT,
      header: mainHeader(),
    );

    print("getAgreementsRepo response :-- $response");
    return agreementListModelFromJson(jsonEncode(response.data));
  }

  Future<dynamic> getAgreementDetailRepo(int id) async {
    var response = await DI<ApiService>().getMethod(
      DI<WebService>().getAgreementDetailEndpoint(id),
      header: mainHeader(),
    );

    print("getAgreementDetailRepo response :-- $response");
    return agreementDetailModelFromJson(jsonEncode(response.data));
  }

  Future<String> getAgreementDownloadUrl(int id) {
    return Future.value(
      "${DI<WebService>().BASE_URL}${DI<WebService>().getAgreementDownloadEndpoint(id)}"
    );
  }

  Future<String> getAgreementViewSignedUrl(int id) {
    return Future.value(
      "${DI<WebService>().BASE_URL}${DI<WebService>().getAgreementViewSignedEndpoint(id)}"
    );
  }

  Future<dynamic> uploadSignedAgreementRepo(int id, String filePath) async {
    DIO.FormData formData = DIO.FormData.fromMap({
      'signed_document': await DIO.MultipartFile.fromFile(filePath, filename: filePath.split('/').last),
    });

    var response = await DI<ApiService>().postMethodWithFormData(
      DI<WebService>().getAgreementUploadEndpoint(id),
      formData,
      header: mainHeader(),
    );

    print("uploadSignedAgreementRepo response :-- $response");
    return response.data;
  }

}
