import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final storage = FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await storage.write(key: 'auth_token', value: token);
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await storage.write(key: 'user_data', value: jsonEncode(userData));
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final userDataString = await storage.read(key: 'user_data');
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  Future<void> deleteUserInfo() async {
    await storage.delete(key: 'auth_token');
    await storage.delete(key: 'user_data');
  }
}
