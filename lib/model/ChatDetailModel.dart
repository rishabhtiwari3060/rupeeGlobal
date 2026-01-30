import 'dart:convert';

ChatDetailModel chatDetailModelFromJson(String str) => ChatDetailModel.fromJson(json.decode(str));

String chatDetailModelToJson(ChatDetailModel data) => json.encode(data.toJson());

class ChatDetailModel {
  bool success;
  String message;
  Data? data;

  ChatDetailModel({
    required this.success,
    required this.message,
     this.data,
  });

  factory ChatDetailModel.fromJson(Map<String, dynamic> json) => ChatDetailModel(
    success: json["success"],
    message: json["message"],
    data: json["data"] != null
        ? Data.fromJson(json["data"])
        : null,
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  int id;
  String priority;
  String adminStatus;
  String message;
  List<Message> messages;
  DateTime createdAt;
  DateTime updatedAt;

  Data({
    required this.id,
    required this.priority,
    required this.adminStatus,
    required this.message,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    priority: json["priority"],
    adminStatus: json["admin_status"],
    message: json["message"],
    messages: List<Message>.from(json["messages"].map((x) => Message.fromJson(x))),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "priority": priority,
    "admin_status": adminStatus,
    "message": message,
    "messages": List<dynamic>.from(messages.map((x) => x.toJson())),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Message {
  int id;
  String message;
  bool isAdmin;
  String userName;
  DateTime createdAt;

  Message({
    required this.id,
    required this.message,
    required this.isAdmin,
    required this.userName,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    id: json["id"],
    message: json["message"],
    isAdmin: json["is_admin"],
    userName: json["user_name"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "message": message,
    "is_admin": isAdmin,
    "user_name": userName,
    "created_at": createdAt.toIso8601String(),
  };
}
