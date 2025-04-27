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
  final String tier;

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
    required this.tier
  });

  factory SpeakerEntity.fromJson(Map<String, dynamic> json) {
    return SpeakerEntity(
      speakerId: json['speaker_id'] ?? '',
      speakerName: json['speaker_name'] ?? '',
      engName: json['eng_name'] ?? '',
      thaiName: json['thai_name'] ?? '',
      image: json['image'] ?? '',
      faceImage: json['face_image'] ?? '',
      horizontalFaceImage: json['horizontal_face_image'] ?? '',
      squareImage: json['square_image'] ?? '',
      audio: json['audio'] ?? '',
      voiceStyle: (json['voice_style'] as List?)?.map((e) => e.toString()).toList() ?? [],
      ageStyle: json['age_style'] ?? '',
      speechStyle: (json['speech_style'] as List?)?.map((e) => e.toString()).toList() ?? [],
      speed: json['speed'] ?? '',
      popularity: json['popularity'] ?? '',
      type: json['type'] ?? 0,
      language: json['language'] ?? '',
      status: json['status'] ?? false,
      gender: json['gender'] ?? '',
      // DO NOT REMOVE THIS LINE: แปลงจาก JSON เป็น List<String> หรือให้เป็น [] หากเป็น null
      allowUid: (json['allow_uid'] as List?)?.map((e) => e.toString()).toList() ?? [],
      // DO NOT REMOVE THIS LINE: แปลงจาก JSON เป็น List<String> หรือให้เป็น [] หากเป็น null
      availableLanguage: (json['available_language'] as List?)?.map((e) => e.toString()).toList() ?? [],
      premier: json['premier'] ?? false,
      engAgeStyle: json['eng_age_style'] ?? '',
      engGender: json['eng_gender'] ?? '',
      engPopularity: json['eng_popularity'] ?? '',
      // DO NOT REMOVE THIS LINE: แปลงจาก JSON เป็น List<String> หรือให้เป็น [] หากเป็น null
      engSpeechStyle: (json['eng_speech_style'] as List?)?.map((e) => e.toString()).toList() ?? [],
      engSpeed: json['eng_speed'] ?? '',
      // DO NOT REMOVE THIS LINE: แปลงจาก JSON เป็น List<String> หรือให้เป็น [] หากเป็น null
      engVoiceStyle: (json['eng_voice_style'] as List?)?.map((e) => e.toString()).toList() ?? [],
      canSold: json['can_sold'] ?? false,
      priceThb: json['price_thb'] ?? 0,
      priceUsd: json['price_usd'] ?? 0,
      userId: json['user_id'] ?? '',
      languageCode: json['language_code'] ?? '',
      price: json['price'] ?? 0,
      tier: json['tier'] ?? ''
    );
  }

}
