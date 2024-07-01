class Speaker {
  final String speakerId;
  final String speakerName;
  final String engName;
  final String thaiName;
  final String image;
  final String faceImage;
  final String horizontalFaceImage;
  final String squareImage;
  final String audio;
  final List<String> voiceStyle;
  final List<String> engVoiceStyle;
  final String ageStyle;
  final String engAgeStyle;
  final List<String> speechStyle;
  final List<String> engSpeechStyle;
  final String speed;
  final String engSpeed;
  final String popularity;
  final String engPopularity;
  final int type;
  final String language;
  final bool status;
  final String gender;
  final String engGender;
  final bool private;
  final List<String> allowUid;
  final List<String> availableLanguage;
  final bool premier;

  Speaker({
    required this.speakerId,
    required this.speakerName,
    required this.engName,
    required this.thaiName,
    required this.image,
    required this.faceImage,
    required this.horizontalFaceImage,
    required this.squareImage,
    required this.audio,
    required this.voiceStyle,
    required this.engVoiceStyle,
    required this.ageStyle,
    required this.engAgeStyle,
    required this.speechStyle,
    required this.engSpeechStyle,
    required this.speed,
    required this.engSpeed,
    required this.popularity,
    required this.engPopularity,
    required this.type,
    required this.language,
    required this.status,
    required this.gender,
    required this.engGender,
    required this.private,
    required this.allowUid,
    required this.availableLanguage,
    required this.premier,
  });

  factory Speaker.fromJson(Map<String, dynamic> json) {
    return Speaker(
      speakerId: json['speaker_id'] ?? '',
      speakerName: json['speaker_name'] ?? '',
      engName: json['eng_name'] ?? '',
      thaiName: json['thai_name'] ?? '',
      image: json['image'] ?? '',
      faceImage: json['face_image'] ?? '',
      horizontalFaceImage: json['horizontal_face_image'] ?? '',
      squareImage: json['square_image'] ?? '',
      audio: json['audio'] ?? '',
      voiceStyle: List<String>.from(json['voice_style'] ?? []),
      engVoiceStyle: List<String>.from(json['eng_voice_style'] ?? []),
      ageStyle: json['age_style'] ?? '',
      engAgeStyle: json['eng_age_style'] ?? '',
      speechStyle: List<String>.from(json['speech_style'] ?? []),
      engSpeechStyle: List<String>.from(json['eng_speech_style'] ?? []),
      speed: json['speed'] ?? '',
      engSpeed: json['eng_speed'] ?? '',
      popularity: json['popularity'] ?? '',
      engPopularity: json['eng_popularity'] ?? '',
      type: json['type'] ?? 0, // Adjust default value as per your requirement
      language: json['language'] ?? '',
      status: json['status'] ?? false,
      gender: json['gender'] ?? '',
      engGender: json['eng_gender'] ?? '',
      private: json['private'] ?? false,
      allowUid: List<String>.from(json['allow_uid'] ?? []),
      availableLanguage: List<String>.from(json['available_language'] ?? []),
      premier: json['premier'] ?? false,
    );
  }
}
