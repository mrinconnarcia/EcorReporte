abstract class UserRepository {
  Future<bool> register(String name, String lastName, String email, String password, String role, String gender, String phone);
  Future<Map<String, dynamic>> login(String email, String password);
}
