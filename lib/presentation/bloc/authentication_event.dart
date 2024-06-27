import 'package:equatable/equatable.dart';

abstract class AuthenticationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthenticationEvent {
  final String email;
  final String password;

  LoginRequested({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class RegisterRequested extends AuthenticationEvent {
  final String name;
  final String email;
  final String password;
  final bool acceptNewsletter;

  RegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.acceptNewsletter,
  });

  @override
  List<Object> get props => [name, email, password, acceptNewsletter];
}
