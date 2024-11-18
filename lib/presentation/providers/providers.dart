import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hacker_rack/data/datasources/local_data_source.dart';
import 'package:hacker_rack/data/datasources/local_data_source_impl.dart';
import 'package:hacker_rack/data/datasources/remote_data_source.dart';
import 'package:hacker_rack/data/datasources/remote_data_source_impl.dart';
import 'package:hacker_rack/data/repositories/hacker_news_repository_impl.dart';
import 'package:hacker_rack/domain/repositories/hacker_news_repository.dart';
import 'package:hacker_rack/services/dio_client.dart';
import 'package:hacker_rack/services/hacker_news_api_service.dart';

final dioProvider = Provider<Dio>((ref) => DioClient.createDio());

final apiServiceProvider = Provider<HackerNewsApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return HackerNewsApiService(dio);
});

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  return RemoteDataSourceImpl(ref.watch(apiServiceProvider));
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSourceImpl(
    sharedPreferences: ref.watch(sharedPreferencesProvider),
  );
});

final repositoryProvider = Provider<HackerNewsRepository>((ref) {
  return HackerNewsRepositoryImpl(
    ref.watch(apiServiceProvider),
    ref.watch(localDataSourceProvider),
  );
});

final topStoriesProvider = FutureProvider<List<int>>((ref) async {
  final repository = ref.read(repositoryProvider);
  final result = await repository.getTopStories();
  return result.fold(
    (failure) => throw Exception(failure.message),
    (stories) => stories,
  );
});
