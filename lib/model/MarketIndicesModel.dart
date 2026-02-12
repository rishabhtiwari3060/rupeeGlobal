import 'dart:convert';

MarketIndicesModel marketIndicesModelFromJson(String str) => MarketIndicesModel.fromJson(json.decode(str));

String marketIndicesModelToJson(MarketIndicesModel data) => json.encode(data.toJson());

class MarketIndicesModel {
  bool success;
  String message;
  List<Datum> data;

  MarketIndicesModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MarketIndicesModel.fromJson(Map<String, dynamic> json) => MarketIndicesModel(
    success: json["success"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String name;
  String symbol;
  double price;
  double change;
  double changePercent;
  double open;
  double high;
  double low;
  double previousClose;

  Datum({
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    symbol: json["symbol"],
    price: json["price"]?.toDouble(),
    change: json["change"]?.toDouble(),
    changePercent: json["change_percent"]?.toDouble(),
    open: json["open"]?.toDouble(),
    high: json["high"]?.toDouble(),
    low: json["low"]?.toDouble(),
    previousClose: json["previous_close"]?.toDouble(),
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
