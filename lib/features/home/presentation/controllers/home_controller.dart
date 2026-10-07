import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/app_providers.dart';
import '../../domain/models/home_models.dart';

final homeControllerProvider =
    AsyncNotifierProvider<HomeController, HomePageData>(HomeController.new);

class HomeController extends AsyncNotifier<HomePageData> {
  @override
  FutureOr<HomePageData> build() async {
    return ref.read(homeRepositoryProvider).fetchHomeData();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(homeRepositoryProvider).fetchHomeData(),
    );
  }
}
