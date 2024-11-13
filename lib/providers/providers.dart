import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../services/hacker_news_api_service.dart';
import '../services/dio_client.dart';

final dioProvider = Provider<Dio>((ref) => DioClient.createDio());

final hackerNewsApiServiceProvider = Provider<HackerNewsApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return HackerNewsApiService(dio);
});