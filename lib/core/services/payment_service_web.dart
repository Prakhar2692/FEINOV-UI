// ignore: avoid_web_libraries_in_flutter
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
    final options = {
      'key': 'rzp_test_YOUR_KEY_HERE', // MUST BE A VALID KEY
      'amount': (amount * 100).toInt(),
      'name': name,
      'description': description,
      'prefill': {
        'contact': contact,
        'email': email
      },
      'theme': {
        'color': '#2D4739'
      }
    };

    try {
      // jsify converts the Dart Map to a native JS Object
      final jsOptions = js.JsObject.jsify(options);

      js.context.callMethod('openRazorpayPay', [
        jsOptions,
        // ignore: undefined_function
        js.allowInterop(onSuccess),
        // ignore: undefined_function
        js.allowInterop(onFailure),
      ]);
    } catch (e) {
      // ignore: avoid_print
      print('Razorpay Web Call Error: $e');
      onFailure(e.toString());
    }
  }

  @override
  void clear() {}
}
