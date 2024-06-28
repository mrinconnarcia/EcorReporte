import 'package:dartz/dartz.dart';
import '../../core/error/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

class Register {
  final UserRepository repository;

  Register(this.repository);

  Future<Either<Failure, User>> call(User user, String password) async {
    return await repository.register(user, password);
  }
}
