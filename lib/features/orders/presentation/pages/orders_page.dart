import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_top_bar.dart';
import '../../domain/models/order.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final List<Order> _orders = [
    Order(
      id: 'ORD-1024',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      total: 1680.0,
      status: OrderStatus.shipped,
      items: const [
        OrderItem(id: 'i1', name: 'Hydra Glow Serum', quantity: 1, price: 980.0),
        OrderItem(id: 'i2', name: 'Barrier Repair Cream', quantity: 1, price: 700.0),
      ],
      shippingAddress: '24 Residency Road, Bengaluru',
      trackingNumber: 'INTRK74213',
    ),
    Order(
      id: 'ORD-1018',
      createdAt: DateTime.now().subtract(const Duration(days: 11)),
      total: 1299.0,
      status: OrderStatus.delivered,
      items: const [
        OrderItem(id: 'i3', name: 'Vitamin C Dew Mask', quantity: 2, price: 649.5),
      ],
      shippingAddress: '9th Block, Koramangala, Bengaluru',
      trackingNumber: 'INTRK73122',
    ),
    Order(
      id: 'ORD-1009',
      createdAt: DateTime.now().subtract(const Duration(days: 21)),
      total: 890.0,
      status: OrderStatus.pending,
      items: const [
        OrderItem(id: 'i4', name: 'Clean Reset Gel', quantity: 1, price: 890.0),
      ],
      shippingAddress: '14 Lake View Road, Mumbai',
      trackingNumber: null,
    ),
  ];

  OrderStatus? _selectedStatus;

  List<Order> get _filteredOrders {
    return _selectedStatus == null
        ? _orders
        : _orders.where((order) => order.status == _selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filters = [null, ...OrderStatus.values];

    return Scaffold(
      appBar: const AppTopBar(title: 'My Orders', showBackButton: false),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.m),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final value = filters[index];
                final label = value == null ? 'All' : value.label;
                final isSelected = _selectedStatus == value;
                return ChoiceChip(
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() => _selectedStatus = value);
                  },
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s),
              itemCount: filters.length,
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.l),
              itemCount: _filteredOrders.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.m),
              itemBuilder: (context, index) {
                final order = _filteredOrders[index];
                return _OrderCard(order: order);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final color = switch (order.status) {
      OrderStatus.delivered => Colors.green,
      OrderStatus.cancelled => AppColors.error,
      OrderStatus.shipped || OrderStatus.outForDelivery => AppColors.primary,
      _ => Colors.orange,
    };

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order ${order.id}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: 6),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    order.status.label,
                    style: TextStyle(color: color, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order.formattedDate, style: Theme.of(context).textTheme.bodyMedium),
                Text('${order.itemCount} items', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.hint),
                ),
                Text(
                  '₹${order.total.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            if (order.trackingNumber != null) ...[
              const SizedBox(height: AppSpacing.s),
              Text(
                'Tracking: ${order.trackingNumber}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.hint),
              ),
            ],
            const SizedBox(height: AppSpacing.m),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('View details'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
