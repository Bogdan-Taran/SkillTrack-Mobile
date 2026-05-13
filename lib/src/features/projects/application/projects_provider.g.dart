// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'projects_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Projects)
final projectsProvider = ProjectsProvider._();

final class ProjectsProvider
    extends $NotifierProvider<Projects, List<ProjectModel>> {
  ProjectsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'projectsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$projectsHash();

  @$internal
  @override
  Projects create() => Projects();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ProjectModel> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ProjectModel>>(value),
    );
  }
}

String _$projectsHash() => r'2e5489acb4d5efe02fc854c47d4ae5147fdbbbcf';

abstract class _$Projects extends $Notifier<List<ProjectModel>> {
  List<ProjectModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<List<ProjectModel>, List<ProjectModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ProjectModel>, List<ProjectModel>>,
              List<ProjectModel>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
