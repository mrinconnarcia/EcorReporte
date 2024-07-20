import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String _token = '';
  String _role = '';
  String _code = '';

  String get token => _token;
  String get role => _role;
  String get code => _code;

  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  void setRole(String role) {
    _role = role;
    notifyListeners();
  }

  void setCode(String code) {
    _code = code;
    notifyListeners();
  }

  void logout() {
    _token = '';
    _role = '';
    _code = '';
    notifyListeners();
  }
}
