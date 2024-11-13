import 'package:go_router/go_router.dart';
import 'screens/top_stories_screen.dart';
import 'screens/author_details_screen.dart';
import 'screens/story_details_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'TopStories',
      builder: (context, state) => TopStoriesScreen(),
    ),
    GoRoute(
      path: '/story/:id',
      name: 'StoryDetails',
      builder: (context, state) {
        final storyId = int.parse(state.pathParameters['id']!);
        return StoryDetailsScreen(storyId: storyId);
      },
    ),
    GoRoute(
      path: '/author/:id',
      name: 'AuthorDetails',
      builder: (context, state) {
        final authorId = state.pathParameters['id']!;
        return AuthorDetailsScreen(authorId: authorId);
      },
    ),
  ],
);