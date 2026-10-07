import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../bootstrap/app_bootstrap.dart';

final appLoggerProvider = Provider<AppLogger>((ref) => AppLogger.instance);

final appAnalyticsProvider = Provider<AppAnalytics>(
  (ref) => AppAnalytics(ref.watch(appLoggerProvider)),
);

final appVersionProvider = Provider<AppVersionInfo>(
  (ref) => AppVersionInfo.current,
);
