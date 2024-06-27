class InfoModel {
  final int id;
  final String title;
  final String description;
  final String content;

  InfoModel({required this.id, required this.title, required this.description, required this.content});

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
    );
  }
}
