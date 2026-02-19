class ResultItem {
  final String imageUrl;
  String script;
  String? audioUrl;

  ResultItem({
    required this.imageUrl,
    required this.script,
    this.audioUrl,
  });
}
