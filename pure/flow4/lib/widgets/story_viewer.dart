import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';
import '../data.dart/data.dart';

class StoryViewer extends StatelessWidget {
  final List<Story> stories;

  StoryViewer({required this.stories});

  @override
  Widget build(BuildContext context) {
    final StoryController controller = StoryController();

    List<StoryItem> storyItems = stories.map((story) {
      return StoryItem.pageImage(
        url: story.imageUrl,
        controller: controller,
        duration: story.duration,
        caption: Text(
          story.userName,
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
      );
    }).toList();

    return Scaffold(
      body: StoryView(
        storyItems: storyItems,
        controller: controller,
        repeat: false,
        onComplete: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
