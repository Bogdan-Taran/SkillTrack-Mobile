import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../application/projects_provider.dart';
import '../widgets/add_project_sheet.dart';
import '../widgets/project_list_item.dart';

class ProjectsScreen extends ConsumerWidget {
  final VoidCallback onBack;
  final Function(String)? onProjectTap;

  const ProjectsScreen({
    super.key,
    required this.onBack,
    this.onProjectTap,
  });

  void _showAddProject(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AddProjectSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projectsAsync = ref.watch(projectsProvider);

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
                child: projectsAsync.when(
                  data: (projects) => projects.isEmpty
                      ? Center(
                          child: Text(
                            'Нет проектов',
                            style: TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                        )
                      : ListView.builder(
                          itemCount: projects.length,
                          itemBuilder: (context, index) {
                            final project = projects[index];
                            return ProjectListItem(
                              title: project.title,
                              author: 'Вы', // Replace with real author if needed
                              date: project.deadline.toString().split(' ')[0], // Simple format
                              onTap: () => onProjectTap?.call(project.id),
                            );
                          },
                        ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProject(context),
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
