import '../bootstrap/app_bootstrap.dart';

class AnalyticsService {
  AnalyticsService(this.logger);

  final AppLogger logger;

  void trackEvent(String name, [Map<String, Object?>? properties]) {
    logger.info('Analytics event: $name ${properties ?? {}}');
  }
}
