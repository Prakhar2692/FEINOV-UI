import 'exceptions.dart';

abstract class Failure {
  const Failure(this.message);

  final String message;
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection'])
    : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache failure']) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure([String message = 'Authentication failed'])
    : super(message);
}

class ValidationFailure extends Failure {
  const ValidationFailure([String message = 'Validation failed'])
    : super(message);
}

class UnknownFailure extends Failure {
  const UnknownFailure([String message = 'Something went wrong'])
    : super(message);
}

class FailureMapper {
  const FailureMapper();

  Failure fromException(Object exception) {
    if (exception is Failure) {
      return exception;
    }

    if (exception is ValidationException) {
      return ValidationFailure(exception.message);
    }

    if (exception is AuthException) {
      return AuthFailure(exception.message);
    }

    if (exception is CacheException) {
      return CacheFailure(exception.message);
    }

    if (exception is NetworkException) {
      return NetworkFailure(exception.message);
    }

    if (exception is ServerException) {
      return ServerFailure(exception.message);
    }

    return UnknownFailure(exception.toString());
  }
}
