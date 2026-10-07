import 'payment_service_stub.dart'
    if (dart.library.html) 'payment_service_web.dart'
    if (dart.library.io) 'payment_service_mobile.dart';

abstract class PaymentService {
  factory PaymentService() => getPaymentService();

  void openCheckout({
    required double amount,
    required String name,
    required String description,
    required String email,
    required String contact,
    required Function(String) onSuccess,
    required Function(String) onFailure,
  });

  void clear();
}
