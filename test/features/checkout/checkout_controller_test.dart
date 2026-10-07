import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:feinov_ui/core/di/app_providers.dart';
import 'package:feinov_ui/features/checkout/domain/repositories/checkout_repository.dart';
import 'package:feinov_ui/features/checkout/presentation/controllers/checkout_controller.dart';
import 'package:feinov_ui/features/profile/domain/models/address.dart';

class _FakeCheckoutRepository implements CheckoutRepository {
  @override
  Future<Map<String, dynamic>> createCheckoutSession({
    required Map<String, dynamic> payload,
  }) async {
    return {'sessionId': 'session_123'};
  }

  @override
  Future<Map<String, dynamic>> placeOrder({
    required Map<String, dynamic> payload,
  }) async {
    return {'status': 'success', 'orderId': 'ord_123'};
  }

  @override
  Future<Map<String, dynamic>> getShippingMethods() async {
    return {
      'methods': ['express', 'standard'],
    };
  }
}

void main() {
  test(
    'checkout controller stores selected address and payment method',
    () async {
      final container = ProviderContainer(
        overrides: [
          checkoutRepositoryProvider.overrideWithValue(
            _FakeCheckoutRepository(),
          ),
        ],
      );

      final controller = container.read(checkoutControllerProvider.notifier);
      final address = Address(
        id: 'addr_1',
        name: 'Aditi',
        phoneNumber: '9876543210',
        addressLine1: '12 Green Lane',
        city: 'Bengaluru',
        state: 'Karnataka',
        zipCode: '560001',
        country: 'India',
        label: 'Home',
      );

      controller.selectAddress(address);
      controller.selectPaymentMethod(PaymentMethod.creditCard);

      expect(
        container.read(checkoutControllerProvider).selectedAddress,
        address,
      );
      expect(
        container.read(checkoutControllerProvider).selectedPaymentMethod,
        PaymentMethod.creditCard,
      );
    },
  );

  test('placeOrder succeeds when an address is selected', () async {
    final container = ProviderContainer(
      overrides: [
        checkoutRepositoryProvider.overrideWithValue(_FakeCheckoutRepository()),
      ],
    );

    final controller = container.read(checkoutControllerProvider.notifier);
    final address = Address(
      id: 'addr_2',
      name: 'Aditi',
      phoneNumber: '9876543210',
      addressLine1: '45 Blossom Street',
      city: 'Mumbai',
      state: 'Maharashtra',
      zipCode: '400001',
      country: 'India',
      label: 'Office',
    );

    controller.selectAddress(address);
    final didPlaceOrder = await controller.placeOrder();

    expect(didPlaceOrder, isTrue);
    expect(container.read(checkoutControllerProvider).isPlacingOrder, isFalse);
  });
}
