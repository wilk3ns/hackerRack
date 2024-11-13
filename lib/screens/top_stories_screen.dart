import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/story_providers.dart';
import '../widgets/story_item.dart';

class TopStoriesScreen extends ConsumerWidget {
  const TopStoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topStoriesAsyncValue = ref.watch(topStoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Top Stories")),
      body: topStoriesAsyncValue.when(
        data: (storyIds) => ListView.builder(
          itemCount: storyIds.length,
          itemBuilder: (context, index) {
            return StoryItem(storyId: storyIds[index]);
          },
        ),
        loading: () => const Center(
          child: SizedBox(
            width: 50,
            height: 50,
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

