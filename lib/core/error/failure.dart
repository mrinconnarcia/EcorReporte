abstract class Failure {
  final List properties;

  Failure([this.properties = const <dynamic>[]]);
}

class ServerFailure extends Failure {}

class CacheFailure extends Failure {}
