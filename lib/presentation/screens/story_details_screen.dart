import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:hacker_rack/models/story.dart';
import 'package:hacker_rack/presentation/providers/story_providers.dart';
import 'package:hacker_rack/presentation/widgets/loading_indicator.dart';
import 'package:hacker_rack/presentation/widgets/error_view.dart';

class StoryDetailsScreen extends ConsumerWidget {
  final int storyId;

  const StoryDetailsScreen({super.key, required this.storyId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storyAsyncValue = ref.watch(storyProvider(storyId));

    return Scaffold(
      body: storyAsyncValue.when(
        data: (story) => StoryDetailsContent(story: story),
        loading: () => const LoadingIndicator(),
        error: (error, stack) => ErrorView(message: error.toString()),
      ),
    );
  }
}

class StoryDetailsContent extends StatefulWidget {
  final Story story;

  const StoryDetailsContent({super.key, required this.story});

  @override
  State<StoryDetailsContent> createState() => _StoryDetailsContentState();
}

class _StoryDetailsContentState extends State<StoryDetailsContent> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (widget.story.url != null) {
      _controller =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setNavigationDelegate(
              NavigationDelegate(
                onPageStarted: (String url) {
                  setState(() {});
                },
                onPageFinished: (String url) {
                  setState(() {});
                },
              ),
            )
            ..loadRequest(Uri.parse(widget.story.url!));
    }
  }

  Widget _buildMetadata(BuildContext context) {
    final elapsedTime = timeago.format(
      DateTime.fromMillisecondsSinceEpoch(widget.story.time * 1000),
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.story.title ?? '',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'by ${widget.story.by} • $elapsedTime',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          if (widget.story.text != null) ...[
            const SizedBox(height: 16),
            Text(
              widget.story.text!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Story Details')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMetadata(context),
            if (widget.story.url != null) ...[
              const Divider(),
              SizedBox(
                height: 800,
                child: WebViewWidget(controller: _controller),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton:
          widget.story.url != null
              ? FloatingActionButton(
                onPressed: _launchUrl,
                child: const Icon(Icons.open_in_browser),
              )
              : null,
    );
  }

  Future<void> _launchUrl() async {
    final url = widget.story.url;
    if (url != null && await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }
}
