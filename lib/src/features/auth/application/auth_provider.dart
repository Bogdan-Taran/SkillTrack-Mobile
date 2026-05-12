import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/logger.dart';
import '../domain/services/auth_service.dart';
import '../domain/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';

part 'auth_provider.g.dart';

@riverpod
AuthService authService(Ref ref) {
  return AuthService();
}

@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl();
}

@riverpod
class Auth extends _$Auth implements Listenable {
  VoidCallback? _listener;
  bool _isInitialized = false;

  @override
  bool build() {
    _checkToken();
    return false;
  }

  bool get isAuthenticated => state;
  bool get isInitialized => _isInitialized;

  Future<void> _checkToken() async {
    final hasToken = await ref.read(authServiceProvider).hasToken();
    if (hasToken) {
      talker.info('Persistent session found, authenticating...');
      state = true;
    } else {
      talker.info('No persistent session found');
    }
    _isInitialized = true;
    _notify();
  }

  Future<void> login(String email, String password) async {
    talker.info('Attempting login for: $email');
    try {
      final token = await ref.read(authRepositoryProvider).login(email, password);
      await ref.read(authServiceProvider).saveToken(token);
      state = true;
      talker.log('Login successful for: $email');
      _notify();
    } catch (e, st) {
      talker.handle(e, st, 'Login failed for: $email');
      rethrow;
    }
  }

  Future<void> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    talker.info('Attempting registration for: $email');
    try {
      final token = await ref.read(authRepositoryProvider).register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      await ref.read(authServiceProvider).saveToken(token);
      state = true;
      talker.log('Registration successful for: $email');
      _notify();
    } catch (e, st) {
      talker.handle(e, st, 'Registration failed for: $email');
      rethrow;
    }
  }

  Future<void> logout() async {
    talker.info('Logging out');
    await ref.read(authRepositoryProvider).logout();
    await ref.read(authServiceProvider).deleteToken();
    state = false;
    talker.info('Logged out successfully');
    _notify();
  }

  void _notify() {
    _listener?.call();
  }

  @override
  void addListener(VoidCallback listener) {
    _listener = listener;
  }

  @override
  void removeListener(VoidCallback listener) {
    _listener = null;
  }
}
