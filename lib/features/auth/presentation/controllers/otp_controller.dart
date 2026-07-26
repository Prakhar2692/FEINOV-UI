import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'otp_controller.g.dart';

@riverpod
class OtpTimer extends _$OtpTimer {
  Timer? _timer;
  
  @override
  int build() {
    ref.onDispose(() => _timer?.cancel());
    return 0;
  }

  void startTimer() {
    state = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 60), (timer) {
      if (state > 0) {
        state--;
      } else {
        timer.cancel();
      }
    });
  }
}

@riverpod
class OtpVerificationController extends _$OtpVerificationController {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> verifyOtp(String otp) async {
    state = const AsyncValue.loading();
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      if (otp == '123456') {
        state = const AsyncValue.data(null);
      } else {
        throw Exception('Invalid OTP. Try 123456');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> resendOtp(String mobileNumber) async {
    state = const AsyncValue.loading();
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      ref.read(otpTimerProvider.notifier).startTimer();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
