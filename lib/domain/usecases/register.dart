// import 'package:dartz/dartz.dart';
// import '../../core/error/failures.dart';
// import '../../core/usecase/usecase.dart';
// import '../repositories/user_repository.dart';

// class Register implements UseCase<bool, RegisterParams> {
//   final UserRepository repository;

//   Register(this.repository);

//   @override
//   Future<Either<Failure, bool>> call(RegisterParams params) async {
//     return await repository.register(params.name, params.email, params.password, params.acceptNewsletter);
//   }
// }

// class RegisterParams {
//   final String name;
//   final String email;
//   final String password;
//   final bool acceptNewsletter;

//   RegisterParams({required this.name, required this.email, required this.password, required this.acceptNewsletter});
// }
