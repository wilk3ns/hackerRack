import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/story.dart';
import '../models/user.dart';

part 'hacker_news_api_service.g.dart';

@RestApi(baseUrl: "https://hacker-news.firebaseio.com/v0")
abstract class HackerNewsApiService {
  factory HackerNewsApiService(Dio dio, {String baseUrl}) = _HackerNewsApiService;

  // Fetch top stories (list of story IDs)
  @GET("/topstories.json")
  Future<List<int>> getTopStories();

  // Fetch details of a single story by its ID
  @GET("/item/{id}.json")
  Future<Story> getStoryDetails(@Path("id") int id);

  // Fetch details of a user by their ID
  @GET("/user/{id}.json")
  Future<User> getUserDetails(@Path("id") String id);
}