import 'package:hacker_rack/models/story.dart';
import 'package:hacker_rack/models/user.dart';

abstract class RemoteDataSource {
  Future<List<int>> getTopStories();
  Future<Story> getStoryDetails(int id);
  Future<User> getUserDetails(String id);
}
