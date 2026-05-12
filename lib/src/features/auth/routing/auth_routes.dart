
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../application/auth_provider.dart';
import '../presentation/login_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../onboarding/application/onboarding_provider.dart';
import '../../onboarding/presentation/pages/introduction_screen.dart';
import '../presentation/register_screen.dart';

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
      final isRegistering = state.matchedLocation == '/register';
      final isOnboarding = state.matchedLocation == '/onboarding';

      // если онбординг не пройден — отправляем на онбординг
      if (!isOnboardingCompleted) {
        return isOnboarding ? null : '/onboarding';
      }

      // если онбординг пройден, но не авторизован
      if (!isAuthenticated) {
        // если юзер уже на логине или регистрации - остаемся
        if (isLoggingIn || isRegistering) return null;
        
        // по умолчанию после онбординга отправляем на регистрацию
        return '/register';
      }

      // если авторизован и пытается зайти на служебные экраны - на главную
      if (isAuthenticated && (isLoggingIn || isRegistering || isOnboarding)) {
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
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const IntroductionScreen1(),
      ),
    ],
  );
}
