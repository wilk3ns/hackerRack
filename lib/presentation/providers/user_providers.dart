import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hacker_rack/models/user.dart';
import 'providers.dart';

final userProvider = FutureProvider.family<User, String>((ref, userId) async {
  final repository = ref.read(hackerNewsRepositoryProvider);
  final result = await repository.getUser(userId);
  return result.fold(
    (failure) => throw Exception(failure.message),
    (user) => user,
  );
});
