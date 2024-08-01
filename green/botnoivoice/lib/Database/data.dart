class Data {
  final String speakerId;
  final String engName;
  final String thaiName;
  final String squareImage;
  final String audio;
  final String language;
  final List<String> availableLanguage;

  Data({
    required this.speakerId,
    required this.engName,
    required this.thaiName,
    required this.squareImage,
    required this.audio,
    required this.language,
    required this.availableLanguage,
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
    ),

    // Add more users and their stories
  ];

}
