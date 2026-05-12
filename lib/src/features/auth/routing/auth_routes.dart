
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../application/auth_provider.dart';
import '../presentation/login_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../onboarding/application/onboarding_provider.dart';
import '../../onboarding/presentation/introduction_screen_1.dart';

part 'auth_routes.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final authNotifier = ref.watch(authProvider.notifier);
  final onboardingNotifier = ref.watch(onboardingProvider.notifier);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: Listenable.merge([authNotifier, onboardingNotifier]),
    redirect: (context, state) {
      final isOnboardingCompleted = onboardingNotifier.isCompleted;
      final isAuthenticated = authNotifier.isAuthenticated;

      final isLoggingIn = state.matchedLocation == '/login';
      final isOnboarding = state.matchedLocation == '/onboarding';

      // 1. Если онбординг не пройден — отправляем на онбординг
      if (!isOnboardingCompleted) {
        return isOnboarding ? null : '/onboarding';
      }

      // 2. Если онбординг пройден, но не авторизован — отправляем на логин
      if (!isAuthenticated) {
        if (isLoggingIn) return null;
        // Если юзер на странице онбординга, но он уже завершен — на логин
        return '/login';
      }

      // 3. Если авторизован и пытается зайти на логин или онбординг — на главную
      if (isAuthenticated && (isLoggingIn || isOnboarding)) {
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const IntroductionScreen1(),
      ),
    ],
  );
}
