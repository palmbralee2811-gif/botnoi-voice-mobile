class VoiceRequestModel {
  final String audioId;
  final String language;
  final int speaker;
  final String speed;
  final String text;
  final String textDelay;
  final String typeMedia;
  final String volume;

  VoiceRequestModel({
    required this.audioId,
    required this.language,
    required this.speaker,
    required this.speed,
    required this.text,
    required this.textDelay,
    required this.typeMedia,
    required this.volume,
  });

  Map<String, dynamic> toJson() {
    return {
      'audio_id': audioId,
      'language': language,
      'speaker': speaker,
      'speed': speed,
      'text': text,
      'text_delay': textDelay,
      'type_media': typeMedia,
      'volume': volume,
    };
  }
}
