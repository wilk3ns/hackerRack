import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hacker_rack/presentation/providers/providers.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:dartz/dartz.dart';
import 'package:hacker_rack/domain/repositories/hacker_news_repository.dart';
import 'package:hacker_rack/models/story.dart';
import 'package:hacker_rack/presentation/providers/story_providers.dart';
import 'story_providers_test.mocks.dart';

@GenerateNiceMocks([MockSpec<HackerNewsRepository>()])
void main() {
  late MockHackerNewsRepository mockRepository;

  setUp(() {
    mockRepository = MockHackerNewsRepository();
  });

  test('storyProvider should return Story when successful', () async {
    final container = ProviderContainer(
      overrides: [repositoryProvider.overrideWithValue(mockRepository)],
    );
    addTearDown(container.dispose);

    final testStory = Story(
      id: 123,
      title: 'Test Story',
      by: 'testuser',
      time: 1234567890,
      url: 'https://example.com',
      descendants: 10,
      score: 100,
      text: null,
    );

    when(mockRepository.getStory(123)).thenAnswer((_) async => Right(testStory));

    final result = await container.read(storyProvider(123).future);

    expect(result, testStory);
    verify(mockRepository.getStory(123)).called(1);
  });
}
