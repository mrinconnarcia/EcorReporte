abstract class AuthenticationState {}

class AuthenticationInitial extends AuthenticationState {}

class AuthenticationLoading extends AuthenticationState {}

class AuthenticationSuccess2 extends AuthenticationState {}

class AuthenticationSuccess extends AuthenticationState {
  final Map<String, dynamic> user;

  AuthenticationSuccess({required this.user});
}

class AuthenticationFailure extends AuthenticationState {
  final String message;

  AuthenticationFailure({required this.message});
}

class AuthenticationUnauthenticated extends AuthenticationState {}