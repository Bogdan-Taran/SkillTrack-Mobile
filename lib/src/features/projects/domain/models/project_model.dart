import 'package:freezed_annotation/freezed_annotation.dart';
import 'task_model.dart';

part 'project_model.freezed.dart';
part 'project_model.g.dart';

@freezed
class ProjectModel with _$ProjectModel {
  const factory ProjectModel({
    required String id,
    required String title,
    String? description,
    required DateTime deadline,
    @Default([]) List<TaskModel> tasks,
  }) = _ProjectModel;

  factory ProjectModel.fromJson(Map<String, dynamic> json) => _$ProjectModelFromJson(json);
}
