import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SecureStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> deleteToken() async {
    await _storage.delete(key: 'token');
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    await _storage.write(key: 'user_data', value: jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getUserData() async {
    String? userDataString = await _storage.read(key: 'user_data');
    if (userDataString == null) {
      return null;
    }
    return jsonDecode(userDataString);
  }

  Future<void> deleteUserInfo() async {
    await _storage.delete(key: 'user_data');
    await _storage.delete(key: 'token');
  }
}
