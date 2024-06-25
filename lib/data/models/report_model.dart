import 'dart:convert';

import 'package:ecoreporte/domain/entities/report.dart';

class ReportModel extends Report {
  ReportModel({
    required String title,
    required String description,
  }) : super(title: title, description: description);

  factory ReportModel.fromJson(String jsonString) {
    final jsonData = json.decode(jsonString);
    return ReportModel(
      title: jsonData['title'],
      description: jsonData['description'],
    );
  }

  String toJson() {
    final jsonData = {
      'title': title,
      'description': description,
    };
    return json.encode(jsonData);
  }
}
