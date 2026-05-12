import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../auth/application/auth_provider.dart';

part 'onboarding_provider.g.dart';

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier implements Listenable {
  VoidCallback? _listener;
  bool _isCompleted = false;
  bool _isInitialized = false;

  @override
  bool build() {
    _loadOnboardingStatus();
    return _isCompleted;
  }

  bool get isCompleted => _isCompleted;
  bool get isInitialized => _isInitialized;

  Future<void> _loadOnboardingStatus() async {
    _isCompleted = await ref.read(authServiceProvider).isOnboardingCompleted();
    _isInitialized = true;
    _notify();
  }

  Future<void> completeOnboarding() async {
    await ref.read(authServiceProvider).setOnboardingCompleted();
    _isCompleted = true;
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
