import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:hacker_rack/models/story.dart';
import 'package:hacker_rack/models/user.dart';

part 'hacker_news_api_service.g.dart';

@RestApi(baseUrl: "https://hacker-news.firebaseio.com/v0")
abstract class HackerNewsApiService {
  factory HackerNewsApiService(Dio dio, {String baseUrl}) =
      _HackerNewsApiService;

  @GET("/topstories.json")
  Future<List<int>> getTopStories();

  @GET("/item/{id}.json")
  Future<Story> getStoryDetails(@Path("id") int id);

  @GET("/user/{id}.json")
  Future<User> getUserDetails(@Path("id") String id);
}
