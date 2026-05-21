import 'dart:convert';

PaymentQrModel paymentQrModelFromJson(String str) =>
    PaymentQrModel.fromJson(json.decode(str));

String paymentQrModelToJson(PaymentQrModel data) => json.encode(data.toJson());

class PaymentQrModel {
  bool success;
  String message;
  PaymentQrData data;

  PaymentQrModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PaymentQrModel.fromJson(Map<String, dynamic> json) => PaymentQrModel(
        success: json["success"] ?? false,
        message: json["message"]?.toString() ?? "",
        data: PaymentQrData.fromJson(json["data"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class PaymentQrData {
  List<PaymentQrCode> paymentQrCodes;

  PaymentQrData({
    required this.paymentQrCodes,
  });

  factory PaymentQrData.fromJson(Map<String, dynamic> json) => PaymentQrData(
        paymentQrCodes: List<PaymentQrCode>.from(
            (json["payment_qr_codes"] ?? []).map((x) => PaymentQrCode.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "payment_qr_codes":
            List<dynamic>.from(paymentQrCodes.map((x) => x.toJson())),
      };
}

class PaymentQrCode {
  int id;
  num amount;
  String status;
  String? paymentDate;
  String createdAt;

  PaymentQrCode({
    required this.id,
    required this.amount,
    required this.status,
    this.paymentDate,
    required this.createdAt,
  });

  factory PaymentQrCode.fromJson(Map<String, dynamic> json) => PaymentQrCode(
        id: json["id"] ?? 0,
        amount: json["amount"] ?? 0,
        status: json["status"]?.toString() ?? "",
        paymentDate: json["payment_date"]?.toString(),
        createdAt: json["created_at"]?.toString() ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "amount": amount,
        "status": status,
        "payment_date": paymentDate,
        "created_at": createdAt,
      };
}
