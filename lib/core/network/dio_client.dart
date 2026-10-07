import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../constants/app_endpoints.dart';
import '../error/exceptions.dart';
import '../state/app_settings.dart';

part 'dio_client.g.dart';

@riverpod
Dio dio(DioRef ref) {
  final sessionService = ref.watch(sessionServiceProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: AppEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await sessionService.getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await sessionService.clear();
          throw const AuthException('Session expired. Please sign in again.');
        }
        handler.next(error);
      },
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) async {
        final options = error.requestOptions;
        final retryCount = (options.extra['retry_count'] as int?) ?? 0;
        final shouldRetry =
            error.type == DioExceptionType.connectionError ||
            error.type == DioExceptionType.receiveTimeout ||
            (error.response?.statusCode != null &&
                error.response!.statusCode! >= 500);

        if (shouldRetry && retryCount < 2) {
          options.extra['retry_count'] = retryCount + 1;
          final retryResponse = await dio.fetch(options);
          return handler.resolve(retryResponse);
        }

        return handler.next(error);
      },
    ),
  );

  dio.interceptors.add(
    LogInterceptor(
      requestBody: true,
      responseBody: true,
      requestHeader: true,
      responseHeader: false,
    ),
  );

  return dio;
}
