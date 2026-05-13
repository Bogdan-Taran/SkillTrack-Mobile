import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isLast;

  const ProjectCard({
    super.key,
    required this.title,
    required this.onTap,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              InkWell(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Image.asset(
                    'assets/icons/forward_right_icon.png',
                    width: 24.w,
                    height: 24.h,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(color: Colors.grey.withOpacity(0.3)),
      ],
    );
  }
}
