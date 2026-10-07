import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_endpoints.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/state/app_settings.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_repository_impl.g.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.dio, required this.sessionService});

  final Dio dio;
  final SessionService sessionService;

  @override
  Future<bool> isAuthenticated() async {
    final token = await sessionService.getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> login({required String email, required String password}) async {
    try {
      final response = await dio.post(
        AppEndpoints.authLogin,
        data: {'email': email, 'password': password},
      );

      final token =
          response.data['token']?.toString() ??
          response.data['access_token']?.toString();

      if (token != null && token.isNotEmpty) {
        await sessionService.saveToken(token);
        return;
      }

      throw const ServerException('Login response did not include a token');
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw const AuthException('Invalid email or password.');
      }
      throw const NetworkException(
        'Unable to reach the authentication server.',
      );
    } catch (_) {
      throw const ServerException('Unexpected sign-in error');
    }
  }

  @override
  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String mobileNumber,
    required String countryCode,
  }) async {
    try {
      final response = await dio.post(
        AppEndpoints.authRegister,
        data: {
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'mobileNumber': mobileNumber,
          'countryCode': countryCode,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return;
      }

      throw const ServerException('Unable to register account');
    } on DioException catch (_) {
      throw const NetworkException('Unable to complete registration.');
    }
  }

  @override
  Future<void> sendOtp({
    required String mobileNumber,
    String countryCode = '+91',
  }) async {
    try {
      await dio.post(
        '/auth/send-otp',
        data: {'mobileNumber': mobileNumber, 'countryCode': countryCode},
      );
    } on DioException catch (_) {
      throw const NetworkException('Unable to send OTP.');
    }
  }

  @override
  Future<void> verifyOtp({
    required String mobileNumber,
    required String otp,
  }) async {
    try {
      final response = await dio.post(
        AppEndpoints.authVerifyOtp,
        data: {'mobileNumber': mobileNumber, 'otp': otp},
      );

      final token =
          response.data['token']?.toString() ??
          response.data['access_token']?.toString();
      if (token != null && token.isNotEmpty) {
        await sessionService.saveToken(token);
        return;
      }

      throw const ServerException('OTP verification did not return a token');
    } on DioException catch (_) {
      throw const AuthException('The OTP is invalid or expired.');
    }
  }

  @override
  Future<void> logout() async {
    await sessionService.clear();
  }
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(
    dio: ref.watch(dioProvider),
    sessionService: ref.watch(sessionServiceProvider),
  );
}
