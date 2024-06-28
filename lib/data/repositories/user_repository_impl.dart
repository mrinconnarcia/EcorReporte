import 'package:dartz/dartz.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/remote_data_source.dart';
import '../../core/error/failure.dart';

class UserRepositoryImpl implements UserRepository {
  final RemoteDataSource remoteDataSource;

  UserRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final user = await remoteDataSource.login(email, password);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, User>> register(User user, String password) async {
    try {
      final registeredUser = await remoteDataSource.register(user, password);
      return Right(registeredUser);
    } catch (e) {
      return Left(ServerFailure());
    }
  }
}
