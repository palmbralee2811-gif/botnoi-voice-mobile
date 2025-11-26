// ====== response จาก create_prompt_ads ======
class PromptResponse {
  final String title;
  final String text;
  final String promptId;
  final Map<String, dynamic> promptStyle;
  final Map<String, dynamic> language;

  PromptResponse({
    required this.title,
    required this.text,
    required this.promptId,
    required this.promptStyle,
    required this.language,
  });

  factory PromptResponse.fromJson(Map<String, dynamic> json) {
    return PromptResponse(
      title: json['title'] as String? ?? '',
      text: json['text'] as String? ?? '',
      promptId: json['prompt_id'] as String? ?? '',
      promptStyle: json['prompt_style'] as Map<String, dynamic>? ?? {},
      language: json['language'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
      'prompt_id': promptId,
      'prompt_style': promptStyle,
      'language': language,
    };
  }
}

// ====== ใช้ตอนยิง add_workspace_prompt ======

class PromptLanguage {
  final String value;

  PromptLanguage({required this.value});

  Map<String, dynamic> toJson() => {'value': value};
}

class PromptStyle {
  final String thLabel;
  final String enLabel;
  final String value;

  PromptStyle({
    required this.thLabel,
    required this.enLabel,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
        'TH_label': thLabel,
        'EN_label': enLabel,
        'value': value,
      };
}

class AddWorkspacePromptRequest {
  final String title;
  final String audio;
  final String category;
  final String html;
  final bool isDownload;
  final bool isDownloaded;
  final bool isEdit;
  final bool isPlaying;
  final bool isGenerate;
  final PromptLanguage language;
  final String promptId;
  final PromptStyle promptStyle;
  final String speaker;
  final String speed;
  final String text;
  final String textRead;
  final String textReadWithDelay;
  final String volume;

  AddWorkspacePromptRequest({
    required this.title,
    required this.audio,
    required this.category,
    required this.html,
    required this.isDownload,
    required this.isDownloaded,
    required this.isEdit,
    required this.isPlaying,
    required this.isGenerate,
    required this.language,
    required this.promptId,
    required this.promptStyle,
    required this.speaker,
    required this.speed,
    required this.text,
    required this.textRead,
    required this.textReadWithDelay,
    required this.volume,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'audio': audio,
      'category': category,
      'html': html,
      'isDownload': isDownload,
      'isDownloaded': isDownloaded,
      'isEdit': isEdit,
      'isPlaying': isPlaying,
      'isgenerate': isGenerate,
      'language': language.toJson(),
      'prompt_id': promptId,
      'prompt_style': promptStyle.toJson(),
      'speaker': speaker,
      'speed': speed,
      'text': text,
      'text_read': textRead,
      'text_read_with_delay': textReadWithDelay,
      'volume': volume,
    };
  }
}
