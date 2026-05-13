import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/models/project_model.dart';
import '../domain/models/task_model.dart';
import '../data/repositories/local_project_repository.dart';

part 'projects_provider.g.dart';

@riverpod
class Projects extends _$Projects {
  @override
  FutureOr<List<ProjectModel>> build() async {
    final repository = ref.watch(localProjectRepositoryProvider);
    return repository.getProjects();
  }

  Future<void> addProject(ProjectModel project) async {
    final repository = ref.read(localProjectRepositoryProvider);
    await repository.saveProject(project);
    
    final currentProjects = state.valueOrNull ?? [];
    state = AsyncData([...currentProjects, project]);
  }

  Future<void> updateProject(ProjectModel project) async {
    final repository = ref.read(localProjectRepositoryProvider);
    await repository.saveProject(project);
    
    final currentProjects = state.valueOrNull ?? [];
    state = AsyncData([
      for (final p in currentProjects)
        if (p.id == project.id) project else p,
    ]);
  }

  Future<void> deleteProject(String id) async {
    final repository = ref.read(localProjectRepositoryProvider);
    await repository.deleteProject(id);
    
    final currentProjects = state.valueOrNull ?? [];
    state = AsyncData(currentProjects.where((p) => p.id != id).toList());
  }

  Future<void> addTaskToProject(String projectId, TaskModel task) async {
    final currentProjects = state.valueOrNull ?? [];
    final project = currentProjects.firstWhere((p) => p.id == projectId);
    final updatedProject = project.copyWith(tasks: [...project.tasks, task]);
    
    await updateProject(updatedProject);
  }

  Future<void> updateTaskInProject(String projectId, TaskModel task) async {
    final currentProjects = state.valueOrNull ?? [];
    final project = currentProjects.firstWhere((p) => p.id == projectId);
    final updatedProject = project.copyWith(
      tasks: [
        for (final t in project.tasks)
          if (t.id == task.id) task else t,
      ],
    );
    
    await updateProject(updatedProject);
  }

  Future<void> deleteTaskFromProject(String projectId, String taskId) async {
    final currentProjects = state.valueOrNull ?? [];
    final project = currentProjects.firstWhere((p) => p.id == projectId);
    final updatedProject = project.copyWith(
      tasks: project.tasks.where((t) => t.id != taskId).toList(),
    );
    
    await updateProject(updatedProject);
  }
}
