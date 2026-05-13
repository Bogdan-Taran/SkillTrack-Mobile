import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../application/projects_provider.dart';
import '../widgets/add_project_sheet.dart';
import '../widgets/add_task_sheet.dart';
import '../widgets/task_item_small.dart';

class ProjectDetailsScreen extends ConsumerWidget {
  final String projectId;
  final VoidCallback onBack;

  const ProjectDetailsScreen({
    super.key,
    required this.projectId,
    required this.onBack,
  });

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Удалить проект?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Вы уверены, что хотите удалить этот проект? Все задачи будут удалены безвозвратно.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              ref.read(projectsProvider.notifier).deleteProject(projectId);
              Navigator.pop(context); // Close dialog
              onBack(); // Go back to projects list
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);
    final projectIndex = projects.indexWhere((p) => p.id == projectId);
    
    if (projectIndex == -1) {
      return const SizedBox.shrink();
    }
    
    final project = projects[projectIndex];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
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
                      const Spacer(),
                      Text(
                        project.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => AddProjectSheet(project: project),
                          );
                        },
                        icon: const Icon(Icons.edit_note, color: Colors.white, size: 28),
                      ),
                      IconButton(
                        onPressed: () => _confirmDelete(context, ref),
                        icon: const Icon(Icons.delete, color: Colors.red, size: 24),
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Description Box
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.description ?? 'Без описания',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                        if (project.description != null && project.description!.isNotEmpty)
                          SizedBox(height: 24.h),
                        Row(
                          children: [
                            Text(
                              'Срок сдачи:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                border: Border.all(color: Colors.white.withOpacity(0.5)),
                              ),
                              child: Text(
                                DateFormat('d MMMM yyyy', 'ru').format(project.deadline),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 36.h),
                ],
              ),
            ),

            // Tasks List
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Задачи',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Expanded(
                      child: project.tasks.isEmpty
                          ? Center(
                              child: Text(
                                'Нет задач',
                                style: TextStyle(color: Colors.white54, fontSize: 16.sp),
                              ),
                            )
                          : ListView.builder(
                              itemCount: project.tasks.length,
                              itemBuilder: (context, index) {
                                final task = project.tasks[index];
                                return TaskItemSmall(
                                  task: task,
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => AddTaskSheet(
                                        projectId: projectId,
                                        task: task,
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Delete Project Button at bottom
            Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(
                child: GestureDetector(
                  onTap: () => _confirmDelete(context, ref),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9B0000),
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    child: Text(
                      'Удалить проект',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
