import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/app_providers.dart';
import '../../domain/models/cart_item.dart';
import '../../../home/domain/models/product.dart';

part 'cart_controller.g.dart';

@riverpod
class CartController extends _$CartController {
  @override
  FutureOr<List<CartItem>> build() async {
    return _fetchCart();
  }

  Future<List<CartItem>> _fetchCart() async {
    final repository = ref.read(cartRepositoryProvider);
    final items = await repository.getCartItems();
    return items.map(CartItem.fromJson).toList();
  }

  Future<void> addItem(Product product) async {
    final repository = ref.read(cartRepositoryProvider);
    final currentItems = state.value ?? [];
    final existingIndex = currentItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      await updateQuantity(
        currentItems[existingIndex].id,
        currentItems[existingIndex].quantity + 1,
      );
    } else {
      await repository.addItem(productId: product.id, quantity: 1);
      state = AsyncValue.data([...currentItems, ...await _fetchCart()]);
    }
  }

  Future<void> updateQuantity(String itemId, int quantity) async {
    final repository = ref.read(cartRepositoryProvider);
    final currentItems = state.value ?? [];
    if (quantity <= 0) {
      await repository.removeItem(itemId);
      state = AsyncValue.data(
        currentItems.where((item) => item.id != itemId).toList(),
      );
      return;
    }

    await repository.updateItem(itemId: itemId, quantity: quantity);
    final updatedItems = currentItems.map((item) {
      if (itemId == item.id) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();

    state = AsyncValue.data(updatedItems);
  }

  Future<void> updateProductQuantity(Product product, int quantity) async {
    final currentItems = state.value ?? [];
    final existingItem = currentItems
        .where((item) => item.product.id == product.id)
        .firstOrNull;

    if (existingItem != null) {
      await updateQuantity(existingItem.id, quantity);
    } else if (quantity > 0) {
      await addItem(product);
    }
  }

  Future<void> removeItem(String itemId) async {
    final repository = ref.read(cartRepositoryProvider);
    await repository.removeItem(itemId);
    final currentItems = state.value ?? [];
    state = AsyncValue.data(
      currentItems.where((item) => item.id != itemId).toList(),
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchCart());
  }

  double get subtotal {
    final items = state.value ?? [];
    return items.fold(
      0,
      (total, item) => total + (item.product.price * item.quantity),
    );
  }

  double get total => subtotal + 5.0;

  int getProductQuantity(String productId) {
    final items = state.value ?? [];
    final item = items.where((i) => i.product.id == productId).firstOrNull;
    return item?.quantity ?? 0;
  }
}
