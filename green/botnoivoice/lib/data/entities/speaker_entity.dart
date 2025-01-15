class SpeakerEntity {
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
  final String languageCode;
  final int price;

  const SpeakerEntity({
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
    required this.languageCode,
    required this.price,
  });

  factory SpeakerEntity.fromJson(Map<String, dynamic> json) {
    return SpeakerEntity(
      speakerId: json['speaker_id'],
      speakerName: json['speaker_name'],
      engName: json['eng_name'],
      thaiName: json['thai_name'],
      image: json['image'],
      faceImage: json['face_image'],
      horizontalFaceImage: json['horizontal_face_image'],
      squareImage: json['square_image'],
      audio: json['audio'],
      voiceStyle: List<String>.from(json['voice_style']),
      ageStyle: json['age_style'],
      speechStyle: List<String>.from(json['speech_style']),
      speed: json['speed'],
      popularity: json['popularity'],
      type: json['type'],
      language: json['language'],
      status: json['status'],
      gender: json['gender'],
      allowUid: List<String>.from(json['allow_uid']),
      availableLanguage: List<String>.from(json['available_language']),
      premier: json['premier'],
      engAgeStyle: json['eng_age_style'],
      engGender: json['eng_gender'],
      engPopularity: json['eng_popularity'],
      engSpeechStyle: List<String>.from(json['eng_speech_style']),
      engSpeed: json['eng_speed'],
      engVoiceStyle: List<String>.from(json['eng_voice_style']),
      canSold: json['can_sold'],
      priceThb: json['price_thb'],
      priceUsd: json['price_usd'],
      userId: json['user_id'],
      languageCode: json['language_code'],
      price: json['price'],
    );
  }
}
