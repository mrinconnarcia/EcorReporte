import '../../domain/entities/user.dart';

abstract class AuthenticationEvent {}

class RegisterEvent extends AuthenticationEvent {
  final User user;
  final String password;

  RegisterEvent(this.user, this.password);
}

class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}
