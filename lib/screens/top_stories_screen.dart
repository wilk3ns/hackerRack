import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/story_providers.dart';
import '../widgets/story_item.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_view.dart';

class TopStoriesScreen extends ConsumerWidget {
  const TopStoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topStoriesAsyncValue = ref.watch(topStoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Top Stories")),
      body: topStoriesAsyncValue.when(
        data:
            (storyIds) => RefreshIndicator(
              onRefresh: () => ref.refresh(topStoriesProvider.future),
              child: StoriesList(storyIds: storyIds),
            ),
        loading: () => const LoadingIndicator(),
        error:
            (error, stack) => ErrorView(
              message: error.toString(),
              onRetry: () => ref.refresh(topStoriesProvider),
            ),
      ),
    );
  }
}

class StoriesList extends StatelessWidget {
  final List<int> storyIds;

  const StoriesList({super.key, required this.storyIds});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: storyIds.length,
      itemBuilder: (context, index) => StoryItem(storyId: storyIds[index]),
    );
  }
}
