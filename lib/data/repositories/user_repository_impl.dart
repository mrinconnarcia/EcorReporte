import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../utils/secure_storage.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final SecureStorage secureStorage = SecureStorage(); // Instancia de SecureStorage

  @override
  Future<bool> register(String name, String lastName, String email, String password, String role, String gender, String phone, String code) async {
    final response = await http.post(
      // Uri.parse('https://gjhmw1vf-3001.use.devtunnels.ms/user/register'),
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
        'phone' : phone,
        'code': code
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

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

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData['user'] != null && responseData['token'] != null) {
        return responseData;
      } else {
        throw Exception('Invalid response format');
      }
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserData() async {
    String? token = await secureStorage.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.get(
      Uri.parse('https://gjhmw1vf-3001.use.devtunnels.ms/user/profile'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<bool> updateUser(Map<String, dynamic> userData) async {
    String? token = await secureStorage.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.put(
      Uri.parse('https://gjhmw1vf-3001.use.devtunnels.ms/user/update-email/${userData['email']}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(userData),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteUser(String email) async {
    String? token = await secureStorage.getToken();
    if (token == null) {
      throw Exception('No token found');
    }

    final response = await http.delete(
      Uri.parse('https://gjhmw1vf-3001.use.devtunnels.ms/user/delete-email/$email'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(<String, String>{ 'email': email }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
