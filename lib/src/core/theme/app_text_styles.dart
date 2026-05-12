import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle titleLarge = TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textWhite,
    letterSpacing: 1.2,
  );

  static TextStyle onboardingTitle = TextStyle(
    fontSize: 28.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textWhite,
  );

  static TextStyle onboardingBody = TextStyle(
    fontSize: 18.sp,
    color: AppColors.accent,
  );

  static TextStyle buttonText = TextStyle(
    fontWeight: FontWeight.w600,
    color: AppColors.textWhite,
    fontSize: 18.sp,
  );
}