import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../application/onboarding_provider.dart';

class IntroductionScreen1 extends ConsumerWidget {
  const IntroductionScreen1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Стиль для основного заголовка страницы
    const titleStyle = TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    );

    // Стиль для подзаголовка (оранжевый текст)
    const bodyStyle = TextStyle(
      fontSize: 18.0,
      color: Color(0xFFD35400), // Оранжево-коричневый цвет из дизайна
    );

    final pageDecoration = PageDecoration(
      titleTextStyle: titleStyle,
      bodyTextStyle: bodyStyle,
      bodyPadding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: const Color(0xFF0D0D0D), // Почти черный фон
      imagePadding: EdgeInsets.zero,
      titlePadding: const EdgeInsets.only(top: 20.0, bottom: 24.0),
      bodyAlignment: Alignment.center,
      imageAlignment: Alignment.center,
    );

    return IntroductionScreen(
      globalBackgroundColor: const Color(0xFF0D0D0D),
      allowImplicitScrolling: true,
      // Заголовок SkillTrack в самом верху
      globalHeader: const SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(
            child: Text(
              'SkillTrack',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ),
      ),
      pages: [
        PageViewModel(
          title: "Управляйте своими\nежедневными задачами\nв SkillTrack",
          body: "Ваш новый центр управления делами",
          image: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 60.0),
              child: Image.asset(
                'assets/images/onboarding_sphere.png', // Путь к вашей сфере
                width: 300,
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
        // Вы можете добавить больше страниц PageViewModel здесь
      ],
      onDone: () => ref.read(onboardingProvider.notifier).completeOnboarding(),
      onSkip: () => ref.read(onboardingProvider.notifier).completeOnboarding(),
      showSkipButton: false,
      showBackButton: false,
      next: const Icon(Icons.arrow_forward, color: Colors.white),
      // Стилизация кнопки "Далее"
      done: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFC0392B), // Темно-оранжевый/красный градиентный цвет
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Text(
          'Далее',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Colors.grey,
        activeSize: Size(22.0, 10.0),
        activeColor: Color(0xFFC0392B),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      // Убираем стандартные отступы контроллов, чтобы кнопка была ближе к краю
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.all(4),
    );
  }
}