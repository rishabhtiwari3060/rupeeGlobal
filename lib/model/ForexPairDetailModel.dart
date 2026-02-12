import 'dart:convert';

ForexPairDetailModel forexPairDetailModelFromJson(String str) => 
    ForexPairDetailModel.fromJson(json.decode(str));

String forexPairDetailModelToJson(ForexPairDetailModel data) => 
    json.encode(data.toJson());

class ForexPairDetailModel {
  bool success;
  String message;
  ForexPairDetail data;

  ForexPairDetailModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ForexPairDetailModel.fromJson(Map<String, dynamic> json) => ForexPairDetailModel(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: ForexPairDetail.fromJson(json["data"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class ForexPairDetail {
  String symbol;
  String name;
  String description;
  double price;
  double change;
  double changePercent;
  double open;
  double high;
  double low;
  double previousClose;
  int timestamp;
  bool isMarketOpen;

  ForexPairDetail({
    required this.symbol,
    required this.name,
    required this.description,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.open,
    required this.high,
    required this.low,
    required this.previousClose,
    required this.timestamp,
    required this.isMarketOpen,
  });

  factory ForexPairDetail.fromJson(Map<String, dynamic> json) => ForexPairDetail(
    symbol: json["symbol"] ?? "",
    name: json["name"] ?? "",
    description: json["description"] ?? "",
    price: (json["price"] ?? 0).toDouble(),
    change: (json["change"] ?? 0).toDouble(),
    changePercent: (json["change_percent"] ?? 0).toDouble(),
    open: (json["open"] ?? 0).toDouble(),
    high: (json["high"] ?? 0).toDouble(),
    low: (json["low"] ?? 0).toDouble(),
    previousClose: (json["previous_close"] ?? 0).toDouble(),
    timestamp: json["timestamp"] ?? 0,
    isMarketOpen: json["is_market_open"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "symbol": symbol,
    "name": name,
    "description": description,
    "price": price,
    "change": change,
    "change_percent": changePercent,
    "open": open,
    "high": high,
    "low": low,
    "previous_close": previousClose,
    "timestamp": timestamp,
    "is_market_open": isMarketOpen,
  };
}
