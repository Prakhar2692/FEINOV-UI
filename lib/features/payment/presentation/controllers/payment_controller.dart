import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'payment_controller.g.dart';

enum PaymentStatus { initial, loading, success, failure, cancelled }

class PaymentState {
  final PaymentStatus status;
  final String? message;
  final String? paymentId;

  PaymentState({
    required this.status,
    this.message,
    this.paymentId,
  });

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
  late Razorpay _razorpay;

  @override
  PaymentState build() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    ref.onDispose(() {
      _razorpay.clear();
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

    var options = {
      'key': 'rzp_test_YOUR_KEY_HERE', // Replace with actual key
      'amount': (amount * 100).toInt(), // in paise
      'name': name,
      'description': description,
      'prefill': {'contact': contact, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      state = state.copyWith(
        status: PaymentStatus.failure,
        message: e.toString(),
      );
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    state = state.copyWith(
      status: PaymentStatus.success,
      paymentId: response.paymentId,
      message: 'Payment Successful',
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    if (response.code == Razorpay.PAYMENT_CANCELLED) {
      state = state.copyWith(
        status: PaymentStatus.cancelled,
        message: 'Payment Cancelled',
      );
    } else {
      state = state.copyWith(
        status: PaymentStatus.failure,
        message: response.message ?? 'Payment Failed',
      );
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    state = state.copyWith(
      status: PaymentStatus.success,
      message: 'External Wallet Selected: ${response.walletName}',
    );
  }
  
  void reset() {
    state = PaymentState.initial();
  }
}
