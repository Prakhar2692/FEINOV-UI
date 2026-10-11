import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_endpoints.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/services/session_service.dart';
import '../../../../core/state/app_settings.dart';
import '../../data/dtos/auth_dtos.dart';
import '../../domain/entities/user.dart';
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
  Future<User> login({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    try {
      final response = await dio.post(
        AppEndpoints.authLogin,
        data: LoginRequestDto(email: email, password: password).toJson(),
      );

      final dto = AuthResponseDto.fromJson(response.data);
      final token = dto.token;
      final user = User.fromJson(dto.user);

      if (token.isNotEmpty) {
        await sessionService.saveToken(token);
        return user;
      }

      if (user.email.isNotEmpty) {
        await sessionService.saveToken(
          'demo-session-${DateTime.now().millisecondsSinceEpoch}',
        );
        return user;
      }

      throw const ServerException('Login response did not include a token');
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw const AuthException('Invalid email or password.');
      }
      throw const NetworkException(AppStrings.networkError);
    } catch (_) {
      throw const ServerException('Unexpected sign-in error');
    }
  }

  @override
  Future<RegisterResult> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String mobileNumber,
    required String countryCode,
  }) async {
    try {
      final response = await dio.post(
        AppEndpoints.authRegister,
        data: RegisterRequestDto(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
          mobileNumber: mobileNumber,
          countryCode: countryCode,
        ).toJson(),
      );

      final rawData = response.data is Map<String, dynamic>
          ? Map<String, dynamic>.from(response.data)
          : <String, dynamic>{};
      final serverMessage = (rawData['message'] ?? '').toString();
      final userData = rawData['user'] is Map
          ? Map<String, dynamic>.from(rawData['user'] as Map)
          : <String, dynamic>{};

      if (response.statusCode == 200 || response.statusCode == 201) {
        final user = userData.isNotEmpty
            ? User.fromJson(userData)
            : User(
                id: 'local-user',
                email: email,
                name: '$firstName $lastName',
                phoneNumber: mobileNumber,
                isEmailVerified: false,
              );

        return RegisterResult(
          statusCode: response.statusCode ?? 200,
          user: user,
          message: serverMessage.isNotEmpty
              ? serverMessage
              : 'User registered successfully. Verify your mobile number to sign in.',
        );
      }

      return RegisterResult(
        statusCode: response.statusCode ?? 403,
        user: null,
        message: serverMessage.isNotEmpty
            ? serverMessage
            : 'A user with this mobile number is already registered.',
      );
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode ?? 0;
      final responseData = error.response?.data;
      final serverMessage = responseData is Map
          ? (responseData['message'] as String? ?? '')
          : '';

      if (statusCode == 403) {
        return RegisterResult(
          statusCode: 403,
          user: null,
          message: serverMessage.isNotEmpty
              ? serverMessage
              : 'A user with this mobile number is already registered.',
        );
      }

      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        return RegisterResult(
          statusCode: 0,
          user: null,
          message: AppStrings.networkError,
        );
      }

      throw NetworkException(
        serverMessage.isNotEmpty ? serverMessage : AppStrings.networkError,
      );
    }
  }

  @override
  Future<void> sendOtp({
    required String mobileNumber,
    String countryCode = '+91',
  }) async {
    try {
      await dio.post(
        AppEndpoints.authSendOtp,
        data: {
          'mobileNumber': mobileNumber,
          'countryCode': countryCode,
          'purpose': 'login',
        },
      );
    } on DioException catch (_) {
      throw const NetworkException(AppStrings.networkError);
    }
  }

  @override
  Future<User> verifyOtp({
    required String mobileNumber,
    required String otp,
  }) async {
    try {
      final response = await dio.post(
        AppEndpoints.authVerifyOtp,
        data: {'mobileNumber': mobileNumber, 'otp': otp},
      );

      final dto = AuthResponseDto.fromJson(response.data);
      final user = User.fromJson(
        dto.user.isNotEmpty
            ? dto.user
            : {'id': 'otp-user', 'email': '', 'name': 'Customer'},
      );

      if (dto.token.isNotEmpty) {
        await sessionService.saveToken(dto.token);
      }

      return user;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(AppStrings.networkError);
      }
      throw const AuthException('The OTP is invalid or expired.');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await dio.post(
        AppEndpoints.authForgotPassword,
        data: ForgotPasswordRequestDto(email: email).toJson(),
      );
    } on DioException catch (_) {
      throw const NetworkException(AppStrings.networkError);
    }
  }

  @override
  Future<User> verifyEmail({required String email, required String otp}) async {
    try {
      final response = await dio.post(
        AppEndpoints.authVerifyEmail,
        data: VerifyEmailRequestDto(email: email, otp: otp).toJson(),
      );

      final dto = AuthResponseDto.fromJson(response.data);
      final user = User.fromJson(
        dto.user.isNotEmpty
            ? dto.user
            : {'id': 'email-user', 'email': email, 'name': 'Customer'},
      );

      if (dto.token.isNotEmpty) {
        await sessionService.saveToken(dto.token);
      }

      return user;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        throw const NetworkException(AppStrings.networkError);
      }
      throw const AuthException('Email verification failed.');
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    final token = await sessionService.getToken();
    if (token == null || token.isEmpty) return null;

    try {
      final response = await dio.get(AppEndpoints.authSession);
      final data = response.data['user'] ?? response.data;
      return User.fromJson(Map<String, dynamic>.from(data));
    } on DioException {
      return const User(id: 'session-user', email: '', name: 'Session User');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await dio.post(AppEndpoints.authLogout);
    } catch (_) {}
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
