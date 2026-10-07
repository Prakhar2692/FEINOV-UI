import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../config/app_environment.dart';

class AppLogger {
  AppLogger._();

  static final AppLogger instance = AppLogger._();

  void info(String message) {
    debugPrint('[INFO] $message');
  }

  void warn(String message) {
    debugPrint('[WARN] $message');
  }

  void error(Object error, [StackTrace? stackTrace]) {
    debugPrint('[ERROR] $error');
    if (stackTrace != null) {
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}

class AppAnalytics {
  AppAnalytics(this._logger);

  final AppLogger _logger;

  Future<void> initialize() async {
    _logger.info('Analytics initialized');
  }

  void trackEvent(String name, [Map<String, Object?>? properties]) {
    final payload = properties == null || properties.isEmpty
        ? name
        : '$name ${properties.toString()}';
    _logger.info('Analytics event: $payload');
  }
}

class AppVersionInfo {
  const AppVersionInfo({required this.version, required this.buildNumber});

  final String version;
  final String buildNumber;

  String get fullVersion => '$version+$buildNumber';

  static const AppVersionInfo current = AppVersionInfo(
    version: '1.0.0',
    buildNumber: '1',
  );
}

class AppBootstrap {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      AppLogger.instance.error(details.exception, details.stack);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      AppLogger.instance.error(error, stack);
      return true;
    };

    AppLogger.instance.info(
      'App initialized in ${AppEnvironment.current.name} mode',
    );
    AppAnalytics(AppLogger.instance).initialize();
  }
}
