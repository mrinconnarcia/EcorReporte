class InfoModel {
  final int id;
  final String title;
  final String description;
  final String content;

  InfoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
  });

  // Método para crear una instancia de InfoModel a partir de un JSON
  factory InfoModel.fromJson(Map<String, dynamic> json) {
    return InfoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      content: json['content'],
    );
  }

  // Método para convertir una instancia de InfoModel a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
    };
  }
}
