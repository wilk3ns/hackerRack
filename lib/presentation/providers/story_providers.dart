import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/story.dart';
import 'providers.dart';

final storyProvider = FutureProvider.family<Story, int>((ref, storyId) async {
  final repository = ref.read(hackerNewsRepositoryProvider);
  final result = await repository.getStory(storyId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (story) => story,
  );
});

final topStoriesProvider = FutureProvider<List<int>>((ref) async {
  final repository = ref.read(hackerNewsRepositoryProvider);
  final result = await repository.getTopStories();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (stories) => stories,
  );
});
