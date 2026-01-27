import 'dart:convert';

NewsModel newsModelFromJson(String str) => NewsModel.fromJson(json.decode(str));

String newsModelToJson(NewsModel data) => json.encode(data.toJson());

class NewsModel {
  bool success;
  String message;
  Data data;

  NewsModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
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
  List<News> news;
  Pagination pagination;

  Data({
    required this.news,
    required this.pagination,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    news: List<News>.from(json["news"].map((x) => News.fromJson(x))),
    pagination: Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "news": List<dynamic>.from(news.map((x) => x.toJson())),
    "pagination": pagination.toJson(),
  };
}

class News {
  String title;
  String description;
  String content;
  String url;
  String urlToImage;
  DateTime publishedAt;
  Source source;

  News({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.source,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
    title: json["title"],
    description: json["description"],
    content: json["content"],
    url: json["url"],
    urlToImage: json["urlToImage"],
    publishedAt: DateTime.parse(json["publishedAt"]),
    source: Source.fromJson(json["source"]),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
    "content": content,
    "url": url,
    "urlToImage": urlToImage,
    "publishedAt": publishedAt.toIso8601String(),
    "source": source.toJson(),
  };
}

class Source {
  String name;

  Source({
    required this.name,
  });

  factory Source.fromJson(Map<String, dynamic> json) => Source(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
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
