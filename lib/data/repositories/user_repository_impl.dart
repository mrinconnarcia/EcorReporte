// import 'package:flutter/foundation.dart';
// import 'package:dartz/dartz.dart';

// import '../../domain/entities/user.dart';
// import '../../domain/repositories/user_repository.dart';
// import '../../core/error/failures.dart';
// import '../../core/error/exceptions.dart';
// import '../datasources/remote/remote_data_source.dart';

// class UserRepositoryImpl implements UserRepository {
//   final RemoteDataSource remoteDataSource;

//   UserRepositoryImpl({required this.remoteDataSource});

//   @override
//   Future<Either<Failure, bool>> login(String email, String password) async {
//     try {
//       final result = await remoteDataSource.login(email, password);
//       return Right(result);
//     } on ServerException {
//       return Left(ServerFailure());
//     }
//   }

//   @override
//   Future<Either<Failure, bool>> register(String name, String email, String password, bool acceptNewsletter) async {
//     try {
//       final result = await remoteDataSource.register(name, email, password, acceptNewsletter);
//       return Right(result);
//     } on ServerException {
//       return Left(ServerFailure());
//     }
//   }
// }
