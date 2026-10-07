import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../bootstrap/app_bootstrap.dart';
import '../network/dio_client.dart';
import '../services/analytics_service.dart';
import '../services/cache_service.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

final appLoggerProvider = Provider<AppLogger>((ref) => AppLogger.instance);

final appAnalyticsProvider = Provider<AppAnalytics>(
  (ref) => AppAnalytics(ref.watch(appLoggerProvider)),
);

final appVersionProvider = Provider<AppVersionInfo>(
  (ref) => AppVersionInfo.current,
);

final storageServiceProvider = Provider<StorageService>(
  (ref) => InMemoryStorageService(),
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
