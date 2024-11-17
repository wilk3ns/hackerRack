import 'package:hacker_rack/core/errors/failures.dart';
import 'package:hacker_rack/data/datasources/local_data_source.dart';
import 'package:hacker_rack/domain/repositories/hacker_news_repository.dart';
import 'package:hacker_rack/models/story.dart';
import 'package:hacker_rack/models/user.dart';
import 'package:hacker_rack/services/hacker_news_api_service.dart';
import 'package:dartz/dartz.dart';

class HackerNewsRepositoryImpl implements HackerNewsRepository {
  final HackerNewsApiService _apiService;
  final LocalDataSource _localDataSource;

  HackerNewsRepositoryImpl(this._apiService, this._localDataSource);

  @override
  Future<Either<Failure, List<int>>> getTopStories() async {
    try {
      final stories = await _apiService.getTopStories();
      await _localDataSource.cacheStories(stories);
      return Right(stories);
    } catch (e) {
      try {
        final cachedStories = await _localDataSource.getCachedStories();
        if (cachedStories.isNotEmpty) {
          return Right(cachedStories);
        } else {
          return Left(CacheFailure('No cached stories available'));
        }
      } catch (e) {
        return Left(ServerFailure('Failed to fetch stories'));
      }
    }
  }

  @override
  Future<Either<Failure, Story>> getStory(int id) async {
    try {
      final story = await _apiService.getStoryDetails(id);
      await _localDataSource.cacheStory(story);
      return Right(story);
    } catch (e) {
      try {
        final cachedStory = await _localDataSource.getCachedStory(id);
        if (cachedStory != null) {
          return Right(cachedStory);
        } else {
          return Left(CacheFailure('No cached story available'));
        }
      } catch (e) {
        return Left(ServerFailure('Failed to fetch story'));
      }
    }
  }

  @override
  Future<Either<Failure, User>> getUser(String id) async {
    try {
      final user = await _apiService.getUserDetails(id);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure('Failed to fetch user details'));
    }
  }
}
