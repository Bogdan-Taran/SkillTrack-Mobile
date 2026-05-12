import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../onboarding/presentation/widgets/primary_button.dart';
import 'widgets/auth_background.dart';
import 'widgets/auth_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      backgroundImage: 'assets/images/onboarding_bg_2.png',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 40.h),
            Text('SkillTrack', style: AppTextStyles.titleLarge),
            const Spacer(flex: 2),
            Text(
              'Авторизация',
              style: AppTextStyles.onboardingTitle.copyWith(fontSize: 24.sp),
            ),
            SizedBox(height: 32.h),
            const AuthTextField(hintText: 'Email'),
            const AuthTextField(hintText: 'Пароль', obscureText: true),
            SizedBox(height: 32.h),
            PrimaryButton(
              text: 'Войти',
              width: double.infinity,
              onPressed: () {
                // Логика входа
              },
            ),
            SizedBox(height: 24.h),
            Text('Ещё нет аккаунта?', style: TextStyle(color: AppColors.textWhite, fontSize: 14.sp)),
            TextButton(
              onPressed: () => context.go('/register'),
              child: Text(
                'Зарегистрироваться',
                style: TextStyle(color: AppColors.accent, fontSize: 16.sp),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
