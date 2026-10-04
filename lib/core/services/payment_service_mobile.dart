import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'payment_service.dart';

PaymentService getPaymentService() => PaymentServiceMobile();

class PaymentServiceMobile implements PaymentService {
  final Razorpay _razorpay = Razorpay();
  late Function(String) _onSuccess;
  late Function(String) _onFailure;

  PaymentServiceMobile() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void openCheckout({
    required double amount,
    required String name,
    required String description,
    required String email,
    required String contact,
    required Function(String) onSuccess,
    required Function(String) onFailure,
  }) {
    _onSuccess = onSuccess;
    _onFailure = onFailure;

    var options = {
      'key': 'rzp_test_YOUR_KEY_HERE',
      'amount': (amount * 100).toInt(),
      'name': name,
      'description': description,
      'prefill': {'contact': contact, 'email': email},
      'external': {
        'wallets': ['paytm']
      }
    };

    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _onSuccess(response.paymentId ?? '');
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _onFailure(response.message ?? 'Payment Failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _onSuccess('External Wallet: ${response.walletName}');
  }

  @override
  void clear() {
    _razorpay.clear();
  }
}
