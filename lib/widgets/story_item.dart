import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../models/story.dart';
import '../providers/story_providers.dart';

class StoryItem extends ConsumerWidget {
  final int storyId;

  const StoryItem({super.key, required this.storyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsyncValue = ref.watch(storyProvider(storyId));

    return storyAsyncValue.when(
      data: (story) => StoryListTile(story: story),
      loading: () => const ShimmerStoryItem(),
      error:
          (error, stack) => ListTile(
            title: Text('Error loading story'),
            subtitle: Text(error.toString()),
          ),
    );
  }
}

class StoryListTile extends StatelessWidget {
  final Story story;

  const StoryListTile({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final displayTitle = story.title ?? story.text;

    return ListTile(
      title: displayTitle != null
          ? Text(
        displayTitle,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(height: 1.2),
      )
          : const SizedBox.shrink(), // Empty widget if both title and text are null
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [const SizedBox(height: 4), _buildMetadata(context)],
      ),
      onTap: () => context.push('/story/${story.id}'),
    );
  }

  Widget _buildMetadata(BuildContext context) {
    final elapsedTime = timeago.format(
      DateTime.fromMillisecondsSinceEpoch(story.time * 1000),
    );

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _buildMetadataItem(icon: Icons.arrow_upward, text: '${story.score}'),
        _buildDot(),
        _buildMetadataItem(
          icon: Icons.comment_outlined,
          text: '${story.descendants ?? 0}',
        ),
        _buildDot(),
        Text(elapsedTime, style: const TextStyle(color: Colors.grey)),
        _buildDot(),
        Text('by ', style: const TextStyle(color: Colors.grey)),
        GestureDetector(
          onTap: () => context.push('/author/${story.by}'),
          child: Text(
            story.by,
            style: TextStyle(color: Theme.of(context).colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildMetadataItem({required IconData icon, required String text}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildDot() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Text('•', style: TextStyle(color: Colors.grey)),
    );
  }
}

class ShimmerStoryItem extends StatelessWidget {
  const ShimmerStoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 16.0,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(width: 200, height: 14.0, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
