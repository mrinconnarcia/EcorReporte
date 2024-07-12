import '../../domain/entities/user.dart';

abstract class AuthenticationEvent {}

class RegisterEvent extends AuthenticationEvent {
  final User user;
  final String password;
  final String code;

  RegisterEvent(this.user, this.password, this.code);
}

class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);
}

class LoggedOut extends AuthenticationEvent {}
