import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/app_providers.dart';

part 'otp_controller.g.dart';

enum OtpStatus { initial, verifying, verified, resending, resent, error }

class OtpState {
  final OtpStatus status;
  final String? errorMessage;

  OtpState({required this.status, this.errorMessage});

  OtpState copyWith({OtpStatus? status, String? errorMessage}) {
    return OtpState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

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
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
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
  OtpState build() {
    return OtpState(status: OtpStatus.initial);
  }

  Future<void> verifyOtp(String otp, {required String mobileNumber}) async {
    state = state.copyWith(status: OtpStatus.verifying);
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.verifyOtp(mobileNumber: mobileNumber, otp: otp);

      state = state.copyWith(status: OtpStatus.verified);
    } catch (e) {
      state = state.copyWith(
        status: OtpStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> resendOtp(String mobileNumber) async {
    state = state.copyWith(status: OtpStatus.resending);
    try {
      final repository = ref.read(authRepositoryProvider);
      await repository.sendOtp(mobileNumber: mobileNumber, countryCode: '+91');
      ref.read(otpTimerProvider.notifier).startTimer();
      state = state.copyWith(status: OtpStatus.resent);
    } catch (e) {
      state = state.copyWith(
        status: OtpStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}
