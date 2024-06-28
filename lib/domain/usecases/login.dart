import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';
import '../../core/error/failure.dart';

class Login {
  final UserRepository repository;

  Login(this.repository);

  Future<Either<Failure, User>> call(String email, String password) async {
    return await repository.login(email, password);
  }
}
