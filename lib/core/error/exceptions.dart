class AppException implements Exception {
  const AppException(this.message, {this.code = 'app_exception'});

  final String message;
  final String code;

  @override
  String toString() => 'AppException($code): $message';
}

class ServerException extends AppException {
  const ServerException(String message, {String code = 'server_error'})
    : super(message, code: code);
}

class NetworkException extends AppException {
  const NetworkException(String message, {String code = 'network_error'})
    : super(message, code: code);
}

class AuthException extends AppException {
  const AuthException(String message, {String code = 'auth_error'})
    : super(message, code: code);
}

class CacheException extends AppException {
  const CacheException(String message, {String code = 'cache_error'})
    : super(message, code: code);
}

class ValidationException extends AppException {
  const ValidationException(String message, {String code = 'validation_error'})
    : super(message, code: code);
}
