import 'package:dartz/dartz.dart';
import 'package:hacker_rack/core/errors/failures.dart';
import 'package:hacker_rack/domain/repositories/hacker_news_repository.dart';

class GetTopStories {
  final HackerNewsRepository repository;

  GetTopStories(this.repository);

  Future<Either<Failure, List<int>>> call() => repository.getTopStories();
}
