import 'package:hacker_rack/models/story.dart';

abstract class LocalDataSource {
  Future<void> cacheStories(List<int> storyIds);
  Future<List<int>> getCachedStories();
  Future<void> cacheStory(Story story);
  Future<Story?> getCachedStory(int id);
}
