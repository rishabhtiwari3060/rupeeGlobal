import 'dart:convert';

PositionModel positionModelFromJson(String str) => PositionModel.fromJson(json.decode(str));

String positionModelToJson(PositionModel data) => json.encode(data.toJson());

class PositionModel {
  bool success;
  String message;
  PositionData data;

  PositionModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PositionModel.fromJson(Map<String, dynamic> json) => PositionModel(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: PositionData.fromJson(json["data"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class PositionData {
  List<Position> positions;
  double totalPnl;
  PositionPagination pagination;

  PositionData({
    required this.positions,
    required this.totalPnl,
    required this.pagination,
  });

  factory PositionData.fromJson(Map<String, dynamic> json) => PositionData(
    positions: json["positions"] != null 
        ? List<Position>.from(json["positions"].map((x) => Position.fromJson(x)))
        : [],
    totalPnl: (json["total_pnl"] ?? 0).toDouble(),
    pagination: PositionPagination.fromJson(json["pagination"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "positions": List<dynamic>.from(positions.map((x) => x.toJson())),
    "total_pnl": totalPnl,
    "pagination": pagination.toJson(),
  };
}

class Position {
  int id;
  String symbol;
  String type;        // Regular, MTF, Strategy
  String status;      // CF, Closed
  int quantity;
  double buyPrice;
  double sellPrice;
  double pnl;
  double pnlPercent;
  String expiryDate;
  DateTime createdAt;

  Position({
    required this.id,
    required this.symbol,
    required this.type,
    required this.status,
    required this.quantity,
    required this.buyPrice,
    required this.sellPrice,
    required this.pnl,
    required this.pnlPercent,
    required this.expiryDate,
    required this.createdAt,
  });

  factory Position.fromJson(Map<String, dynamic> json) => Position(
    id: json["id"] ?? 0,
    symbol: json["symbol"] ?? "",
    type: json["type"] ?? "Regular",
    status: json["status"] ?? "CF",
    quantity: json["quantity"] ?? 0,
    buyPrice: (json["buy_price"] ?? 0).toDouble(),
    sellPrice: (json["sell_price"] ?? 0).toDouble(),
    pnl: (json["pnl"] ?? 0).toDouble(),
    pnlPercent: (json["pnl_percent"] ?? 0).toDouble(),
    expiryDate: json["expiry_date"] ?? "",
    createdAt: json["created_at"] != null 
        ? DateTime.parse(json["created_at"]) 
        : DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "symbol": symbol,
    "type": type,
    "status": status,
    "quantity": quantity,
    "buy_price": buyPrice,
    "sell_price": sellPrice,
    "pnl": pnl,
    "pnl_percent": pnlPercent,
    "expiry_date": expiryDate,
    "created_at": createdAt.toIso8601String(),
  };
}

class PositionPagination {
  int currentPage;
  int perPage;
  int total;
  int totalPages;
  bool hasNextPage;
  bool hasPrevPage;
  int? nextPage;
  int? prevPage;
  int from;
  int to;

  PositionPagination({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
    this.nextPage,
    this.prevPage,
    required this.from,
    required this.to,
  });

  factory PositionPagination.fromJson(Map<String, dynamic> json) => PositionPagination(
    currentPage: json["current_page"] ?? 1,
    perPage: json["per_page"] ?? 20,
    total: json["total"] ?? 0,
    totalPages: json["total_pages"] ?? 0,
    hasNextPage: json["has_next_page"] ?? false,
    hasPrevPage: json["has_prev_page"] ?? false,
    nextPage: json["next_page"],
    prevPage: json["prev_page"],
    from: json["from"] ?? 0,
    to: json["to"] ?? 0,
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
