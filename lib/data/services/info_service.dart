import 'dart:convert';
import 'package:ecoreporte/data/models/info_model.dart';
import 'package:http/http.dart' as http;

class InfoService {
  final String apiUrl = 'https://gjhmw1vf-3005.use.devtunnels.ms/educational-content/all';

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
