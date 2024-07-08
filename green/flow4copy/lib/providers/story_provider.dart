import 'package:flutter/material.dart';
import '../models/story.dart';

class StoryProvider with ChangeNotifier {
  List<Story> _stories = [];

  List<Story> get stories => _stories;

  void addStory(Story story) {
    _stories.add(story);
    notifyListeners();
  }
}
