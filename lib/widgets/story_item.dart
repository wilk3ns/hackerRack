import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import '../providers/story_providers.dart';

class StoryItem extends ConsumerWidget {
  final int storyId;

  const StoryItem({super.key, required this.storyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsyncValue = ref.watch(storyProvider(storyId));

    return storyAsyncValue.when(
      data: (story) => ListTile(
        title: Text(story.title),
        subtitle: Text('by ${story.by} • ${DateTime.fromMillisecondsSinceEpoch(story.time * 1000)}'),
        onTap: () {
          context.push('/story/${story.id}');
        },
        trailing: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            context.push('/author/${story.by}');
          },
        ),
      ),
      loading: () => ListTile(
        title: Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: double.infinity,
            height: 16.0,
            color: Colors.white,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 14.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
      error: (error, stack) => ListTile(title: Text('Error loading story')),
    );
  }
}