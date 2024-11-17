import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/story.dart';
import '../providers/story_providers.dart';
import '../widgets/loading_indicator.dart';
import '../widgets/error_view.dart';

class StoryDetailsScreen extends ConsumerWidget {
  final int storyId;

  const StoryDetailsScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsyncValue = ref.watch(storyProvider(storyId));

    return Scaffold(
      appBar: AppBar(title: const Text("Story Details")),
      body: storyAsyncValue.when(
        data: (story) => StoryDetailsContent(story: story),
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorView(message: error.toString()),
      ),
    );
  }
}

class StoryDetailsContent extends StatelessWidget {
  final Story story;

  const StoryDetailsContent({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(context),
          const SizedBox(height: 10),
          _buildMetadata(),
          const SizedBox(height: 20),
          if (story.url != null) _buildOpenUrlButton(),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final title = story.title ?? story.text;
    if (title == null) {
      return const SizedBox.shrink(); // Empty widget when both title and text are null
    }
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  Widget _buildMetadata() {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(story.time * 1000);
    return Text('by ${story.by} • $dateTime');
  }

  Widget _buildOpenUrlButton() {
    return ElevatedButton(
      onPressed: _launchUrl,
      child: const Text('Open in Browser'),
    );
  }

  Future<void> _launchUrl() async {
    final url = story.url;
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}
