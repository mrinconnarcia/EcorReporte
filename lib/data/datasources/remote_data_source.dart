// import 'package:http/http.dart' as http;
// import 'dart:convert';

// import '../../../core/error/exceptions.dart';

// abstract class RemoteDataSource {
//   Future<bool> login(String email, String password);
//   Future<bool> register(String name, String email, String password, bool acceptNewsletter);
// }

// class RemoteDataSourceImpl implements RemoteDataSource {
//   final http.Client client;
//   final String baseUrl;

//   RemoteDataSourceImpl({required this.client, required this.baseUrl});

//   @override
//   Future<bool> login(String email, String password) async {
//     final response = await client.post(
//       Uri.parse('$baseUrl/login'),
//       body: json.encode({'email': email, 'password': password}),
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       return true;
//     } else {
//       throw ServerException();
//     }
//   }

//   @override
//   Future<bool> register(String name, String email, String password, bool acceptNewsletter) async {
//     final response = await client.post(
//       Uri.parse('$baseUrl/register'),
//       body: json.encode({'name': name, 'email': email, 'password': password, 'acceptNewsletter': acceptNewsletter}),
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 201) {
//       return true;
//     } else {
//       throw ServerException();
//     }
//   }
// }
