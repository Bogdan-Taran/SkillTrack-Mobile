import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/network/dio_client.dart';
import '../../domain/models/project_model.dart';

part 'project_repository.g.dart';

class ProjectRepository {
  final Dio _dio;

  ProjectRepository(this._dio);

  Future<List<ProjectModel>> getProjects() async {
    // try {
    //   final response = await _dio.get('/projects');
    //   return (response.data as List).map((e) => ProjectModel.fromJson(e)).toList();
    // } catch (e) {
    //   rethrow;
    // }
    return []; // Mock for now
  }

  Future<ProjectModel> createProject(ProjectModel project) async {
    // final response = await _dio.post('/projects', data: project.toJson());
    // return ProjectModel.fromJson(response.data);
    return project;
  }

  Future<void> deleteProject(String id) async {
    // await _dio.delete('/projects/$id');
  }

  Future<ProjectModel> updateProject(ProjectModel project) async {
    // final response = await _dio.put('/projects/${project.id}', data: project.toJson());
    // return ProjectModel.fromJson(response.data);
    return project;
  }
}

@riverpod
ProjectRepository projectRepository(Ref ref) {
  return ProjectRepository(ref.watch(dioProvider));
}
