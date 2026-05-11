import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

part 'auth_provider.g.dart';

// Создаем Notifier, который умеет уведомлять слушателей (ChangeNotifier)
@riverpod
class AuthNotifier extends _$AuthNotifier implements Listenable {
  VoidCallback? _listener;
  bool _isAuthenticated = false;

  @override
  bool build() => _isAuthenticated;

  bool get isAuthenticated => _isAuthenticated;

  void login() {
    _isAuthenticated = true;
    _notify();
  }

  void logout() {
    _isAuthenticated = false;
    _notify();
  }

  void _notify() {
    _listener?.call();
    ref.notifyListeners();
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