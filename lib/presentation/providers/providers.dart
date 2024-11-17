import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:hacker_rack/data/datasources/local_data_source.dart';
import 'package:hacker_rack/data/datasources/local_data_source_impl.dart';
import 'package:hacker_rack/data/repositories/hacker_news_repository_impl.dart';
import 'package:hacker_rack/domain/repositories/hacker_news_repository.dart';
import 'package:hacker_rack/services/dio_client.dart';
import 'package:hacker_rack/services/hacker_news_api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

final dioProvider = Provider<Dio>((ref) => DioClient.createDio());

final hackerNewsApiServiceProvider = Provider<HackerNewsApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return HackerNewsApiService(dio);
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return LocalDataSourceImpl(sharedPreferences: sharedPreferences);
});

final hackerNewsRepositoryProvider = Provider<HackerNewsRepository>((ref) {
  final apiService = ref.watch(hackerNewsApiServiceProvider);
  final localDataSource = ref.watch(localDataSourceProvider);
  return HackerNewsRepositoryImpl(apiService, localDataSource);
});

final topStoriesProvider = FutureProvider<List<int>>((ref) async {
  final repository = ref.read(hackerNewsRepositoryProvider);
  final result = await repository.getTopStories();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (stories) => stories,
  );
});
