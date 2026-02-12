import 'dart:convert';

// Agreement List Model
AgreementListModel agreementListModelFromJson(String str) => 
    AgreementListModel.fromJson(json.decode(str));

String agreementListModelToJson(AgreementListModel data) => 
    json.encode(data.toJson());

class AgreementListModel {
  bool success;
  String message;
  AgreementListData data;

  AgreementListModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AgreementListModel.fromJson(Map<String, dynamic> json) => AgreementListModel(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: AgreementListData.fromJson(json["data"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class AgreementListData {
  List<Agreement> agreements;

  AgreementListData({
    required this.agreements,
  });

  factory AgreementListData.fromJson(Map<String, dynamic> json) => AgreementListData(
    agreements: json["agreements"] != null 
        ? List<Agreement>.from(json["agreements"].map((x) => Agreement.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    "agreements": List<dynamic>.from(agreements.map((x) => x.toJson())),
  };
}

class Agreement {
  int id;
  String title;
  String status;  // pending or signed
  String? signedAt;
  String createdAt;
  bool hasSignedDocument;
  String? content;  // Available in detail response
  String? signedDocumentUrl;  // Available in detail response

  Agreement({
    required this.id,
    required this.title,
    required this.status,
    this.signedAt,
    required this.createdAt,
    required this.hasSignedDocument,
    this.content,
    this.signedDocumentUrl,
  });

  factory Agreement.fromJson(Map<String, dynamic> json) => Agreement(
    id: json["id"] ?? 0,
    title: json["title"] ?? "",
    status: json["status"] ?? "pending",
    signedAt: json["signed_at"],
    createdAt: json["created_at"] ?? "",
    hasSignedDocument: json["has_signed_document"] ?? false,
    content: json["content"],
    signedDocumentUrl: json["signed_document_url"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "status": status,
    "signed_at": signedAt,
    "created_at": createdAt,
    "has_signed_document": hasSignedDocument,
    "content": content,
    "signed_document_url": signedDocumentUrl,
  };

  bool get isPending => status == "pending";
  bool get isSigned => status == "signed";
}

// Agreement Detail Model
AgreementDetailModel agreementDetailModelFromJson(String str) => 
    AgreementDetailModel.fromJson(json.decode(str));

String agreementDetailModelToJson(AgreementDetailModel data) => 
    json.encode(data.toJson());

class AgreementDetailModel {
  bool success;
  String message;
  AgreementDetailData data;

  AgreementDetailModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AgreementDetailModel.fromJson(Map<String, dynamic> json) => AgreementDetailModel(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: AgreementDetailData.fromJson(json["data"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class AgreementDetailData {
  Agreement agreement;

  AgreementDetailData({
    required this.agreement,
  });

  factory AgreementDetailData.fromJson(Map<String, dynamic> json) => AgreementDetailData(
    agreement: Agreement.fromJson(json["agreement"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "agreement": agreement.toJson(),
  };
}
