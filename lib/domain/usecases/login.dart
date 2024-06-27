// import 'package:dartz/dartz.dart';
// import '../../core/error/failures.dart';
// import '../../core/usecase/usecase.dart';
// import '../repositories/user_repository.dart';

// class Login implements UseCase<bool, LoginParams> {
//   final UserRepository repository;

//   Login(this.repository);

//   @override
//   Future<Either<Failure, bool>> call(LoginParams params) async {
//     return await repository.login(params.email, params.password);
//   }
// }

// class LoginParams {
//   final String email;
//   final String password;

//   LoginParams({required this.email, required this.password});
// }
