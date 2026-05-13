import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../onboarding/presentation/widgets/primary_button.dart';
import '../../application/auth_provider.dart';
import '../widgets/auth_background.dart';
import '../widgets/auth_text_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).register(
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
    } catch (e) {
      // Error is handled by TalkerWrapper
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      backgroundImage: 'assets/images/onboarding_bg_2.png',
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                AuthTextField(
                  hintText: 'Имя',
                  controller: _firstNameController,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Введите имя' : null,
                ),
                AuthTextField(
                  hintText: 'Фамилия',
                  controller: _lastNameController,
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Введите фамилию' : null,
                ),
                AuthTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Введите корректный email';
                    }
                    return null;
                  },
                ),
                AuthTextField(
                  hintText: 'Пароль',
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Введите пароль';
                    }
                    if (value.length < 6) {
                      return 'Пароль должен быть не менее 6 символов';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32.h),
                PrimaryButton(
                  text: 'Зарегистрироваться',
                  isLoading: _isLoading,
                  width: double.infinity,
                  onPressed: _register,
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
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
