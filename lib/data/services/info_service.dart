import 'dart:convert';
import 'package:ecoreporte/data/models/info_model.dart';
import 'package:http/http.dart' as http;

class InfoService {
  final String apiUrl = 'http://localhost:3005/educational-content/all';

  Future<List<InfoModel>> fetchInfo() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => InfoModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load info');
    }
  }
}
