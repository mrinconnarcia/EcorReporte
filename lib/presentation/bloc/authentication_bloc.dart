import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import '../../domain/repositories/user_repository.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({required this.userRepository}) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if (event is RegisterEvent) {
      yield AuthenticationLoading();
      try {
        final success = await userRepository.register(
          event.user.name,
          event.user.email,
          event.password,
          event.user.role,
        );
        if (success) {
          yield AuthenticationSuccess();
        } else {
          yield AuthenticationFailure(message: 'Error al registrar. Por favor, inténtelo de nuevo.');
        }
      } catch (error) {
        yield AuthenticationFailure(message: 'Error al registrar. Por favor, inténtelo de nuevo.');
      }
    } else if (event is LoginEvent) {
      yield AuthenticationLoading();
      try {
        final response = await userRepository.login(event.email, event.password);
        if (response['status'] == 'success') {
          yield AuthenticationSuccess();
        } else {
          yield AuthenticationFailure(message: 'Error al iniciar sesión. Por favor, inténtelo de nuevo.');
        }
      } catch (error) {
        yield AuthenticationFailure(message: 'Error al iniciar sesión. Por favor, inténtelo de nuevo.');
      }
    }
  }
}
