import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../home/domain/models/product.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required Product product,
    required int quantity,
    String? selectedVariant,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
}
