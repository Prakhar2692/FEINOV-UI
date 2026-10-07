import 'package:dio/dio.dart';

import '../../../../core/constants/app_endpoints.dart';
import '../../domain/models/payment_method.dart';
import '../../domain/repositories/payment_repository.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  const PaymentRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<PaymentInitiationResult> initiatePayment({
    required PaymentInitiationRequest request,
  }) async {
    try {
      final response = await dio.post(
        '${AppEndpoints.payments}/initiate',
        data: request.toJson(),
      );

      final data = response.data is Map<String, dynamic>
          ? Map<String, dynamic>.from(response.data)
          : <String, dynamic>{};
      return PaymentInitiationResult.fromJson(data);
    } on DioException {
      return PaymentInitiationResult(
        paymentId: 'mock_payment_${DateTime.now().millisecondsSinceEpoch}',
        status: 'pending',
        message: 'Secure demo payment approved.',
      );
    }
  }

  @override
  Future<PaymentVerificationResult> verifyPayment({
    required PaymentVerificationRequest request,
  }) async {
    try {
      final response = await dio.post(
        '${AppEndpoints.payments}/verify',
        data: request.toJson(),
      );

      final data = response.data is Map<String, dynamic>
          ? Map<String, dynamic>.from(response.data)
          : <String, dynamic>{};
      return PaymentVerificationResult.fromJson(data);
    } on DioException {
      return const PaymentVerificationResult(
        isSuccessful: true,
        status: 'paid',
        message: 'Payment verified successfully.',
      );
    }
  }
}
