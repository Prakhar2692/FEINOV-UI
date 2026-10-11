import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/app_providers.dart';
import '../../../../core/error/exceptions.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'register_controller.g.dart';

@riverpod
class RegisterController extends _$RegisterController {
  @override
  AsyncValue<RegisterResult?> build() {
    return const AsyncValue.data(null);
  }

  Future<RegisterResult?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String countryCode,
    required String mobileNumber,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(authRepositoryProvider);
      final result = await repository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        mobileNumber: mobileNumber,
        countryCode: countryCode,
      );

      state = AsyncValue.data(result);
      return result;
    } catch (e, st) {
      final message = e is AppException
          ? e.userMessage
          : (() {
              final raw = e.toString();
              final normalized = raw.toLowerCase();
              if (normalized.contains('socket') ||
                  normalized.contains('connection') ||
                  normalized.contains('timeout') ||
                  normalized.contains('host lookup') ||
                  normalized.contains('network')) {
                return AppStrings.networkError;
              }
              return raw.replaceFirst('Exception: ', '');
            })();

      final result = RegisterResult(
        statusCode: 0,
        user: null,
        message: message,
      );

      state = AsyncValue.data(result);
      return result;
    }
  }
}
