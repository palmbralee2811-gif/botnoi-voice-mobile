class SpeakerModel {
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
  final String ageStyle;
  final List<String> speechStyle;
  final String speed;
  final String popularity;
  final int type;
  final String language;
  final bool status;
  final String gender;
  final bool isPrivate;
  final List<String> allowUid;
  final List<String> availableLanguage;
  final bool premier;
  final String engAgeStyle;
  final String engGender;
  final String engPopularity;
  final List<String> engSpeechStyle;
  final String engSpeed;
  final List<String> engVoiceStyle;
  final bool canSold;
  final int priceThb;
  final int priceUsd;
  final String userId;

  const SpeakerModel({
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
    required this.ageStyle,
    required this.speechStyle,
    required this.speed,
    required this.popularity,
    required this.type,
    required this.language,
    required this.status,
    required this.gender,
    required this.isPrivate,
    required this.allowUid,
    required this.availableLanguage,
    required this.premier,
    required this.engAgeStyle,
    required this.engGender,
    required this.engPopularity,
    required this.engSpeechStyle,
    required this.engSpeed,
    required this.engVoiceStyle,
    required this.canSold,
    required this.priceThb,
    required this.priceUsd,
    required this.userId,
  });
}
