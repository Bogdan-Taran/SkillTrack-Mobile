import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import '../../../core/utils/logger.dart';
import '../domain/services/auth_service.dart';
import '../domain/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/models/user_model.dart';
import '../data/repositories/local_user_repository.dart';

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
  UserModel? _user;

  @override
  bool build() {
    _checkToken();
    return false;
  }

  bool get isAuthenticated => state;
  bool get isInitialized => _isInitialized;
  UserModel? get user => _user;

  Future<void> _checkToken() async {
    final hasToken = await ref.read(authServiceProvider).hasToken();
    if (hasToken) {
      talker.info('сессия найдена, аворизация');
      _user = await ref.read(localUserRepositoryProvider).getUser();
      state = true;
    } else {
      talker.info('не найдено сессий');
    }
    _isInitialized = true;
    _notify();
  }

  Future<void> login(String email, String password) async {
    talker.info('Attempting login for: $email');
    try {
      final token = await ref.read(authRepositoryProvider).login(email, password);
      await ref.read(authServiceProvider).saveToken(token);
      
      // For now, mock user data after login
      _user = UserModel(id: '1', name: 'Иван Иванов', email: email);
      await ref.read(localUserRepositoryProvider).saveUser(_user!);
      
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
      
      _user = UserModel(id: '1', name: '$firstName $lastName', email: email);
      await ref.read(localUserRepositoryProvider).saveUser(_user!);

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
    await ref.read(localUserRepositoryProvider).deleteUser();
    _user = null;
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
