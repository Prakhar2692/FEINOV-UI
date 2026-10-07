import 'package:intl/intl.dart';

enum OrderStatus {
  pending,
  confirmed,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
  returned;

  static OrderStatus fromApiValue(String? value) {
    switch ((value ?? '').toLowerCase()) {
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'shipped':
        return OrderStatus.shipped;
      case 'out_for_delivery':
      case 'out for delivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
      case 'canceled':
        return OrderStatus.cancelled;
      case 'returned':
        return OrderStatus.returned;
      case 'pending':
      default:
        return OrderStatus.pending;
    }
  }

  String get label {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.outForDelivery:
        return 'Out for delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
    }
  }
}

class OrderItem {
  const OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.imageUrl,
  });

  final String id;
  final String name;
  final int quantity;
  final double price;
  final String? imageUrl;

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? 'Product').toString(),
      quantity: (json['quantity'] ?? 1) as int? ?? 1,
      price: (json['price'] ?? 0.0).toDouble(),
      imageUrl: json['imageUrl']?.toString(),
    );
  }
}

class Order {
  const Order({
    required this.id,
    required this.createdAt,
    required this.total,
    required this.status,
    required this.items,
    this.shippingAddress,
    this.trackingNumber,
  });

  final String id;
  final DateTime createdAt;
  final double total;
  final OrderStatus status;
  final List<OrderItem> items;
  final String? shippingAddress;
  final String? trackingNumber;

  factory Order.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List? ?? const [])
        .map((item) => OrderItem.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();

    return Order(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      createdAt: DateTime.tryParse((json['createdAt'] ?? json['date'] ?? DateTime.now().toIso8601String()).toString()) ?? DateTime.now(),
      total: (json['total'] ?? json['amount'] ?? 0.0).toDouble(),
      status: OrderStatus.fromApiValue(json['status']?.toString()),
      items: rawItems,
      shippingAddress: json['shippingAddress']?.toString(),
      trackingNumber: json['trackingNumber']?.toString(),
    );
  }

  String get formattedDate => DateFormat('dd MMM yyyy').format(createdAt);
  int get itemCount => items.fold<int>(0, (sum, item) => sum + item.quantity);
}
