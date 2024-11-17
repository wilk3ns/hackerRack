import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hacker_rack/models/story.dart';
import 'story_providers.dart';

const int pageSize = 10;

final submissionsProvider = StateNotifierProvider.family<
  SubmissionsNotifier,
  AsyncValue<List<Story>>,
  SubmissionConfig
>((ref, config) => SubmissionsNotifier(ref, config));

class SubmissionConfig {
  final List<int> submissionIds;
  final bool isComments;

  const SubmissionConfig({
    required this.submissionIds,
    required this.isComments,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubmissionConfig &&
          runtimeType == other.runtimeType &&
          submissionIds == other.submissionIds &&
          isComments == other.isComments;

  @override
  int get hashCode => submissionIds.hashCode ^ isComments.hashCode;
}

class SubmissionsNotifier extends StateNotifier<AsyncValue<List<Story>>> {
  final Ref _ref;
  final SubmissionConfig _config;
  int _currentPage = 0;
  bool _hasMore = true;
  List<Story> _loadedStories = [];

  SubmissionsNotifier(this._ref, this._config)
    : super(const AsyncValue.loading()) {
    loadInitialBatch();
  }

  Future<void> loadInitialBatch() async {
    _currentPage = 0;
    _hasMore = true;
    _loadedStories = [];
    state = const AsyncValue.loading();
    await loadMore();
  }

  Future<void> loadMore() async {
    if (!_hasMore || state.isLoading) return;

    try {
      final startIndex = _currentPage * pageSize;
      final endIndex = startIndex + pageSize;

      if (startIndex >= _config.submissionIds.length) {
        _hasMore = false;
        return;
      }

      final batch = _config.submissionIds.sublist(
        startIndex,
        endIndex.clamp(0, _config.submissionIds.length),
      );

      final stories = await Future.wait(
        batch.map((id) async {
          try {
            return await _ref.read(storyProvider(id).future);
          } catch (e) {
            //print('Error loading story $id: $e');
            return null;
          }
        }),
      );

      final validStories =
          stories
              .whereType<Story>()
              .where(
                (story) =>
                    _config.isComments
                        ? story.title == null
                        : story.title != null,
              )
              .toList();

      _loadedStories = [..._loadedStories, ...validStories];
      state = AsyncValue.data(_loadedStories);

      _currentPage++;
      _hasMore =
          endIndex < _config.submissionIds.length && validStories.isNotEmpty;
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  bool get hasMore => _hasMore;

  void refresh() {
    loadInitialBatch();
  }
}
