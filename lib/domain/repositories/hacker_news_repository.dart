import 'package:dartz/dartz.dart';
import 'package:hacker_rack/core/errors/failures.dart';
import 'package:hacker_rack/models/story.dart';
import 'package:hacker_rack/models/user.dart';

abstract class HackerNewsRepository {
  Future<Either<Failure, List<int>>> getTopStories();
  Future<Either<Failure, Story>> getStory(int id);
  Future<Either<Failure, User>> getUser(String id);
}
