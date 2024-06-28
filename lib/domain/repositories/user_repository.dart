import 'package:dartz/dartz.dart';
import '../../../core/error/failure.dart';
import '../../domain/entities/user.dart';


abstract class UserRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(User user, String password);
}
