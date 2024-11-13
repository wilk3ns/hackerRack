import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import 'providers.dart';

final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  final apiService = ref.read(hackerNewsApiServiceProvider);
  return apiService.getUserDetails(userId);
});