import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/di/app_providers.dart';
import '../../../core/services/session_service.dart';
import '../../../core/state/app_settings.dart';
import '../domain/entities/user.dart';
import '../domain/repositories/auth_repository.dart';

class AuthState {
  const AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.rememberMe = true,
    this.errorMessage,
  });

  final User? user;
  final bool isAuthenticated;
  final bool isLoading;
  final bool rememberMe;
  final String? errorMessage;

  AuthState copyWith({
    User? user,
    bool? isAuthenticated,
    bool? isLoading,
    bool? rememberMe,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      rememberMe: rememberMe ?? this.rememberMe,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._repository, this._sessionService)
    : super(const AuthState()) {
    _initialize();
  }

  final AuthRepository _repository;
  final SessionService _sessionService;

  Future<void> _initialize() async {
    state = state.copyWith(isLoading: true);

    try {
      final token = await _sessionService.getToken();
      if (token == null || token.isEmpty) {
        state = const AuthState();
        return;
      }

      final user = await _repository.getCurrentUser();
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (_) {
      state = const AuthState();
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
    bool rememberMe = true,
  }) async {
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      rememberMe: rememberMe,
    );

    try {
      final user = await _repository.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );

      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String mobileNumber,
    required String countryCode,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = await _repository.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        mobileNumber: mobileNumber,
        countryCode: countryCode,
      );

      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> resetPassword({required String email}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _repository.forgotPassword(email);
      state = state.copyWith(isLoading: false, errorMessage: null);
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> verifyEmail({required String email, required String otp}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = await _repository.verifyEmail(email: email, otp: otp);
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.logout();
      state = const AuthState();
    } catch (_) {
      state = const AuthState();
    }
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (ref) {
    final repository = ref.watch(authRepositoryProvider);
    final sessionService = ref.watch(sessionServiceProvider);
    return AuthController(repository, sessionService);
  },
);
