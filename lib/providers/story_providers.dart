import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/story.dart';
import 'providers.dart';

final topStoriesProvider = FutureProvider<List<int>>((ref) async {
  final apiService = ref.read(hackerNewsApiServiceProvider);
  return apiService.getTopStories();
});

final storyProvider = FutureProvider.family<Story, int>((ref, storyId) async {
  final apiService = ref.read(hackerNewsApiServiceProvider);
  return apiService.getStoryDetails(storyId);
});