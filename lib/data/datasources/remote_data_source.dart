import '../../domain/entities/user.dart';

abstract class RemoteDataSource {
  Future<User> login(String email, String password);
  Future<User> register(User user);
}
