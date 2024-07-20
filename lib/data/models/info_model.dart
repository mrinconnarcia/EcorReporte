class InfoModel {
  final int id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;

  InfoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'imageUrl': imageUrl,
    };
  }
}
