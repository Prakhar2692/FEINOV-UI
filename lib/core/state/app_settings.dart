import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/session_service.dart';
import '../services/storage_service.dart';

class AppSettings {
  const AppSettings({
    this.isAuthenticated = false,
    this.cartCount = 0,
    this.locale = const Locale('en'),
    this.themeMode = ThemeMode.system,
  });

  final bool isAuthenticated;
  final int cartCount;
  final Locale locale;
  final ThemeMode themeMode;

  AppSettings copyWith({
    bool? isAuthenticated,
    int? cartCount,
    Locale? locale,
    ThemeMode? themeMode,
  }) {
    return AppSettings(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      cartCount: cartCount ?? this.cartCount,
      locale: locale ?? this.locale,
      themeMode: themeMode ?? this.themeMode,
    );
  }
}

class AppSettingsController extends StateNotifier<AppSettings> {
  AppSettingsController() : super(const AppSettings());

  void signIn() {
    state = state.copyWith(isAuthenticated: true);
  }

  void signOut() {
    state = state.copyWith(isAuthenticated: false, cartCount: 0);
  }

  void updateCartCount(int count) {
    state = state.copyWith(cartCount: count < 0 ? 0 : count);
  }

  void setLocale(Locale locale) {
    state = state.copyWith(locale: locale);
  }

  void setThemeMode(ThemeMode themeMode) {
    state = state.copyWith(themeMode: themeMode);
  }

  void toggleTheme() {
    final nextMode = state.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    state = state.copyWith(themeMode: nextMode);
  }
}

final appSettingsProvider =
    StateNotifierProvider<AppSettingsController, AppSettings>(
      (ref) => AppSettingsController(),
    );

final storageServiceProvider = Provider<StorageService>(
  (ref) => InMemoryStorageService(),
);

final sessionServiceProvider = Provider<SessionService>(
  (ref) => SessionService(ref.watch(storageServiceProvider)),
);
