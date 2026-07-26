import 'package:riverpod_annotation/riverpod_annotation.dart';

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
      // Simulate API call for sending OTP
      await Future.delayed(const Duration(seconds: 2));
      
      // On success
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
