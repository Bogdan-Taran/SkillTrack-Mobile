import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../application/projects_provider.dart';
import '../../domain/models/task_model.dart';

class AddTaskSheet extends ConsumerStatefulWidget {
  final String projectId;
  final TaskModel? task;
  const AddTaskSheet({super.key, required this.projectId, this.task});

  @override
  ConsumerState<AddTaskSheet> createState() => _AddTaskSheetState();
}

class _AddTaskSheetState extends ConsumerState<AddTaskSheet> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late String selectedPriority;
  late String selectedStatus;
  DateTime? selectedDate;

  final List<String> statuses = ['Бэклог', 'К исполнению', 'В работе', 'Готово'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title);
    _descriptionController = TextEditingController(text: widget.task?.description);
    selectedPriority = widget.task?.priority ?? 'P0';
    selectedStatus = widget.task?.status ?? 'К исполнению';
    selectedDate = widget.task?.deadline;
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
              surface: Color(0xFF1E1E1E),
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

  void _saveTask() {
    if (_titleController.text.isEmpty || selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, заполните обязательные поля')),
      );
      return;
    }

    if (widget.task != null) {
      final updatedTask = widget.task!.copyWith(
        title: _titleController.text,
        description: _descriptionController.text,
        deadline: selectedDate!,
        priority: selectedPriority,
        status: selectedStatus,
      );
      ref.read(projectsProvider.notifier).updateTaskInProject(widget.projectId, updatedTask);
    } else {
      final newTask = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        deadline: selectedDate!,
        priority: selectedPriority,
        status: selectedStatus,
      );
      ref.read(projectsProvider.notifier).addTaskToProject(widget.projectId, newTask);
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
              widget.task == null ? 'Новая задача' : 'Редактировать задачу',
              style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            TextField(
              controller: _titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Название задачи',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
              ),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: _descriptionController,
              maxLines: 4,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Описание',
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16.sp),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
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
                          ? 'Дедлайн'
                          : DateFormat('dd MMM yyyy', 'ru').format(selectedDate!),
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                  Icon(Icons.calendar_month, color: Colors.white, size: 28.sp),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Text('Приоритетность', style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['P0', 'P1', 'P2', 'P3', 'P4'].map((p) {
                final isSelected = selectedPriority == p;
                return GestureDetector(
                  onTap: () => setState(() => selectedPriority = p),
                  child: Container(
                    width: 44.w, height: 44.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: isSelected ? AppColors.primary : Colors.grey),
                    ),
                    child: Center(child: Text(p, style: const TextStyle(color: Colors.white))),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20.h),
            Row(
              children: [
                Text('Статус', style: TextStyle(color: Colors.grey, fontSize: 14.sp)),
                SizedBox(width: 16.w),
                DropdownButton<String>(
                  value: selectedStatus,
                  dropdownColor: const Color(0xFF2C2C2C),
                  style: const TextStyle(color: Colors.white),
                  items: statuses.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                  onChanged: (val) { if (val != null) setState(() => selectedStatus = val); },
                ),
              ],
            ),
            SizedBox(height: 32.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Отмена', style: TextStyle(color: Colors.white70))),
                ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                  child: const Text('Сохранить', style: TextStyle(color: Colors.black)),
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
