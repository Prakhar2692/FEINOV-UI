import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bootstrap/app_bootstrap.dart';
import '../config/app_environment.dart';
import '../network/dio_client.dart';
import '../services/analytics_service.dart';
import '../services/cache_service.dart';
import '../services/notification_service.dart';
import '../state/app_settings.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/orders/data/repositories/order_repository_impl.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';

final appLoggerProvider = Provider<AppLogger>((ref) => AppLogger.instance);

final appAnalyticsProvider = Provider<AppAnalytics>(
  (ref) => AppAnalytics(ref.watch(appLoggerProvider)),
);

final appVersionProvider = Provider<AppVersionInfo>(
  (ref) => AppVersionInfo.current,
);

final appEnvironmentProvider = Provider<AppEnvironment>(
  (ref) => AppEnvironment.current,
);

final cacheServiceProvider = Provider<CacheService>(
  (ref) => CacheService(ref.watch(storageServiceProvider)),
);

final analyticsServiceProvider = Provider<AnalyticsService>(
  (ref) => AnalyticsService(ref.watch(appLoggerProvider)),
);

final notificationServiceProvider = Provider<NotificationService>(
  (ref) => NotificationService(),
);

final appDioProvider = Provider<Dio>((ref) => ref.watch(dioProvider));

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(
    dio: ref.watch(appDioProvider),
    sessionService: ref.watch(sessionServiceProvider),
  ),
);

final cartRepositoryProvider = Provider<CartRepository>(
  (ref) => CartRepositoryImpl(ref.watch(appDioProvider)),
);

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(ref.watch(appDioProvider)),
);

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => OrderRepositoryImpl(ref.watch(appDioProvider)),
);
