import 'package:hacker_rack/data/datasources/local_data_source.dart';
import 'package:hacker_rack/models/story.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



class LocalDataSourceImpl implements LocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String CACHED_STORIES_KEY = 'CACHED_STORIES';
  static const String CACHED_STORY_PREFIX = 'CACHED_STORY';

  LocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheStories(List<int> storyIds) async {
    await sharedPreferences.setString(
      CACHED_STORIES_KEY,
      json.encode(storyIds),
    );
  }

  @override
  Future<List<int>> getCachedStories() async {
    final jsonString = sharedPreferences.getString(CACHED_STORIES_KEY);
    if (jsonString != null) {
      return List<int>.from(json.decode(jsonString));
    }
    return [];
  }

  @override
  Future<void> cacheStory(Story story) async {
    await sharedPreferences.setString(
      CACHED_STORY_PREFIX + story.id.toString(),
      json.encode(story.toJson()),
    );
  }

  @override
  Future<Story?> getCachedStory(int id) async {
    final jsonString = sharedPreferences.getString(
      CACHED_STORY_PREFIX + id.toString(),
    );
    if (jsonString != null) {
      return Story.fromJson(json.decode(jsonString));
    }
    return null;
  }
}
