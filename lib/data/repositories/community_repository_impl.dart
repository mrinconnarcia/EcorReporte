import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../utils/secure_storage.dart';

class CommunityRepositoryImpl {
  final SecureStorage secureStorage = SecureStorage(); 

  Future<bool> createCommunity(String name, String code) async {
    String? token = await secureStorage.getToken();
    // print('Token: $token');

    Map<String, dynamic>? userData = await secureStorage.getUserData();

    if (token == null || userData == null || userData['id'] == null) {
      throw Exception('No token or user data found');
    }

    int adminId = userData['id'] is int
        ? userData['id']
        : int.parse(userData['id'].toString());

    final response = await http.post(
      Uri.parse('http://54.225.155.228:3001/api/community/community/create'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({"code": code, "name": name, "id": adminId}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      // print('Error response: ${response.body}');
      // print('Status code: ${response.statusCode}');
      return false;
    }
  }
}
