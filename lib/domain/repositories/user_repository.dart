abstract class UserRepository {
  Future<bool> register(String name, String email, String password, String role);
  Future<Map<String, dynamic>> login(String email, String password);
}
