import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/models/address.dart';

part 'address_controller.g.dart';

@riverpod
class AddressController extends _$AddressController {
  @override
  FutureOr<List<Address>> build() async {
    return _fetchAddresses();
  }

  Future<List<Address>> _fetchAddresses() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    return [
      const Address(
        id: '1',
        name: 'John Doe',
        phoneNumber: '+91 9876543210',
        addressLine1: '123, Luxury Lane',
        addressLine2: 'Greens',
        landmark: 'Near Central Park',
        city: 'Mumbai',
        state: 'Maharashtra',
        zipCode: '400001',
        country: 'India',
        isDefault: true,
        label: 'Home',
      ),
      const Address(
        id: '2',
        name: 'John Doe',
        phoneNumber: '+91 9876543210',
        addressLine1: '456, Corporate Tower',
        addressLine2: 'Business Bay',
        city: 'Bangalore',
        state: 'Karnataka',
        zipCode: '560001',
        country: 'India',
        isDefault: false,
        label: 'Office',
      ),
    ];
  }

  Future<void> setDefault(String id) async {
    final currentAddresses = state.value ?? [];
    final updated = currentAddresses.map((a) {
      return a.copyWith(isDefault: a.id == id);
    }).toList();
    state = AsyncValue.data(updated);
  }

  Future<void> removeAddress(String id) async {
    final currentAddresses = state.value ?? [];
    state = AsyncValue.data(currentAddresses.where((a) => a.id != id).toList());
  }

  Future<void> addAddress(Address address) async {
    final currentAddresses = state.value ?? [];
    if (address.isDefault) {
      final updated = currentAddresses.map((a) => a.copyWith(isDefault: false)).toList();
      state = AsyncValue.data([...updated, address]);
    } else {
      state = AsyncValue.data([...currentAddresses, address]);
    }
  }
}
