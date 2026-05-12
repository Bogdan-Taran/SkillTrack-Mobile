import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../application/onboarding_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

class IntroductionScreen1 extends ConsumerWidget {
  const IntroductionScreen1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageDecoration = PageDecoration(
      titleTextStyle: AppTextStyles.onboardingTitle,
      bodyTextStyle: AppTextStyles.onboardingBody,
      bodyPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      pageColor: AppColors.background,
      imagePadding: EdgeInsets.zero,
      titlePadding: EdgeInsets.only(top: 20.h, bottom: 24.h),
      bodyAlignment: Alignment.center,
      imageAlignment: Alignment.center,
    );

    return IntroductionScreen(
      globalBackgroundColor: AppColors.background,
      allowImplicitScrolling: true,
      globalHeader:  SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 40.h),
          child: Center(
            child: Text(
              'SkillTrack',
              style: AppTextStyles.titleLarge,
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
              padding: EdgeInsets.only(top: 100.h),
              child: Image.asset(
                'assets/images/onboarding_sphere.png',
                width: 280.w,
              ),
            ),
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => ref.read(onboardingProvider.notifier).completeOnboarding(),
      onSkip: () => ref.read(onboardingProvider.notifier).completeOnboarding(),
      showSkipButton: false,
      showBackButton: false,
      next: const Icon(Icons.arrow_forward, color: AppColors.textWhite),
      done: PrimaryButton(
        text: 'Далее',
        onPressed: () => ref.read(onboardingProvider.notifier).completeOnboarding(),
      ),
      dotsDecorator: DotsDecorator(
        size: Size(10.w, 10.h),
        color: AppColors.textGrey,
        activeSize: Size(22.w, 10.h),
        activeColor: AppColors.primary,
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.r)),
        ),
      ),
      nextFlex: 0,
      skipOrBackFlex: 0,
      controlsMargin: EdgeInsets.all(16.h),
      controlsPadding: EdgeInsets.all(4.h),
    );
  }
}