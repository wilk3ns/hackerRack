import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/story_providers.dart';

class StoryDetailsScreen extends ConsumerWidget {
  final int storyId;

  const StoryDetailsScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsyncValue = ref.watch(storyProvider(storyId));

    return Scaffold(
      appBar: AppBar(title: const Text("Story Details")),
      body: storyAsyncValue.when(
        data: (story) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(story.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 10),
              Text('by ${story.by} • ${DateTime.fromMillisecondsSinceEpoch(story.time * 1000)}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final url = story.url;
                  if (url != null && await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(Uri.parse(url));
                  }
                },
                child: const Text('Open in Browser'),
              ),
            ],
          ),
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