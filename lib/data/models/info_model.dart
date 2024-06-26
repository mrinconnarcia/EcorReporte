class InfoModel {
  final String title;
  final String description;
  final String content;

  InfoModel({required this.title, required this.description, required this.content});

  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      title: json['title'],
      description: json['description'],
      content: json['content'],
    );
  }
}
