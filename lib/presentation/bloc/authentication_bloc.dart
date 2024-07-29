import 'package:flutter_bloc/flutter_bloc.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';
import '../../domain/repositories/user_repository.dart';
import '../../utils/secure_storage.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;
  final SecureStorage secureStorage = SecureStorage();

  AuthenticationBloc({required this.userRepository})
      : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is RegisterEvent) {
      yield AuthenticationLoading();
      try {
        final success = await userRepository.register(
            event.user.name,
            event.user.lastName,
            event.user.email,
            event.password,
            event.user.role,
            event.user.gender,
            event.user.phone,
            event.user.code);
        // String token = success['token'];
        // await secureStorage.saveToken(token);
        yield AuthenticationSuccess2();
      } catch (error) {
        yield AuthenticationFailure(
            message: 'Error al registrar. Por favor, inténtelo de nuevo.');
      }
    } else if (event is LoginEvent) {
      yield AuthenticationLoading();
      try {
        final response =
            await userRepository.login(event.email, event.password);
        if (response['user'] != null && response['token'] != null) {
          final user = response['user'];
          final token = response['token'];

          // Save the token
          await secureStorage.saveToken(token);
          await secureStorage.saveUserData(user);

          yield AuthenticationSuccess(user: user);
        } else {
          yield AuthenticationFailure(
              message:
                  'Error al iniciar sesión. Por favor, inténtelo de nuevo.');
        }
      } catch (error) {
        yield AuthenticationFailure(
            message: 'Error al iniciar sesión. Por favor, inténtelo de nuevo.');
      }
    } else if (event is LoggedOut) {
      yield AuthenticationLoading();
      await SecureStorage().deleteUserInfo();
      yield AuthenticationUnauthenticated();
    }
  }
}
