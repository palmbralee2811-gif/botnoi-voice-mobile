/// Represents a generated script project in GenSkript
class Script {
  final String id;
  final String name; // [cite: 883-886]
  final List<String> fileUrls; // [cite: 887-893]
  final String fileType; // image, pdf, or pptx [cite: 894-899]
  final double wordCount; // [cite: 903-905]
  final String language; // [cite: 907-910]
  final String contentType; // [cite: 911-913]
  final String customPrompt; // [cite: 914-917]
  final List<GeneratedScript> generatedScripts; // [cite: 918-922]
  final String voice; // [cite: 935-937]
  final int pointsUsed; // [cite: 938-941]
  final DateTime updatedDate;

  Script({
    required this.id,
    required this.name,
    this.fileUrls = const [],
    this.fileType = 'image',
    this.wordCount = 120,
    this.language = 'th',
    this.contentType = '',
    this.customPrompt = '',
    this.generatedScripts = const [],
    this.voice = 'alexa',
    this.pointsUsed = 0,
    required this.updatedDate,
  });
}

/// Represents individual slide content within a script
class GeneratedScript {
  final int slideNumber; // [cite: 923-925]
  final String content; // [cite: 926-928]
  final String? audioUrl; // [cite: 929-931]

  GeneratedScript({
    required this.slideNumber,
    required this.content,
    this.audioUrl,
  });
}