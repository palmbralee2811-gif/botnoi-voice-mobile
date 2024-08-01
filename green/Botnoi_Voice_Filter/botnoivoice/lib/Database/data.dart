class Data {
  final String speakerId;
  final String engName;
  final String thaiName;
  final String squareImage;
  final String audio;
  final String language;
  final List<String> availableLanguage;
  final String gender;

  Data({
    required this.speakerId,
    required this.engName,
    required this.thaiName,
    required this.squareImage,
    required this.audio,
    required this.language,
    required this.availableLanguage,
    required this.gender,
  });
}

class AppDataBase {
  static List<Data> data = [
    Data(
      speakerId: "1",
      engName: 'Ava',
      thaiName: 'เอวา',
      squareImage:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/ava/square_ava.webp',
      audio:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/ava/sound_1_ava.wav',
      language: 'th',
      availableLanguage: ['en', 'id', 'ja', 'lo', 'my', 'th', 'vi', 'zh'],
      gender: "ผู้หญิง",
    ),
    Data(
      speakerId: "59",
      engName: 'Juan',
      thaiName: 'เจวียน',
      squareImage:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/juan/square_juan.webp',
      audio:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/juan/sound_1_juan.wav',
      language: 'ZH',
      availableLanguage: ["zh"],
      gender: "ผู้หญิง",
    ),
    Data(
      speakerId: "64",
      engName: 'Sae',
      thaiName: 'ซาเอะ',
      squareImage:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/sae/square_sae.webp',
      audio:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/sae/sound_1_sae.wav',
      language: 'JA',
      availableLanguage: ["en", "id", "ja", "lo", "my", "th", "vi", "zh"],
      gender: "ผู้หญิง",
    ),
    Data(
      speakerId: "66",
      engName: 'Taufik',
      thaiName: 'เทาฟิก',
      squareImage:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/taufik/square_taufik.webp',
      audio:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/taufik/sound_1_taufik.wav',
      language: 'ID',
      availableLanguage: ["en", "id", "ja", "lo", "my", "th", "vi", "zh"],
      gender: "ผู้ชาย",
    ),
    Data(
      speakerId: "65",
      engName: 'Dia',
      thaiName: 'เดีย',
      squareImage:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/dia/square_dia.webp',
      audio:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/dia/sound_1_dia.wav',
      language: 'ID',
      availableLanguage: ["en", "id", "ja", "lo", "my", "th", "vi", "zh"],
      gender: "ผู้หญิง",
    ),
    Data(
      speakerId: "2",
      engName: 'Bow',
      thaiName: 'โบ',
      squareImage:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/bow/square_bow.webp',
      audio:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/bow/sound_1_bow.wav',
      language: 'th',
      availableLanguage: ['en', 'id', 'ja', 'lo', 'my', 'th', 'vi', 'zh'],
      gender: "ผู้หญิง",
    ),
    Data(
      speakerId: "73",
      engName: 'Phuong',
      thaiName: 'เฟื่อง',
      squareImage:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/phuong/square_phuong.webp',
      audio:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/phuong/sound_1_phuong.wav',
      language: 'VI',
      availableLanguage: ['en', 'id', 'ja', 'lo', 'my', 'th', 'vi', 'zh'],
      gender: "ผู้หญิง",
    ),
    Data(
      speakerId: "77",
      engName: 'Phorn',
      thaiName: 'พร',
      squareImage:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/phorn/square_phorn.webp',
      audio:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/phorn/sound_1_phorn.wav',
      language: 'LO',
      availableLanguage: ["lo"],
      gender: "ผู้หญิง",
    ),
    Data(
      speakerId: "81",
      engName: 'Yati',
      thaiName: 'ยาตี',
      squareImage:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/yati/square_yati.webp',
      audio:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/yati/sound_1_yati.wav',
      language: 'MY',
      availableLanguage: [
                "en",
                "id",
                "ja",
                "lo",
                "my",
                "th",
                "vi",
                "zh"
            ],
      gender: "ผู้หญิง",
    ),
    Data(
      speakerId: "5",
      engName: 'Alan',
      thaiName: 'อลัน',
      squareImage:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/alan/square_alan.webp',
      audio:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/alan/sound_1_alan.wav',
      language: 'th',
      availableLanguage: ['en', 'id', 'ja', 'lo', 'my', 'th', 'vi', 'zh'],
      gender: "ผู้ชาย",
    ),
    Data(
      speakerId: "6",
      engName: 'Siren',
      thaiName: 'ไซเรน',
      squareImage:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/siren/square_siren.webp',
      audio:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/siren/sound_1_siren.wav',
      language: 'th',
      availableLanguage: ['en', 'id', 'ja', 'lo', 'my', 'th', 'vi', 'zh'],
      gender: "ผู้หญิง",
    ),
    Data(
      speakerId: "28",
      engName: 'Ajarn Lin',
      thaiName: 'อาจารย์หลิน',
      squareImage:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/lin/square_lin.webp',
      audio:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/lin/sound_1_lin.wav',
      language: 'th',
      availableLanguage: ['en', 'id', 'ja', 'lo', 'my', 'th', 'vi', 'zh'],
      gender: "ผู้หญิง",
    ),
    Data(
      speakerId: "37",
      engName: 'Poo-Yai Lee',
      thaiName: 'ผู้ใหญ่ลี',
      squareImage:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/lee/square_lee.webp',
      audio:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/lee/sound_1_lee.wav',
      language: 'th',
      availableLanguage: ['en', 'id', 'ja', 'lo', 'my', 'th', 'vi', 'zh'],
      gender: "ผู้ชาย",
    ),
    Data(
      speakerId: "9",
      engName: 'helen',
      thaiName: 'นาเดียร์',
      squareImage:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/nadia/square_nadia.webp',
      audio:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/nadia/sound_1_nadia.wav',
      language: 'en',
      availableLanguage: ['en', 'id', 'ja', 'lo', 'my', 'th', 'vi', 'zh'],
      gender: "ผู้หญิง",
    ),
    Data(
      speakerId: "41",
      engName: 'Ellie',
      thaiName: 'เอลลี่',
      squareImage:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/ellie/square_ellie.webp',
      audio:
          'https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/ellie/sound_1_ellie.wav',
      language: 'en',
      availableLanguage: ['en', 'id', 'ja', 'lo', 'my', 'th', 'vi', 'zh'],
      gender: "ผู้หญิง",
    ),
  ];
}
