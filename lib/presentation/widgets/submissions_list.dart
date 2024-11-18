import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hacker_rack/presentation/providers/story_providers.dart';
import 'package:hacker_rack/presentation/widgets/story_item.dart';

class SubmissionsList extends ConsumerWidget {
  final List<int> submissionIds;
  final bool isComment;

  const SubmissionsList({
    super.key,
    required this.submissionIds,
    required this.isComment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredSubmissions = submissionIds.take(30).toList();

    if (filteredSubmissions.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Text(
            'No ${isComment ? 'comments' : 'posts'} yet',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        if (index >= filteredSubmissions.length) {
          return const Center();
        }

        final storyId = filteredSubmissions[index];
        return Consumer(
          builder: (context, ref, child) {
            final storyAsync = ref.watch(storyProvider(storyId));

            return storyAsync.when(
              data: (story) {
                final isStoryComment =
                    story.title == null && story.text != null;
                if (isComment != isStoryComment) {
                  return const SizedBox.shrink();
                }
                return StoryItem(storyId: storyId);
              },
              loading:
                  () => ShimmerStoryItem(
                    isDarkMode: Theme.of(context).brightness == Brightness.dark,
                  ),
              error: (_, __) => const SizedBox.shrink(),
            );
          },
        );
      }, childCount: filteredSubmissions.length + 1),
    );
  }
}
