import 'package:ecoreporte/domain/entities/community.dart';
import 'package:http/http.dart' as http;
import '../../utils/secure_storage.dart';

class CommunityRepositoryImpl {
  final SecureStorage secureStorage;

  CommunityRepositoryImpl(this.secureStorage);

  Future<bool> createCommunity(CommunityModel community, String token) async {
    final response = await http.post(
      Uri.parse('http://tu-api-url/communities'), // Cambia la URL a tu endpoint
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: community.toJson(),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Error al crear la comunidad');
    }
  }
}
