import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_controller.g.dart';

@riverpod
class RegisterController extends _$RegisterController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> register({
    required String username,
    required String email,
    required String countryCode,
    required String mobileNumber,
  }) async {
    state = const AsyncValue.loading();
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // On success
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
