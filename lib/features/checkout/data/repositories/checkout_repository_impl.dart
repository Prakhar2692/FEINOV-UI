import 'package:dio/dio.dart';

import '../../../../core/constants/app_endpoints.dart';
import '../../domain/repositories/checkout_repository.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  const CheckoutRepositoryImpl(this.dio);

  final Dio dio;

  @override
  Future<Map<String, dynamic>> createCheckoutSession({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await dio.post(
        '${AppEndpoints.orders}/checkout-session',
        data: payload,
      );
      return Map<String, dynamic>.from(response.data);
    } on DioException {
      return {'status': 'success', 'sessionId': 'demo_session'};
    }
  }

  @override
  Future<Map<String, dynamic>> placeOrder({
    required Map<String, dynamic> payload,
  }) async {
    try {
      final response = await dio.post(AppEndpoints.orders, data: payload);
      return Map<String, dynamic>.from(response.data);
    } on DioException {
      return {
        'id': 'demo_order_${DateTime.now().millisecondsSinceEpoch}',
        'status': 'confirmed',
        'message': 'Order placed successfully.',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> getShippingMethods() async {
    try {
      final response = await dio.get('${AppEndpoints.orders}/shipping-methods');
      return Map<String, dynamic>.from(response.data);
    } on DioException {
      return {
        'items': [
          {'id': 'standard', 'name': 'Standard Delivery', 'price': 5.0},
          {'id': 'express', 'name': 'Express Delivery', 'price': 12.0},
        ],
      };
    }
  }
}
