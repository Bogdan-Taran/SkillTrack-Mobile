import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/projects_provider.dart';
import '../../domain/models/project_model.dart';
import '../../domain/models/task_model.dart';
import 'task_item_small.dart';

class AddProjectSheet extends ConsumerStatefulWidget {
  final ProjectModel? project;
  const AddProjectSheet({super.key, this.project});

  @override
  ConsumerState<AddProjectSheet> createState() => _AddProjectSheetState();
}

class _AddProjectSheetState extends ConsumerState<AddProjectSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  DateTime? selectedDate;
  List<TaskModel> _tasks = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.project?.title);
    _descriptionController = TextEditingController(text: widget.project?.description);
    selectedDate = widget.project?.deadline;
    _tasks = widget.project?.tasks != null ? List.from(widget.project!.tasks) : [];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: const Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  void _showAddTask() async {
    final task = await showModalBottomSheet<TaskModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _LocalAddTaskSheet(),
    );

    if (task != null) {
      setState(() {
        _tasks.add(task);
      });
    }
  }

  void _saveProject() {
    if (_titleController.text.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните название и дату')),
      );
      return;
    }

    if (widget.project != null) {
      final updatedProject = widget.project!.copyWith(
        title: _titleController.text,
        description: _descriptionController.text,
        deadline: selectedDate!,
        tasks: _tasks,
      );
      ref.read(projectsProvider.notifier).updateProject(updatedProject);
    } else {
      final newProject = ProjectModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        deadline: selectedDate!,
        tasks: _tasks,
      );
      ref.read(projectsProvider.notifier).addProject(newProject);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.w,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.w,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.project == null ? 'Новый проект' : 'Редактировать проект',
              style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Название проекта',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
              ),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Описание проекта',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate == null
                          ? 'Срок сдачи'
                          : 'Дедлайн: ${DateFormat('dd MMM yyyy', 'ru').format(selectedDate!)}',
                      style: TextStyle(
                        color: selectedDate == null ? Colors.grey : Colors.white,
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  Icon(Icons.calendar_month, color: Colors.white, size: 28.sp),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            if (_tasks.isNotEmpty) ...[
              Text('Задачи проекта:', style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
              SizedBox(height: 12.h),
              ..._tasks.map((task) => TaskItemSmall(
                task: task,
                onTap: () => setState(() => _tasks.remove(task)),
              )),
            ],
            GestureDetector(
              onTap: _showAddTask,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  children: [
                    Icon(Icons.add_circle_outline, color: AppColors.primary, size: 24.sp),
                    SizedBox(width: 8.w),
                    Text('Добавить задачу', style: TextStyle(color: AppColors.primary, fontSize: 16.sp)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Отмена', style: TextStyle(color: Colors.white70, fontSize: 16.sp)),
                ),
                ElevatedButton(
                  onPressed: _saveProject,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  ),
                  child: Text('Сохранить', style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}

class _LocalAddTaskSheet extends StatefulWidget {
  const _LocalAddTaskSheet();
  @override
  State<_LocalAddTaskSheet> createState() => _LocalAddTaskSheetState();
}

class _LocalAddTaskSheetState extends State<_LocalAddTaskSheet> {
  final _titleController = TextEditingController();
  DateTime? selectedDate;
  String selectedPriority = 'P1';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 20.w,
        right: 20.w,
        top: 20.w,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20.w,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Новая задача',
            style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          TextField(
            controller: _titleController,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Название задачи',
              hintStyle: TextStyle(color: Colors.grey),
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Text('Приоритет:', style: TextStyle(color: Colors.white, fontSize: 14.sp)),
              SizedBox(width: 12.w),
              ...['P0', 'P1', 'P2', 'P3', 'P4'].map((p) => Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: ChoiceChip(
                  label: Text(p),
                  selected: selectedPriority == p,
                  onSelected: (selected) {
                    if (selected) setState(() => selectedPriority = p);
                  },
                  backgroundColor: const Color(0xFF1E1E1E),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selectedPriority == p ? Colors.black : Colors.white,
                    fontSize: 12.sp,
                  ),
                ),
              )),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: TextButton.icon(
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );
                    if (date != null) setState(() => selectedDate = date);
                  },
                  icon: const Icon(Icons.calendar_today, size: 18, color: AppColors.primary),
                  label: Text(
                    selectedDate == null ? 'Выбрать дату' : DateFormat('dd.MM.yyyy').format(selectedDate!),
                    style: const TextStyle(color: Colors.white70),
                  ),
                  style: TextButton.styleFrom(alignment: Alignment.centerLeft),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isNotEmpty && selectedDate != null) {
                    Navigator.pop(context, TaskModel(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _titleController.text,
                      deadline: selectedDate!,
                      priority: selectedPriority,
                      status: 'К исполнению',
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text('Добавить', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
