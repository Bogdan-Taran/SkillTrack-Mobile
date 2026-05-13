import 'package:sqflite/sqflite.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/database/database_service.dart';
import '../../domain/models/project_model.dart';
import '../../domain/models/task_model.dart';

part 'local_project_repository.g.dart';

class LocalProjectRepository {
  final Database _db;

  LocalProjectRepository(this._db);

  Future<List<ProjectModel>> getProjects() async {
    final List<Map<String, dynamic>> projectMaps = await _db.query('projects');
    
    List<ProjectModel> projects = [];
    for (var projectMap in projectMaps) {
      final List<Map<String, dynamic>> taskMaps = await _db.query(
        'tasks',
        where: 'project_id = ?',
        whereArgs: [projectMap['id']],
      );

      final tasks = taskMaps.map((t) => TaskModel(
        id: t['id'],
        title: t['title'],
        description: t['description'],
        deadline: DateTime.fromMillisecondsSinceEpoch(t['deadline']),
        priority: t['priority'],
        status: t['status'],
      )).toList();

      projects.add(ProjectModel(
        id: projectMap['id'],
        title: projectMap['title'],
        description: projectMap['description'],
        deadline: DateTime.fromMillisecondsSinceEpoch(projectMap['deadline']),
        tasks: tasks,
      ));
    }
    return projects;
  }

  Future<void> saveProject(ProjectModel project) async {
    await _db.transaction((txn) async {
      await txn.insert(
        'projects',
        {
          'id': project.id,
          'title': project.title,
          'description': project.description,
          'deadline': project.deadline.millisecondsSinceEpoch,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      for (var task in project.tasks) {
        await txn.insert(
          'tasks',
          {
            'id': task.id,
            'project_id': project.id,
            'title': task.title,
            'description': task.description,
            'deadline': task.deadline.millisecondsSinceEpoch,
            'priority': task.priority,
            'status': task.status,
          },
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    });
  }

  Future<void> deleteProject(String id) async {
    await _db.delete(
      'projects',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

@riverpod
LocalProjectRepository localProjectRepository(Ref ref) {
  final db = ref.watch(databaseServiceProvider).requireValue;
  return LocalProjectRepository(db);
}
