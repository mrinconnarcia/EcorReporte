import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  @override
  Future<bool> register(String name, String lastName, String email, String password, String role, String gender, String phone) async {
    final response = await http.post(
      Uri.parse('https://gjhmw1vf-3001.use.devtunnels.ms/user/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'lastName': lastName,
        'email': email,
        'password': password,
        'role': role,
        'gender': gender,
        'phone' : phone
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://gjhmw1vf-3001.use.devtunnels.ms/login/auth'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    print('Login response: ${response.statusCode} ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print('Login error: ${response.statusCode} ${response.body}');
      throw Exception('Failed to login: ${response.body}');
      // throw Exception('Failed to login');
    }
  }
}
