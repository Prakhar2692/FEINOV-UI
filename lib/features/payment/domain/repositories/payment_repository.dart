import '../models/payment_method.dart';

abstract class PaymentRepository {
  Future<PaymentInitiationResult> initiatePayment({
    required PaymentInitiationRequest request,
  });

  Future<PaymentVerificationResult> verifyPayment({
    required PaymentVerificationRequest request,
  });
}
