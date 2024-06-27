// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../domain/usecases/login.dart';
// import '../../../domain/usecases/register.dart';
// import 'authentication_event.dart';
// import 'authentication_state.dart';

// class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
//   final Login login;
//   final Register register;

//   AuthenticationBloc({required this.login, required this.register}) : super(AuthenticationInitial()) {
//     on<LoginRequested>((event, emit) async {
//       emit(AuthenticationLoading());
//       final result = await login(LoginParams(email: event.email, password: event.password));
//       result.fold(
//         (failure) => emit(AuthenticationFailure()),
//         (success) => emit(AuthenticationAuthenticated()),
//       );
//     });

//     on<RegisterRequested>((event, emit) async {
//       emit(AuthenticationLoading());
//       final result = await register(RegisterParams(
//         name: event.name,
//         email: event.email,
//         password: event.password,
//         acceptNewsletter: event.acceptNewsletter,
//       ));
//       result.fold(
//         (failure) => emit(AuthenticationFailure()),
//         (success) => emit(AuthenticationAuthenticated()),
//       );
//     });
//   }
// }
