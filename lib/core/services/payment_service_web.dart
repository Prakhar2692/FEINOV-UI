import 'dart:convert';
import 'dart:js' as js;
import 'payment_service.dart';

PaymentService getPaymentService() => PaymentServiceWeb();

class PaymentServiceWeb implements PaymentService {
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
    Map<String, dynamic> options = {
      'key': 'rzp_test_YOUR_KEY_HERE',
      'amount': (amount * 100).toInt(),
      'name': name,
      'description': description,
      'prefill': {
        'contact': contact,
        'email': email
      }
    };

    js.context.callMethod('openRazorpayPay', [
      jsonEncode(options),
      js.allowInterop((successResponse) {
        onSuccess(successResponse.toString());
      }),
      js.allowInterop((errorResponse) {
        onFailure(errorResponse.toString());
      }),
    ]);
  }

  @override
  void clear() {
    // No-op for web
  }
}
