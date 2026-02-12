import 'package:get/get.dart';


class WebService extends GetxService{


  String BASE_URL = "https://www.rupeeglobal.in/api/v1/";

  String REGISTER_END_POINT = "register";
  String LOGIN_END_POINT = "login";
  String FORGOT_PASSWORD_END_POINT = "forgot-password";
  String VERIFY_RESET_CODE_END_POINT = "verify-reset-code";
  String RESET_PASSWORD_END_POINT = "reset-password";
  String RESEND_VERIFICATION_END_POINT = "resend-verification-code";
  String NEWS_END_POINT = "news";
  String PROFILE_END_POINT = "profile";
  String TICKETS_POINT = "tickets";
  String HOLDING_POINT = "holdings";
  String REPORT_POINT = "reports";
  String FUNDS_POINT = "funds";
  String ADD_FUNDS_POINT = "funds/add";
  String WITHDRAW_FUNDS_POINT = "funds/withdraw";
  String MARKET_INDICES_POINT = "market-indices";
  String FOREX_PARIS_POINT = "forex-pairs";
  String POSITIONS_POINT = "positions";
  String AGREEMENTS_POINT = "agreements";
  String PAY_AMOUNT_POINT = "funds/payment-qr";
  String PAY_AMOUNT_DETAIL_POINT = "funds/payment-qr/";

  // Detail endpoints (use with symbol)
  String getMarketIndexDetailEndpoint(String symbol) => "market-indices/$symbol";
  String getForexPairDetailEndpoint(String symbol) => "forex-pairs/$symbol";
  String getPositionDetailEndpoint(String id) => "positions/$id";
  String getPaymentQrDetailEndpoint(int id) => "funds/payment-qr/$id";
  String getPaymentQrMarkPaidEndpoint(int id) => "funds/payment-qr/$id/mark-paid";

  // Agreement endpoints
  String getAgreementDetailEndpoint(int id) => "agreements/$id";
  String getAgreementDownloadEndpoint(int id) => "agreements/$id/download";
  String getAgreementUploadEndpoint(int id) => "agreements/$id/upload";
  String getAgreementViewSignedEndpoint(int id) => "agreements/$id/view-signed";

}
