import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/app_providers.dart';

part 'login_controller.g.dart';

@riverpod
class LoginController extends _$LoginController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> sendOtp({
    required String countryCode,
    required String mobileNumber,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.sendOtp(
        countryCode: countryCode,
        mobileNumber: mobileNumber,
      );

      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
