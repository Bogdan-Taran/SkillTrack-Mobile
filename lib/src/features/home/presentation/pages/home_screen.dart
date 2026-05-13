import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:talker_flutter/talker_flutter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/logger.dart';
import '../../../auth/application/auth_provider.dart';
import '../../../projects/application/projects_provider.dart';
import '../../../auth/presentation/pages/profile_screen.dart';
import '../../../projects/presentation/pages/projects_screen.dart';
import '../../../projects/presentation/pages/project_details_screen.dart';
import '../widgets/progress_card.dart';
import '../widgets/project_card.dart';
import '../widgets/task_card.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  String? _selectedProjectId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/home_screen_bg.png',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          IndexedStack(
            index: _selectedProjectId != null ? 3 : _selectedIndex,
            children: [
              _buildHomeContent(),
              ProjectsScreen(
                onBack: () => setState(() => _selectedIndex = 0),
                onProjectTap: (id) => setState(() => _selectedProjectId = id),
              ),
              const ProfileScreen(),
              if (_selectedProjectId != null)
                ProjectDetailsScreen(
                  projectId: _selectedProjectId!,
                  onBack: () => setState(() => _selectedProjectId = null),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: const Color(0xFF121212),
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.1), width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, 'assets/icons/home_icon.png'),
            _buildNavItem(1, 'assets/icons/project_icon.png'),
            _buildNavItem(2, 'assets/icons/person_icon.png'),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    final projectsAsync = ref.watch(projectsProvider);
    
    return projectsAsync.when(
      data: (projects) {
        // Flatten all tasks from all projects
        final allTasks = projects.expand((p) => p.tasks.map((t) => (task: t, projectName: p.title))).toList();
        // Sort by deadline
        allTasks.sort((a, b) => a.task.deadline.compareTo(b.task.deadline));
        
        final pendingTasksCount = allTasks.where((item) => item.task.status != 'Готово').length;

        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Главная страница',
                            style: AppTextStyles.onboardingTitle.copyWith(
                              fontSize: 28.sp,
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.logout, color: Colors.white),
                                onPressed: () => ref.read(authProvider.notifier).logout(),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      Text(
                        'Общий прогресс',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      const ProgressCard(),
                      
                      SizedBox(height: 24.h),
                      
                      // Tasks Section
                      Text(
                        'Ближайшие задачи',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '$pendingTasksCount ${pendingTasksCount == 1 ? 'задача ждет' : 'задач ждут'} выполнения',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      if (allTasks.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.h),
                          child: Text('Нет текущих задач', style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                        )
                      else
                        ...allTasks.take(4).map((item) => TaskCard(
                          title: item.task.title,
                          project: item.projectName,
                          priority: item.task.priority,
                        )),
                      
                      SizedBox(height: 24.h),
                      
                      // Projects Section
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ваши проекты:',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16.h),
                            if (projects.isEmpty)
                              Text('У вас пока нет проектов', style: TextStyle(color: Colors.grey, fontSize: 14.sp))
                            else
                              ...projects.take(3).toList().asMap().entries.map((entry) => ProjectCard(
                                title: entry.value.title,
                                isLast: entry.key == (projects.length < 3 ? projects.length - 1 : 2),
                                onTap: () {
                                  setState(() {
                                    _selectedProjectId = entry.value.id;
                                    _selectedIndex = 1;
                                  });
                                },
                              )),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err', style: const TextStyle(color: Colors.red))),
    );
  }

  Widget _buildNavItem(int index, String iconPath) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      child: Image.asset(
        iconPath,
        width: 28.w,
        height: 28.h,
        color: isSelected ? Colors.white : Colors.grey,
      ),
    );
  }
}
