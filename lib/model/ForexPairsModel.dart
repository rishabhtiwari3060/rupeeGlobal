import 'dart:convert';

ForexPairsModel forexPairsModelFromJson(String str) => ForexPairsModel.fromJson(json.decode(str));

String forexPairsModelToJson(ForexPairsModel data) => json.encode(data.toJson());

class ForexPairsModel {
  bool success;
  String message;
  List<ForexPairDatum> data;

  ForexPairsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory ForexPairsModel.fromJson(Map<String, dynamic> json) => ForexPairsModel(
    success: json["success"],
    message: json["message"],
    data: List<ForexPairDatum>.from(json["data"].map((x) => ForexPairDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class ForexPairDatum {
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

  ForexPairDatum({
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

  factory ForexPairDatum.fromJson(Map<String, dynamic> json) => ForexPairDatum(
    symbol: json["symbol"] ?? "",
    name: json["name"] ?? "",
    description: json["description"] ?? "",
    price: json["price"]?.toDouble() ?? 0.0,
    change: json["change"]?.toDouble() ?? 0.0,
    changePercent: json["change_percent"]?.toDouble() ?? 0.0,
    open: json["open"]?.toDouble() ?? 0.0,
    high: json["high"]?.toDouble() ?? 0.0,
    low: json["low"]?.toDouble() ?? 0.0,
    previousClose: json["previous_close"]?.toDouble() ?? 0.0,
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
