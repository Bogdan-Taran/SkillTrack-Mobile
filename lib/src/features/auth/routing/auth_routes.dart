
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:talker_flutter/talker_flutter.dart';

import '../../../core/utils/logger.dart';
import '../application/auth_provider.dart';
import '../presentation/pages/login_screen.dart';
import '../../home/presentation/pages/home_screen.dart';
import '../../onboarding/application/onboarding_provider.dart';
import '../../onboarding/presentation/pages/introduction_screen.dart';
import '../presentation/pages/register_screen.dart';

part 'auth_routes.g.dart';

@riverpod
GoRouter router(Ref ref) {
  final authNotifier = ref.watch(authProvider.notifier);
  final onboardingNotifier = ref.watch(onboardingProvider.notifier);

  return GoRouter(
    initialLocation: '/',
    observers: [TalkerRouteObserver(talker)],
    refreshListenable: Listenable.merge([authNotifier, onboardingNotifier]),
    redirect: (context, state) {
      // Ждем завершения инициализации обоих провайдеров
      if (!authNotifier.isInitialized || !onboardingNotifier.isInitialized) {
        return null;
      }

      final isOnboardingCompleted = onboardingNotifier.isCompleted;
      final isAuthenticated = authNotifier.isAuthenticated;

      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';
      final isOnboarding = state.matchedLocation == '/onboarding';

      // Если пользователь авторизован, он не должен видеть онбординг или экраны входа
      if (isAuthenticated) {
        if (isLoggingIn || isRegistering || isOnboarding) {
          return '/';
        }
        return null;
      }

      // Если онбординг не пройден — отправляем на онбординг
      if (!isOnboardingCompleted) {
        return isOnboarding ? null : '/onboarding';
      }

      // Если онбординг пройден, но не авторизован
      if (isLoggingIn || isRegistering) return null;
      
      // По умолчанию после онбординга отправляем на регистрацию
      return '/register';
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
