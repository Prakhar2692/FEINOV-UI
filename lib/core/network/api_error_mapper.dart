import 'package:dio/dio.dart';

import '../error/exceptions.dart';
import '../error/failures.dart';

class ApiErrorMapper {
  const ApiErrorMapper();

  Failure fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return const NetworkFailure();
      case DioExceptionType.badResponse:
        final response = exception.response;
        final statusCode = response?.statusCode ?? 0;
        final serverMessage = response?.data is Map
            ? (response?.data['message'] as String?) ?? 'Request failed'
            : 'Request failed';

        if (statusCode == 401 || statusCode == 403) {
          return AuthFailure(serverMessage);
        }

        if (statusCode >= 500) {
          return ServerFailure(serverMessage);
        }

        return ServerFailure(serverMessage);
      case DioExceptionType.cancel:
        return const NetworkFailure();
      case DioExceptionType.connectionError:
        return const NetworkFailure();
      case DioExceptionType.unknown:
        return const NetworkFailure();
      default:
        return const ServerFailure('Unexpected server error');
    }
  }

  Failure fromException(Object exception, [StackTrace? stackTrace]) {
    if (exception is DioException) {
      return fromDioException(exception);
    }

    if (exception is AppException) {
      return exception is AuthException
          ? AuthFailure(exception.message)
          : exception is ValidationException
          ? ValidationFailure(exception.message)
          : exception is CacheException
          ? CacheFailure(exception.message)
          : ServerFailure(exception.message);
    }

    return ServerFailure(exception.toString());
  }
}
