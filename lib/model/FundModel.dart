import 'dart:convert';

FundModel fundModelFromJson(String str) => FundModel.fromJson(json.decode(str));

String fundModelToJson(FundModel data) => json.encode(data.toJson());

class FundModel {
  bool success;
  String message;
  Data data;

  FundModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory FundModel.fromJson(Map<String, dynamic> json) => FundModel(
    success: json["success"],
    message: json["message"].toString(),
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  String balance;
  String margin;
  List<Transaction> transactions;
  String totalAdded;
  String totalWithdrawn;
  Pagination pagination;

  Data({
    required this.balance,
    required this.margin,
    required this.transactions,
    required this.totalAdded,
    required this.totalWithdrawn,
    required this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    balance: json["balance"].toString(),
    margin: json["margin"].toString(),
    transactions: List<Transaction>.from(json["transactions"].map((x) => Transaction.fromJson(x))),
    totalAdded: json["total_added"].toString(),
    totalWithdrawn: json["total_withdrawn"].toString(),
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "balance": balance,
    "margin": margin,
    "transactions": List<dynamic>.from(transactions.map((x) => x.toJson())),
    "total_added": totalAdded,
    "total_withdrawn": totalWithdrawn,
    "pagination": pagination.toJson(),
  };
}

class Pagination {
  String currentPage;
  String perPage;
  String total;
  String totalPages;
  String hasNextPage;
  String hasPrevPage;
  String nextPage;
  String prevPage;
  String from;
  String to;

  Pagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
    required this.nextPage,
    required this.prevPage,
    required this.from,
    required this.to,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    currentPage: json["current_page"].toString(),
    perPage: json["per_page"].toString(),
    total: json["total"].toString(),
    totalPages: json["total_pages"].toString(),
    hasNextPage: json["has_next_page"].toString(),
    hasPrevPage: json["has_prev_page"].toString(),
    nextPage: json["next_page"].toString(),
    prevPage: json["prev_page"].toString(),
    from: json["from"].toString(),
    to: json["to"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "per_page": perPage,
    "total": total,
    "total_pages": totalPages,
    "has_next_page": hasNextPage,
    "has_prev_page": hasPrevPage,
    "next_page": nextPage,
    "prev_page": prevPage,
    "from": from,
    "to": to,
  };
}

class Transaction {
  String id;
  String type;
  String transactionType;
  String amount;
  String status;
  String positionId;
  String createdAt;
  String approvedAt;

  Transaction({
    required this.id,
    required this.type,
    required this.transactionType,
    required this.amount,
    required this.status,
    required this.positionId,
    required this.createdAt,
    required this.approvedAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json["id"].toString(),
    type: json["type"].toString(),
    transactionType: json["transaction_type"].toString(),
    amount: json["amount"].toString(),
    status: json["status"].toString(),
    positionId: json["position_id"].toString(),
    createdAt: json["created_at"].toString(),
    approvedAt: json["approved_at"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "transaction_type": transactionType,
    "amount": amount,
    "status": status,
    "position_id": positionId,
    "created_at": createdAt,
    "approved_at": approvedAt,
  };
}
