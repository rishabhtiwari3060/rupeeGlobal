import 'dart:convert';

MarketIndexDetailModel marketIndexDetailModelFromJson(String str) => 
    MarketIndexDetailModel.fromJson(json.decode(str));

String marketIndexDetailModelToJson(MarketIndexDetailModel data) => 
    json.encode(data.toJson());

class MarketIndexDetailModel {
  bool success;
  String message;
  MarketIndexDetail data;

  MarketIndexDetailModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MarketIndexDetailModel.fromJson(Map<String, dynamic> json) => MarketIndexDetailModel(
    success: json["success"] ?? false,
    message: json["message"] ?? "",
    data: MarketIndexDetail.fromJson(json["data"] ?? {}),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data.toJson(),
  };
}

class MarketIndexDetail {
  String name;
  String symbol;
  double price;
  double change;
  double changePercent;
  double open;
  double high;
  double low;
  double previousClose;

  MarketIndexDetail({
    required this.name,
    required this.symbol,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.open,
    required this.high,
    required this.low,
    required this.previousClose,
  });

  factory MarketIndexDetail.fromJson(Map<String, dynamic> json) => MarketIndexDetail(
    name: json["name"] ?? "",
    symbol: json["symbol"] ?? "",
    price: (json["price"] ?? 0).toDouble(),
    change: (json["change"] ?? 0).toDouble(),
    changePercent: (json["change_percent"] ?? 0).toDouble(),
    open: (json["open"] ?? 0).toDouble(),
    high: (json["high"] ?? 0).toDouble(),
    low: (json["low"] ?? 0).toDouble(),
    previousClose: (json["previous_close"] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "symbol": symbol,
    "price": price,
    "change": change,
    "change_percent": changePercent,
    "open": open,
    "high": high,
    "low": low,
    "previous_close": previousClose,
  };
}
