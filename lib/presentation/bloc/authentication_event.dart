import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;

  LoginEvent(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class RegisterEvent extends AuthenticationEvent {
  final User user;
  final String password;

  RegisterEvent(this.user, this.password);

  @override
  List<Object> get props => [user, password];
}
