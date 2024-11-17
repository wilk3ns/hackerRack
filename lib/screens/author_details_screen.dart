import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_providers.dart';
import '../models/user.dart';
import '../widgets/story_item.dart';

class AuthorDetailsScreen extends ConsumerWidget {
  final String authorId;

  const AuthorDetailsScreen({super.key, required this.authorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider(authorId));

    return Scaffold(
      appBar: AppBar(title: const Text("Author Details")),
      body: userAsyncValue.when(
        data: (user) => AuthorDetailsContent(user: user),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}

class AuthorDetailsContent extends StatelessWidget {
  final User user;

  const AuthorDetailsContent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Username: ${user.id}', style: Theme.of(context).textTheme.titleLarge),
          Text('Created: ${DateTime.fromMillisecondsSinceEpoch(user.created * 1000)}'),
          Text('Karma: ${user.karma}'),
          if (user.about != null) ...[
            const SizedBox(height: 10),
            Text('About: ${user.about}'),
          ],
          const SizedBox(height: 20),
          const Text('Submitted Posts', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: ListView.builder(
              itemCount: user.submitted.length,
              itemBuilder: (context, index) {
                final postId = user.submitted[index];
                return StoryItem(storyId: postId);
              },
            ),
          ),
        ],
      ),
    );
  }
}
