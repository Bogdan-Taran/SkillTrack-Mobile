import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../onboarding/presentation/widgets/primary_button.dart';
import 'widgets/auth_background.dart';
import 'widgets/auth_text_field.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      backgroundImage: 'assets/images/register_screen_bg.png',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 40.h),
              Text('SkillTrack', style: AppTextStyles.titleLarge),
              SizedBox(height: 60.h),
              Text(
                'Регистрация',
                style: AppTextStyles.onboardingTitle.copyWith(fontSize: 24.sp),
              ),
              SizedBox(height: 32.h),
              const AuthTextField(hintText: 'Имя'),
              const AuthTextField(hintText: 'Фамилия'),
              const AuthTextField(hintText: 'Email'),
              const AuthTextField(hintText: 'Пароль', obscureText: true),
              SizedBox(height: 32.h),
              PrimaryButton(
                text: 'Зарегистрироваться',
                width: double.infinity,
                onPressed: () {
                  // Логика регистрации
                },
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Уже есть аккаунт?',
                    style: TextStyle(color: AppColors.textWhite, fontSize: 14.sp),
                  ),
                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(
                      'Войти',
                      style: TextStyle(color: AppColors.accent, fontSize: 16.sp),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
