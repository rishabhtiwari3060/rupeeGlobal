
import 'dart:convert';

TicketModel ticketModelFromJson(String str) => TicketModel.fromJson(json.decode(str));

String ticketModelToJson(TicketModel data) => json.encode(data.toJson());

class TicketModel {
  bool success;
  String message;
  Data data;

  TicketModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
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
  List<Ticket> tickets;
  Pagination pagination;

  Data({
    required this.tickets,
    required this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    tickets: List<Ticket>.from(json["tickets"].map((x) => Ticket.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "tickets": List<dynamic>.from(tickets.map((x) => x.toJson())),
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

class Ticket {
  int id;
  String priority;
  String adminStatus;
  String message;
  int messagesCount;
  String createdAt;
  DateTime updatedAt;

  Ticket({
    required this.id,
    required this.priority,
    required this.adminStatus,
    required this.message,
    required this.messagesCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) => Ticket(
    id: json["id"],
    priority: json["priority"],
    adminStatus: json["admin_status"],
    message: json["message"],
    messagesCount: json["messages_count"],
    createdAt: json["created_at"].toString(),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "priority": priority,
    "admin_status": adminStatus,
    "message": message,
    "messages_count": messagesCount,
    "created_at": createdAt,
    "updated_at": updatedAt.toIso8601String(),
  };
}
