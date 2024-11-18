import 'package:hacker_rack/data/datasources/remote_data_source.dart';
import 'package:hacker_rack/models/story.dart';
import 'package:hacker_rack/models/user.dart';
import 'package:hacker_rack/services/hacker_news_api_service.dart';

class RemoteDataSourceImpl implements RemoteDataSource {
  final HackerNewsApiService _apiService;

  RemoteDataSourceImpl(this._apiService);

  @override
  Future<List<int>> getTopStories() => _apiService.getTopStories();

  @override
  Future<Story> getStoryDetails(int id) => _apiService.getStoryDetails(id);

  @override
  Future<User> getUserDetails(String id) => _apiService.getUserDetails(id);
}