import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/project_list_item.dart';

class ProjectsScreen extends StatelessWidget {
  final VoidCallback onBack;

  const ProjectsScreen({super.key, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background will be handled by HomeScreen's Stack
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20.h),
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: onBack,
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'Проекты',
                    style: AppTextStyles.onboardingTitle.copyWith(
                      fontSize: 28.sp,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              // Projects List
              Expanded(
                child: ListView(
                  children: [
                    ProjectListItem(
                      title: 'Семейное древо',
                      author: 'Михалёв Р. Г.',
                      date: '13 мая 2026',
                      onTap: () {},
                    ),
                    ProjectListItem(
                      title: 'Сервис по созданию фот',
                      author: 'Михалёв Р. Г.',
                      date: '13 мая 2026',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Icon(
          Icons.add,
          color: Colors.black,
          size: 32.sp,
        ),
      ),
    );
  }
}
