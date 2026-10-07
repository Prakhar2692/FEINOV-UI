import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/services/payment_service.dart';

part 'payment_controller.g.dart';

enum PaymentStatus {
  initial,
  loading,
  success,
  failure,
  cancelled,
  timeout,
  declined,
}

class PaymentState {
  final PaymentStatus status;
  final String? message;
  final String? paymentId;

  PaymentState({required this.status, this.message, this.paymentId});

  factory PaymentState.initial() => PaymentState(status: PaymentStatus.initial);

  PaymentState copyWith({
    PaymentStatus? status,
    String? message,
    String? paymentId,
  }) {
    return PaymentState(
      status: status ?? this.status,
      message: message ?? this.message,
      paymentId: paymentId ?? this.paymentId,
    );
  }
}

@riverpod
class PaymentController extends _$PaymentController {
  late PaymentService _paymentService;

  @override
  PaymentState build() {
    _paymentService = PaymentService();

    ref.onDispose(() {
      _paymentService.clear();
    });

    return PaymentState.initial();
  }

  void startPayment({
    required double amount,
    required String name,
    required String description,
    required String email,
    required String contact,
  }) {
    state = state.copyWith(status: PaymentStatus.loading);

    _paymentService.openCheckout(
      amount: amount,
      name: name,
      description: description,
      email: email,
      contact: contact,
      onSuccess: (paymentId) {
        state = state.copyWith(
          status: PaymentStatus.success,
          paymentId: paymentId,
          message: 'Payment Successful',
        );
      },
      onFailure: (message) {
        final normalized = message.toLowerCase();
        if (normalized.contains('cancel') || normalized.contains('aborted')) {
          state = state.copyWith(
            status: PaymentStatus.cancelled,
            message: 'Payment Cancelled',
          );
        } else if (normalized.contains('declined') ||
            normalized.contains('card')) {
          state = state.copyWith(
            status: PaymentStatus.declined,
            message: 'Card declined. Please try another method.',
          );
        } else if (normalized.contains('timeout') ||
            normalized.contains('timed out')) {
          state = state.copyWith(
            status: PaymentStatus.timeout,
            message: 'Payment timed out. Please retry.',
          );
        } else {
          state = state.copyWith(
            status: PaymentStatus.failure,
            message: message,
          );
        }
      },
    );
  }

  void reset() {
    state = PaymentState.initial();
  }
}
