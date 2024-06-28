import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user.dart';
import 'remote_data_source.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<User> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('http://localhost:3001/login/auth'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return User(
        // id: jsonResponse['id'],
        nombre: jsonResponse['nombre'],
        // apellido: jsonResponse['apellido'],
        email: jsonResponse['email'],
        // genero: jsonResponse['genero'],
        // telefono: jsonResponse['telefono'],
        rol: jsonResponse['rol'],
      );
    } else {
      throw Exception('Failed to login');
    }
  }

  @override
  Future<User> register(User user, String password) async {
    final response = await client.post(
      Uri.parse('http://localhost:3001/user/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'nombre': user.nombre,
        // 'apellido': user.apellido,
        'email': user.email,
        // 'genero': user.genero,
        // 'telefono': user.telefono,
        'rol': user.rol,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return User(
        // id: jsonResponse['id'],
        nombre: jsonResponse['nombre'],
        // apellido: jsonResponse['apellido'],
        email: jsonResponse['email'],
        // genero: jsonResponse['genero'],
        // telefono: jsonResponse['telefono'],
        rol: jsonResponse['rol'],
      );
    } else {
      throw Exception('Failed to register');
    }
  }
}
