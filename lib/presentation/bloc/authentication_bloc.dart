import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/register.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final Login login;
  final Register register;

  AuthenticationBloc({required this.login, required this.register}) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is LoginEvent) {
      yield AuthenticationLoading();
      final result = await login(event.email, event.password);
      yield result.fold(
        (failure) => AuthenticationFailure(message: 'Login Failed'),
        (user) => AuthenticationSuccess(user: user),
      );
    } else if (event is RegisterEvent) {
      yield AuthenticationLoading();
      final result = await register(event.user, event.password);
      yield result.fold(
        (failure) => AuthenticationFailure(message: 'Register Failed'),
        (user) => AuthenticationSuccess(user: user),
      );
    }
  }
}
