import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../models/user.dart';
import '../providers/user_providers.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_view.dart';
import '../widgets/submissions_list.dart';

class AuthorDetailsScreen extends ConsumerWidget {
  final String authorId;

  const AuthorDetailsScreen({super.key, required this.authorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(userProvider(authorId));

    return Scaffold(
      body: userAsyncValue.when(
        data: (user) => AuthorDetailsContent(user: user),
        loading: () => const LoadingIndicator(),
        error:
            (error, stack) => ErrorView(
              message: error.toString(),
              onRetry: () => ref.refresh(userProvider(authorId)),
            ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  _SliverTabBarDelegate({required this.tabBar, required this.backgroundColor});

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: backgroundColor, child: tabBar);
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}

class AuthorDetailsContent extends ConsumerStatefulWidget {
  final User user;

  const AuthorDetailsContent({super.key, required this.user});

  @override
  ConsumerState<AuthorDetailsContent> createState() =>
      _AuthorDetailsContentState();
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

  Widget _buildUserInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Joined: ${timeago.format(DateTime.fromMillisecondsSinceEpoch(widget.user.created * 1000))}',
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

  @override
  Widget build(BuildContext context) {
    final tabBar = TabBar(
      controller: _tabController,
      labelColor: Theme.of(context).colorScheme.primary,
      tabs: const [Tab(text: 'Posts'), Tab(text: 'Comments')],
    );

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: Text(widget.user.id),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
            ),
            SliverToBoxAdapter(child: _buildUserInfo(context)),
            SliverPersistentHeader(
              delegate: _SliverTabBarDelegate(
                tabBar: tabBar,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              pinned: true,
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            CustomScrollView(
              slivers: [
                SubmissionsList(
                  submissionIds: widget.user.submitted,
                  isComment: false,
                ),
              ],
            ),
            CustomScrollView(
              slivers: [
                SubmissionsList(
                  submissionIds: widget.user.submitted,
                  isComment: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
