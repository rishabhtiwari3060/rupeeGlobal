import 'dart:convert';

PaymentQrDetailModel paymentQrDetailModelFromJson(String str) =>
    PaymentQrDetailModel.fromJson(json.decode(str));

String paymentQrDetailModelToJson(PaymentQrDetailModel data) =>
    json.encode(data.toJson());

class PaymentQrDetailModel {
  bool success;
  String message;
  PaymentQrDetailData data;

  PaymentQrDetailModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PaymentQrDetailModel.fromJson(Map<String, dynamic> json) =>
      PaymentQrDetailModel(
        success: json["success"] ?? false,
        message: json["message"]?.toString() ?? "",
        data: PaymentQrDetailData.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class PaymentQrDetailData {
  int id;
  num amount;
  String status;
  String? qrCodeData;
  PaymentDetails? paymentDetails;
  String? paymentDate;
  String createdAt;

  PaymentQrDetailData({
    required this.id,
    required this.amount,
    required this.status,
    this.qrCodeData,
    this.paymentDetails,
    this.paymentDate,
    required this.createdAt,
  });

  factory PaymentQrDetailData.fromJson(Map<String, dynamic> json) =>
      PaymentQrDetailData(
        id: json["id"] ?? 0,
        amount: json["amount"] ?? 0,
        status: json["status"]?.toString() ?? "",
        qrCodeData: json["qr_code_data"]?.toString(),
        paymentDetails: json["payment_details"] != null
            ? PaymentDetails.fromJson(json["payment_details"])
            : null,
        paymentDate: json["payment_date"]?.toString(),
        createdAt: json["created_at"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "status": status,
        "qr_code_data": qrCodeData,
        "payment_details": paymentDetails?.toJson(),
        "payment_date": paymentDate,
        "created_at": createdAt,
      };
}

class PaymentDetails {
  String? upiId;
  String? upiName;
  String? upiMobile;
  String? accountNumber;
  String? ifscCode;
  String? bankName;
  String? accountHolderName;

  PaymentDetails({
    this.upiId,
    this.upiName,
    this.upiMobile,
    this.accountNumber,
    this.ifscCode,
    this.bankName,
    this.accountHolderName,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
        upiId: json["upi_id"]?.toString(),
        upiName: json["upi_name"]?.toString(),
        upiMobile: json["upi_mobile"]?.toString(),
        accountNumber: json["account_number"]?.toString(),
        ifscCode: json["ifsc_code"]?.toString(),
        bankName: json["bank_name"]?.toString(),
        accountHolderName: json["account_holder_name"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "upi_id": upiId,
        "upi_name": upiName,
        "upi_mobile": upiMobile,
        "account_number": accountNumber,
        "ifsc_code": ifscCode,
        "bank_name": bankName,
        "account_holder_name": accountHolderName,
      };
}
