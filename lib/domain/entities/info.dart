class Info {
  final int id;
  final String title;
  final String description;
  final String content;
  final String imageUrl;

  Info({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.imageUrl,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
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
