// To parse this JSON data, do
//
//     final speaker = speakerFromJson(jsonString);

import 'dart:convert';

Speaker speakerFromJson(String str) => Speaker.fromJson(json.decode(str));

String speakerToJson(Speaker data) => json.encode(data.toJson());

class Speaker {
    String message;
    List<Response> response;
    int status;

    Speaker({
        required this.message,
        required this.response,
        required this.status,
    });

    factory Speaker.fromJson(Map<String, dynamic> json) => Speaker(
        message: json["message"],
        response: List<Response>.from(json["response"].map((x) => Response.fromJson(x))),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "response": List<dynamic>.from(response.map((x) => x.toJson())),
        "status": status,
    };
}

class Response {
    String speakerId;
    String speakerName;
    String engName;
    String thaiName;
    String image;
    String faceImage;
    String horizontalFaceImage;
    String squareImage;
    String audio;
    List<String> voiceStyle;
    List<String> engVoiceStyle;
    AgeStyle ageStyle;
    EngAgeStyle engAgeStyle;
    List<SpeechStyle> speechStyle;
    List<EngSpeechStyle> engSpeechStyle;
    Speed speed;
    EngSpeed engSpeed;
    Popularity popularity;
    EngPopularity engPopularity;
    int? type;
    String language;
    bool status;
    Gender gender;
    EngGender engGender;
    bool private;
    List<String> allowUid;
    List<AvailableLanguage> availableLanguage;
    bool premier;
    bool? canSold;
    int? priceThb;
    double? priceUsd;
    String? userId;
    List<String>? workTag;
    List<String>? engWorkTag;
    List<AvailableLanguage>? workLang;
    String? description;
    String? engDescription;
    String? greet;
    String? engGreet;
    int? price;
    int? minimumWords;
    String? workDays;
    int? editTimes;
    bool? ot;
    String? speakerImage;
    String? bannerImage;
    List<String>? speakerAudio;
    List<String>? aiAudio;
    List<String>? speakerVideo;
    String? speakerNoBg;

    Response({
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
        this.canSold,
        this.priceThb,
        this.priceUsd,
        this.userId,
        this.workTag,
        this.engWorkTag,
        this.workLang,
        this.description,
        this.engDescription,
        this.greet,
        this.engGreet,
        this.price,
        this.minimumWords,
        this.workDays,
        this.editTimes,
        this.ot,
        this.speakerImage,
        this.bannerImage,
        this.speakerAudio,
        this.aiAudio,
        this.speakerVideo,
        this.speakerNoBg,
    });

    factory Response.fromJson(Map<String, dynamic> json) => Response(
        speakerId: json["speaker_id"],
        speakerName: json["speaker_name"],
        engName: json["eng_name"],
        thaiName: json["thai_name"],
        image: json["image"],
        faceImage: json["face_image"],
        horizontalFaceImage: json["horizontal_face_image"],
        squareImage: json["square_image"],
        audio: json["audio"],
        voiceStyle: List<String>.from(json["voice_style"].map((x) => x)),
        engVoiceStyle: List<String>.from(json["eng_voice_style"].map((x) => x)),
        ageStyle: ageStyleValues.map[json["age_style"]]!,
        engAgeStyle: engAgeStyleValues.map[json["eng_age_style"]]!,
        speechStyle: List<SpeechStyle>.from(json["speech_style"].map((x) => speechStyleValues.map[x]!)),
        engSpeechStyle: List<EngSpeechStyle>.from(json["eng_speech_style"].map((x) => engSpeechStyleValues.map[x]!)),
        speed: speedValues.map[json["speed"]]!,
        engSpeed: engSpeedValues.map[json["eng_speed"]]!,
        popularity: popularityValues.map[json["popularity"]]!,
        engPopularity: engPopularityValues.map[json["eng_popularity"]]!,
        type: json["type"],
        language: json["language"],
        status: json["status"],
        gender: genderValues.map[json["gender"]]!,
        engGender: engGenderValues.map[json["eng_gender"]]!,
        private: json["private"],
        allowUid: List<String>.from(json["allow_uid"].map((x) => x)),
        availableLanguage: List<AvailableLanguage>.from(json["available_language"].map((x) => availableLanguageValues.map[x]!)),
        premier: json["premier"],
        canSold: json["can_sold"],
        priceThb: json["price_thb"],
        priceUsd: json["price_usd"]?.toDouble(),
        userId: json["user_id"],
        workTag: json["work_tag"] == null ? [] : List<String>.from(json["work_tag"]!.map((x) => x)),
        engWorkTag: json["eng_work_tag"] == null ? [] : List<String>.from(json["eng_work_tag"]!.map((x) => x)),
        workLang: json["work_lang"] == null ? [] : List<AvailableLanguage>.from(json["work_lang"]!.map((x) => availableLanguageValues.map[x]!)),
        description: json["description"],
        engDescription: json["eng_description"],
        greet: json["greet"],
        engGreet: json["eng_greet"],
        price: json["price"],
        minimumWords: json["minimum_words"],
        workDays: json["work_days"],
        editTimes: json["edit_times"],
        ot: json["OT"],
        speakerImage: json["speaker_image"],
        bannerImage: json["banner_image"],
        speakerAudio: json["speaker_audio"] == null ? [] : List<String>.from(json["speaker_audio"]!.map((x) => x)),
        aiAudio: json["ai_audio"] == null ? [] : List<String>.from(json["ai_audio"]!.map((x) => x)),
        speakerVideo: json["speaker_video"] == null ? [] : List<String>.from(json["speaker_video"]!.map((x) => x)),
        speakerNoBg: json["speaker_no_bg"],
    );

    Map<String, dynamic> toJson() => {
        "speaker_id": speakerId,
        "speaker_name": speakerName,
        "eng_name": engName,
        "thai_name": thaiName,
        "image": image,
        "face_image": faceImage,
        "horizontal_face_image": horizontalFaceImage,
        "square_image": squareImage,
        "audio": audio,
        "voice_style": List<dynamic>.from(voiceStyle.map((x) => x)),
        "eng_voice_style": List<dynamic>.from(engVoiceStyle.map((x) => x)),
        "age_style": ageStyleValues.reverse[ageStyle],
        "eng_age_style": engAgeStyleValues.reverse[engAgeStyle],
        "speech_style": List<dynamic>.from(speechStyle.map((x) => speechStyleValues.reverse[x])),
        "eng_speech_style": List<dynamic>.from(engSpeechStyle.map((x) => engSpeechStyleValues.reverse[x])),
        "speed": speedValues.reverse[speed],
        "eng_speed": engSpeedValues.reverse[engSpeed],
        "popularity": popularityValues.reverse[popularity],
        "eng_popularity": engPopularityValues.reverse[engPopularity],
        "type": type,
        "language": language,
        "status": status,
        "gender": genderValues.reverse[gender],
        "eng_gender": engGenderValues.reverse[engGender],
        "private": private,
        "allow_uid": List<dynamic>.from(allowUid.map((x) => x)),
        "available_language": List<dynamic>.from(availableLanguage.map((x) => availableLanguageValues.reverse[x])),
        "premier": premier,
        "can_sold": canSold,
        "price_thb": priceThb,
        "price_usd": priceUsd,
        "user_id": userId,
        "work_tag": workTag == null ? [] : List<dynamic>.from(workTag!.map((x) => x)),
        "eng_work_tag": engWorkTag == null ? [] : List<dynamic>.from(engWorkTag!.map((x) => x)),
        "work_lang": workLang == null ? [] : List<dynamic>.from(workLang!.map((x) => availableLanguageValues.reverse[x])),
        "description": description,
        "eng_description": engDescription,
        "greet": greet,
        "eng_greet": engGreet,
        "price": price,
        "minimum_words": minimumWords,
        "work_days": workDays,
        "edit_times": editTimes,
        "OT": ot,
        "speaker_image": speakerImage,
        "banner_image": bannerImage,
        "speaker_audio": speakerAudio == null ? [] : List<dynamic>.from(speakerAudio!.map((x) => x)),
        "ai_audio": aiAudio == null ? [] : List<dynamic>.from(aiAudio!.map((x) => x)),
        "speaker_video": speakerVideo == null ? [] : List<dynamic>.from(speakerVideo!.map((x) => x)),
        "speaker_no_bg": speakerNoBg,
    };
}

enum AgeStyle {
    AGE_STYLE,
    EMPTY,
    PURPLE
}

final ageStyleValues = EnumValues({
    "วัยรุ่น": AgeStyle.AGE_STYLE,
    "วัยผู้ใหญ่": AgeStyle.EMPTY,
    "วัยเด็ก": AgeStyle.PURPLE
});

enum AvailableLanguage {
    AR,
    DE,
    EN,
    ES,
    FIL,
    FR,
    ID,
    JA,
    KM,
    KO,
    LO,
    MS,
    MY,
    NL,
    PT_BR,
    RU,
    TH,
    VI,
    ZH
}

final availableLanguageValues = EnumValues({
    "ar": AvailableLanguage.AR,
    "de": AvailableLanguage.DE,
    "en": AvailableLanguage.EN,
    "es": AvailableLanguage.ES,
    "fil": AvailableLanguage.FIL,
    "fr": AvailableLanguage.FR,
    "id": AvailableLanguage.ID,
    "ja": AvailableLanguage.JA,
    "km": AvailableLanguage.KM,
    "ko": AvailableLanguage.KO,
    "lo": AvailableLanguage.LO,
    "ms": AvailableLanguage.MS,
    "my": AvailableLanguage.MY,
    "nl": AvailableLanguage.NL,
    "pt-br": AvailableLanguage.PT_BR,
    "ru": AvailableLanguage.RU,
    "th": AvailableLanguage.TH,
    "vi": AvailableLanguage.VI,
    "zh": AvailableLanguage.ZH
});

enum EngAgeStyle {
    ADULT,
    CHILD,
    TEENS
}

final engAgeStyleValues = EnumValues({
    "Adult": EngAgeStyle.ADULT,
    "Child": EngAgeStyle.CHILD,
    "Teens": EngAgeStyle.TEENS
});

enum EngGender {
    FEMALE,
    MALE
}

final engGenderValues = EnumValues({
    "Female": EngGender.FEMALE,
    "Male": EngGender.MALE
});

enum EngPopularity {
    EMPTY,
    POPULAR
}

final engPopularityValues = EnumValues({
    "-": EngPopularity.EMPTY,
    "Popular": EngPopularity.POPULAR
});

enum EngSpeechStyle {
    ADVERTISING_SPOT,
    ANIME,
    CHARACTER,
    DOCUMENTARY,
    FOREIGN_VOICE,
    LOCAL,
    NARRATING,
    NARRATING_CHARACTER,
    NEWS_READING,
    STORYTELLING,
    TEACHING
}

final engSpeechStyleValues = EnumValues({
    "Advertising Spot": EngSpeechStyle.ADVERTISING_SPOT,
    "Anime": EngSpeechStyle.ANIME,
    "Character": EngSpeechStyle.CHARACTER,
    "Documentary": EngSpeechStyle.DOCUMENTARY,
    "Foreign Voice": EngSpeechStyle.FOREIGN_VOICE,
    "Local": EngSpeechStyle.LOCAL,
    "Narrating": EngSpeechStyle.NARRATING,
    "Narrating,Character": EngSpeechStyle.NARRATING_CHARACTER,
    "News Reading": EngSpeechStyle.NEWS_READING,
    "Storytelling": EngSpeechStyle.STORYTELLING,
    "Teaching": EngSpeechStyle.TEACHING
});

enum EngSpeed {
    FAST,
    NORMAL,
    SLOW
}

final engSpeedValues = EnumValues({
    "Fast": EngSpeed.FAST,
    "Normal": EngSpeed.NORMAL,
    "Slow": EngSpeed.SLOW
});

enum Gender {
    EMPTY,
    GENDER
}

final genderValues = EnumValues({
    "ผู้หญิง": Gender.EMPTY,
    "ผู้ชาย": Gender.GENDER
});

enum Popularity {
    EMPTY,
    POPULARITY
}

final popularityValues = EnumValues({
    "ยอดนิยม": Popularity.EMPTY,
    "-": Popularity.POPULARITY
});

enum SpeechStyle {
    AMBITIOUS,
    CUNNING,
    EMPTY,
    FLUFFY,
    HILARIOUS,
    INDECENT,
    INDIGO,
    MAGENTA,
    PURPLE,
    SPEECH_STYLE,
    STICKY,
    TENTACLED
}

final speechStyleValues = EnumValues({
    "สไตล์อนิเมะ": SpeechStyle.AMBITIOUS,
    "สไตล์โฆษณา": SpeechStyle.CUNNING,
    "สไตล์เล่าเรื่อง": SpeechStyle.EMPTY,
    "สไตล์สปอตโฆษณา": SpeechStyle.FLUFFY,
    "สไตล์อาจารย์": SpeechStyle.HILARIOUS,
    "สไตล์ท้องถิ่น": SpeechStyle.INDECENT,
    "สไตล์เสียงต่างประเทศ": SpeechStyle.INDIGO,
    "สไตล์ตัวละครอนิเมะ": SpeechStyle.MAGENTA,
    "สไตล์อ่านข่าว": SpeechStyle.PURPLE,
    "สไตล์บรรยาย": SpeechStyle.SPEECH_STYLE,
    "สไตล์ตัวละคร": SpeechStyle.STICKY,
    "สไตล์สารคดี": SpeechStyle.TENTACLED
});

enum Speed {
    EMPTY,
    PURPLE,
    SPEED
}

final speedValues = EnumValues({
    "พูดกลาง": Speed.EMPTY,
    "พูดช้า": Speed.PURPLE,
    "พูดเร็ว": Speed.SPEED
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
            reverseMap = map.map((k, v) => MapEntry(v, k));
            return reverseMap;
    }
}
