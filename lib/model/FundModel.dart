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
    message: json["message"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class Data {
  int balance;
  int margin;
  List<Transaction> transactions;
  int totalAdded;
  int totalWithdrawn;
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
    balance: json["balance"],
    margin: json["margin"],
    transactions: List<Transaction>.from(json["transactions"].map((x) => Transaction.fromJson(x))),
    totalAdded: json["total_added"],
    totalWithdrawn: json["total_withdrawn"],
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
  int currentPage;
  int perPage;
  int total;
  int totalPages;
  bool hasNextPage;
  bool hasPrevPage;
  dynamic nextPage;
  dynamic prevPage;
  int from;
  int to;

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
    currentPage: json["current_page"],
    perPage: json["per_page"],
    total: json["total"],
    totalPages: json["total_pages"],
    hasNextPage: json["has_next_page"],
    hasPrevPage: json["has_prev_page"],
    nextPage: json["next_page"],
    prevPage: json["prev_page"],
    from: json["from"],
    to: json["to"],
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
  int id;
  String type;
  String transactionType;
  int amount;
  int status;
  int positionId;
  DateTime createdAt;
  DateTime approvedAt;

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
    id: json["id"],
    type: json["type"],
    transactionType: json["transaction_type"],
    amount: json["amount"],
    status: json["status"],
    positionId: json["position_id"],
    createdAt: DateTime.parse(json["created_at"]),
    approvedAt: DateTime.parse(json["approved_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "transaction_type": transactionType,
    "amount": amount,
    "status": status,
    "position_id": positionId,
    "created_at": createdAt.toIso8601String(),
    "approved_at": approvedAt.toIso8601String(),
  };
}
