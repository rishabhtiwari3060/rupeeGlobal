import 'dart:convert';

PortfolioModel portfolioModelFromJson(String str) => PortfolioModel.fromJson(json.decode(str));

String portfolioModelToJson(PortfolioModel data) => json.encode(data.toJson());

class PortfolioModel {
  bool success;
  String message;
  Data data;

  PortfolioModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory PortfolioModel.fromJson(Map<String, dynamic> json) => PortfolioModel(
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
  ProfitLoss profitLoss;
  Trades trades;
  Funds funds;
  Portfolio portfolio;
  List<Charge> charges;
  int totalCharges;

  Data({
    required this.profitLoss,
    required this.trades,
    required this.funds,
    required this.portfolio,
    required this.charges,
    required this.totalCharges,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    profitLoss: ProfitLoss.fromJson(json["profit_loss"]),
    trades: Trades.fromJson(json["trades"]),
    funds: Funds.fromJson(json["funds"]),
    portfolio: Portfolio.fromJson(json["portfolio"]),
    charges: List<Charge>.from(json["charges"].map((x) => Charge.fromJson(x))),
    totalCharges: json["total_charges"],
  );

  Map<String, dynamic> toJson() => {
    "profit_loss": profitLoss.toJson(),
    "trades": trades.toJson(),
    "funds": funds.toJson(),
    "portfolio": portfolio.toJson(),
    "charges": List<dynamic>.from(charges.map((x) => x.toJson())),
    "total_charges": totalCharges,
  };
}

class Charge {
  int id;
  String chargeType;
  int amount;
  DateTime date;
  String note;

  Charge({
    required this.id,
    required this.chargeType,
    required this.amount,
    required this.date,
    required this.note,
  });

  factory Charge.fromJson(Map<String, dynamic> json) => Charge(
    id: json["id"],
    chargeType: json["charge_type"],
    amount: json["amount"],
    date: DateTime.parse(json["date"]),
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "charge_type": chargeType,
    "amount": amount,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "note": note,
  };
}

class Funds {
  Month today;
  Month week;
  Month month;
  Month year;

  Funds({
    required this.today,
    required this.week,
    required this.month,
    required this.year,
  });

  factory Funds.fromJson(Map<String, dynamic> json) => Funds(
    today: Month.fromJson(json["today"]),
    week: Month.fromJson(json["week"]),
    month: Month.fromJson(json["month"]),
    year: Month.fromJson(json["year"]),
  );

  Map<String, dynamic> toJson() => {
    "today": today.toJson(),
    "week": week.toJson(),
    "month": month.toJson(),
    "year": year.toJson(),
  };
}

class Month {
  int added;
  int withdrawn;

  Month({
    required this.added,
    required this.withdrawn,
  });

  factory Month.fromJson(Map<String, dynamic> json) => Month(
    added: json["added"],
    withdrawn: json["withdrawn"],
  );

  Map<String, dynamic> toJson() => {
    "added": added,
    "withdrawn": withdrawn,
  };
}

class Portfolio {
  int totalInvested;
  int totalValue;
  int totalPnl;
  double pnlPercent;

  Portfolio({
    required this.totalInvested,
    required this.totalValue,
    required this.totalPnl,
    required this.pnlPercent,
  });

  factory Portfolio.fromJson(Map<String, dynamic> json) => Portfolio(
    totalInvested: json["total_invested"],
    totalValue: json["total_value"],
    totalPnl: json["total_pnl"],
    pnlPercent: json["pnl_percent"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "total_invested": totalInvested,
    "total_value": totalValue,
    "total_pnl": totalPnl,
    "pnl_percent": pnlPercent,
  };
}

class ProfitLoss {
  int today;
  int week;
  int month;
  int year;
  int total;

  ProfitLoss({
    required this.today,
    required this.week,
    required this.month,
    required this.year,
    required this.total,
  });

  factory ProfitLoss.fromJson(Map<String, dynamic> json) => ProfitLoss(
    today: json["today"],
    week: json["week"],
    month: json["month"],
    year: json["year"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "today": today,
    "week": week,
    "month": month,
    "year": year,
    "total": total,
  };
}

class Trades {
  int total;
  int winning;
  int losing;
  int winRate;

  Trades({
    required this.total,
    required this.winning,
    required this.losing,
    required this.winRate,
  });

  factory Trades.fromJson(Map<String, dynamic> json) => Trades(
    total: json["total"],
    winning: json["winning"],
    losing: json["losing"],
    winRate: json["win_rate"],
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "winning": winning,
    "losing": losing,
    "win_rate": winRate,
  };
}
