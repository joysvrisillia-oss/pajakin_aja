class PanduanModel {
  final String id;
  final String title;
  final String description;
  final String content;

  PanduanModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
  });

  factory PanduanModel.fromJson(Map<String, dynamic> json) {
    return PanduanModel(
      id: json['id'].toString(),
      title: json['title'] ?? "",
      description: json['description'] ?? "",
      content: json['content'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "content": content,
    };
  }
}
