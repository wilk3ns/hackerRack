import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:hacker_rack/data/repositories/hacker_news_repository_impl.dart';
import 'package:hacker_rack/services/hacker_news_api_service.dart';
import 'package:hacker_rack/data/datasources/local_data_source.dart';
import 'package:hacker_rack/models/story.dart';
import 'hacker_news_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<HackerNewsApiService>(),
  MockSpec<LocalDataSource>(),
])
void main() {
  late HackerNewsRepositoryImpl repository;
  late MockHackerNewsApiService mockApiService;
  late MockLocalDataSource mockLocalDataSource;

  setUp(() {
    mockApiService = MockHackerNewsApiService();
    mockLocalDataSource = MockLocalDataSource();
    repository = HackerNewsRepositoryImpl(mockApiService, mockLocalDataSource);
  });

  group('getStory', () {
    const testStoryId = 123;
    final testStory = Story(
      id: testStoryId,
      title: 'Test Story',
      by: 'testuser',
      time: 1234567890,
      url: 'https://example.com',
      descendants: 10,
      score: 100,
      text: null,
      type: 'comment',
    );

    test('should return Story when API call is successful', () async {
      when(mockApiService.getStoryDetails(testStoryId)).thenAnswer((_) async => testStory);
      when(mockLocalDataSource.cacheStory(testStory)).thenAnswer((_) async => {});

      final result = await repository.getStory(testStoryId);

      expect(result, Right(testStory));
      verify(mockApiService.getStoryDetails(testStoryId));
      verify(mockLocalDataSource.cacheStory(testStory));
    });

    test('should return cached Story when API call fails', () async {
      when(mockApiService.getStoryDetails(testStoryId)).thenThrow(Exception('Failed to fetch story'));
      when(mockLocalDataSource.getCachedStory(testStoryId)).thenAnswer((_) async => testStory);

      final result = await repository.getStory(testStoryId);

      expect(result, Right(testStory));
      verify(mockApiService.getStoryDetails(testStoryId));
      verify(mockLocalDataSource.getCachedStory(testStoryId));
    });
  });
}
