import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_provider.g.dart';

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier implements Listenable {
  VoidCallback? _listener;
  bool _isCompleted = false;

  @override
  bool build() => _isCompleted;

  bool get isCompleted => _isCompleted;

  void completeOnboarding() {
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
