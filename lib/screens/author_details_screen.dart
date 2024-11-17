import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hacker_rack/providers/story_providers.dart';

import '../providers/user_providers.dart';
import '../models/user.dart';
import '../widgets/story_item.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_view.dart';
import 'package:timeago/timeago.dart' as timeago;

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
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          onRetry: () => ref.refresh(userProvider(authorId)),
        ),
      ),
    );
  }
}

class AuthorDetailsContent extends ConsumerStatefulWidget {
  final User user;

  const AuthorDetailsContent({super.key, required this.user});

  @override
  ConsumerState<AuthorDetailsContent> createState() => _AuthorDetailsContentState();
}

class _AuthorDetailsContentState extends ConsumerState<AuthorDetailsContent>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUserInfo(context),
        const SizedBox(height: 16),
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(text: 'Posts'),
            Tab(text: 'Comments'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildSubmissionsList(isComments: false),
              _buildSubmissionsList(isComments: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.user.id,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(
            'Joined ${timeago.format(DateTime.fromMillisecondsSinceEpoch(widget.user.created * 1000))}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'Karma: ${widget.user.karma}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (widget.user.about != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.user.about!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubmissionsList({required bool isComments}) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {}); // Trigger refresh for this widget
      },
      child: Consumer(
        builder: (context, ref, child) {
          final submissions = widget.user.submitted;

          if (submissions.isEmpty) {
            return Center(
              child: Text(
                'No ${isComments ? 'comments' : 'posts'} yet',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          final filteredSubmissions = submissions
              .where((id) {
            final story = ref.read(storyProvider(id)).maybeWhen(data: (story) => story, orElse: () => null);
            return isComments ? story?.title == null : story?.title != null;
          })
              .toList();

          if (filteredSubmissions.isEmpty) {
            return Center(
              child: Text(
                'No ${isComments ? 'comments' : 'posts'} yet',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            );
          }

          return ListView.builder(
            itemCount: filteredSubmissions.length,
            itemBuilder: (context, index) {
              final storyId = filteredSubmissions[index];
              return StoryItem(storyId: storyId);
            },
          );
        },
      ),
    );
  }

}
