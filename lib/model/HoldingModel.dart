import 'dart:convert';

HoldingModel holdingModelFromJson(String str) => HoldingModel.fromJson(json.decode(str));

String holdingModelToJson(HoldingModel data) => json.encode(data.toJson());

class HoldingModel {
  bool success;
  String message;
  Data data;

  HoldingModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory HoldingModel.fromJson(Map<String, dynamic> json) => HoldingModel(
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
  List<Holding> holdings;
  Summary summary;
  Pagination pagination;

  Data({
    required this.holdings,
    required this.summary,
    required this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    holdings: List<Holding>.from(json["holdings"].map((x) => Holding.fromJson(x))),
    summary: Summary.fromJson(json["summary"]),
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "holdings": List<dynamic>.from(holdings.map((x) => x.toJson())),
    "summary": summary.toJson(),
    "pagination": pagination.toJson(),
  };
}

class Holding {
  int id;
  String symbol;
  String companyName;
  int quantity;
  int avgPrice;
  int ltp;
  int value;
  int pnl;
  double pnlPercent;
  DateTime createdAt;

  Holding({
    required this.id,
    required this.symbol,
    required this.companyName,
    required this.quantity,
    required this.avgPrice,
    required this.ltp,
    required this.value,
    required this.pnl,
    required this.pnlPercent,
    required this.createdAt,
  });

  factory Holding.fromJson(Map<String, dynamic> json) => Holding(
    id: json["id"],
    symbol: json["symbol"],
    companyName: json["company_name"],
    quantity: json["quantity"],
    avgPrice: json["avg_price"],
    ltp: json["ltp"],
    value: json["value"],
    pnl: json["pnl"],
    pnlPercent: json["pnl_percent"]?.toDouble(),
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "company_name": companyName,
    "quantity": quantity,
    "avg_price": avgPrice,
    "ltp": ltp,
    "value": value,
    "pnl": pnl,
    "pnl_percent": pnlPercent,
    "created_at": createdAt.toIso8601String(),
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

class Summary {
  int totalInvested;
  int totalValue;
  int totalProfit;
  double profitPercent;
  int margin;

  Summary({
    required this.totalInvested,
    required this.totalValue,
    required this.totalProfit,
    required this.profitPercent,
    required this.margin,
  });

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    totalInvested: json["total_invested"],
    totalValue: json["total_value"],
    totalProfit: json["total_profit"],
    profitPercent: json["profit_percent"]?.toDouble(),
    margin: json["margin"],
  );

  Map<String, dynamic> toJson() => {
    "total_invested": totalInvested,
    "total_value": totalValue,
    "total_profit": totalProfit,
    "profit_percent": profitPercent,
    "margin": margin,
  };
}
