import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/models/project_model.dart';
import '../domain/models/task_model.dart';
import '../data/repositories/project_repository.dart';

part 'projects_provider.g.dart';

@riverpod
class Projects extends _$Projects {
  @override
  List<ProjectModel> build() {
    // Eventually, we can use ref.watch(projectRepositoryProvider).getProjects()
    // and handle the AsyncValue, but for now we keep it simple with synchronous state.
    return []; 
  }

  Future<void> addProject(ProjectModel project) async {
    final repository = ref.read(projectRepositoryProvider);
    final savedProject = await repository.createProject(project);
    state = [...state, savedProject];
  }

  Future<void> updateProject(ProjectModel project) async {
    final repository = ref.read(projectRepositoryProvider);
    final updatedProject = await repository.updateProject(project);
    state = [
      for (final p in state)
        if (p.id == updatedProject.id) updatedProject else p,
    ];
  }

  Future<void> deleteProject(String id) async {
    final repository = ref.read(projectRepositoryProvider);
    await repository.deleteProject(id);
    state = state.where((p) => p.id != id).toList();
  }

  void addTaskToProject(String projectId, TaskModel task) {
    state = [
      for (final project in state)
        if (project.id == projectId)
          project.copyWith(tasks: [...project.tasks, task])
        else
          project,
    ];
    // In a real app, you'd also call the repository here
  }

  void updateTaskInProject(String projectId, TaskModel task) {
    state = [
      for (final project in state)
        if (project.id == projectId)
          project.copyWith(
            tasks: [
              for (final t in project.tasks)
                if (t.id == task.id) task else t,
            ],
          )
        else
          project,
    ];
  }

  void deleteTaskFromProject(String projectId, String taskId) {
    state = [
      for (final project in state)
        if (project.id == projectId)
          project.copyWith(
            tasks: project.tasks.where((t) => t.id != taskId).toList(),
          )
        else
          project,
    ];
  }
}
