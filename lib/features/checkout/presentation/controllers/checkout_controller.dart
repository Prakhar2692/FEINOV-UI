import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../profile/domain/models/address.dart';

part 'checkout_controller.g.dart';

enum PaymentMethod { upi, creditCard, debitCard }

class CheckoutState {
  final Address? selectedAddress;
  final PaymentMethod selectedPaymentMethod;
  final bool isPlacingOrder;

  CheckoutState({
    this.selectedAddress,
    this.selectedPaymentMethod = PaymentMethod.upi,
    this.isPlacingOrder = false,
  });

  CheckoutState copyWith({
    Address? selectedAddress,
    PaymentMethod? selectedPaymentMethod,
    bool? isPlacingOrder,
  }) {
    return CheckoutState(
      selectedAddress: selectedAddress ?? this.selectedAddress,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
    );
  }
}

@riverpod
class CheckoutController extends _$CheckoutController {
  @override
  CheckoutState build() {
    return CheckoutState();
  }

  void selectAddress(Address address) {
    state = state.copyWith(selectedAddress: address);
  }

  void selectPaymentMethod(PaymentMethod method) {
    state = state.copyWith(selectedPaymentMethod: method);
  }

  Future<bool> placeOrder() async {
    if (state.selectedAddress == null) return false;
    
    state = state.copyWith(isPlacingOrder: true);
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    state = state.copyWith(isPlacingOrder: false);
    return true;
  }
}
