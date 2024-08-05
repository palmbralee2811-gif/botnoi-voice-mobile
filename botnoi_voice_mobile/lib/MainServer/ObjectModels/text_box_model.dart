class TextBoxModel {
  String audioId;
  String text;
  int speaker;
  String url;
  String speed;
  String volume;
  bool statusDownload;
  String faceImageUrl;
  String engName;

  TextBoxModel({
    required this.audioId,
    required this.text,
    required this.speaker,
    required this.url,
    required this.speed,
    required this.volume,
    required this.statusDownload,
    this.faceImageUrl = '',
    this.engName = '',
  });

  factory TextBoxModel.fromJson(Map<String, dynamic> json) {
    return TextBoxModel(
      audioId: json['audio_id'] ?? '',
      text: json['text'] ?? '',
      speaker: json['speaker'] ?? 0,
      url: json['url'] ?? '',
      speed: json['speed'] ?? '',
      volume: json['volume'] ?? '',
      statusDownload: json['status_download'] ?? false,
    );
  }
}
