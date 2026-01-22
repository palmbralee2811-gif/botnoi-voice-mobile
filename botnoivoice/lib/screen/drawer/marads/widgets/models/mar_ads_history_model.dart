class MarAdsHistoryModel {
  final String id;
  final String title;
  final String content;
  final String mode;
  final String style;
  final String points;
  final String chars;
  final bool hasAudio;
  final String duration;
  final String audioUrl;
  final String speakerId;
  final bool isV2FromApi;

  // getter ให้เช็คทั้งจาก ID และจากฟิลด์ที่ API ส่งมา
  bool get isV2 => id.contains('_v2_') || isV2FromApi;

  MarAdsHistoryModel({
    required this.id,
    required this.title,
    required this.content,
    this.mode = 'Basic mode',
    this.style = '-',
    this.points = '0 pt',
    this.chars = '0 ตัวอักษร',
    this.hasAudio = false,
    this.duration = '00:00/00:00',
    this.audioUrl = '',
    this.speakerId = '1',
    this.isV2FromApi = false,
  });

  factory MarAdsHistoryModel.fromJson(Map<String, dynamic> json) {
    // String styleLabel = '-';
    // // ดึง Style ให้ครอบคลุมทุก format ที่ backend อาจส่งมา
    // if (json['prompt_style'] != null) {
    //   if (json['prompt_style'] is Map) {
    //     styleLabel = json['prompt_style']['TH_label'] ??
    //         json['prompt_style']['value'] ??
    //         json['prompt_style']['EN_label'] ??
    //         '-';
    //   } else {
    //     //  รับทุกกรณีที่เป็นไปได้ (String หรืออื่นๆ)
    //     styleLabel = json['prompt_style'].toString();
    //   }
    // }

    final String textContent = json['text'] ?? '';
    final int charCount = textContent.length;
    final int calculatedPoints = charCount * 1;

    return MarAdsHistoryModel(
      id: json['prompt_id'] ?? json['_id'] ?? '',
      title: json['title'] ?? 'ไม่ระบุหัวข้อ',
      content: json['text'] ?? '',
      mode: json['category'] == 'text' ? 'Basic mode' : 'Advanced mode',
      // style: styleLabel,
      style: _parseStyleLabel(json['prompt_style']),
      points: '$calculatedPoints pt',
      chars: '$charCount ตัวอักษร',
      hasAudio: json['audio'] != null && json['audio'].toString().isNotEmpty,
      duration: '00:00/00:00',
      audioUrl: json['audio'] ?? '',
      isV2FromApi: _parseBoolean(json['speaker_v2']),
      speakerId:
          (json['speaker'] != null && json['speaker'].toString().isNotEmpty)
              ? json['speaker'].toString()
              : '1', // กันค่า null หรือ empty string
    );
  }

  // แยก Logic การแกะ Style ออกมา
  static String _parseStyleLabel(dynamic styleJson) {
    if (styleJson == null) return '-';
    if (styleJson is Map) {
      return styleJson['TH_label'] ??
          styleJson['value'] ??
          styleJson['EN_label'] ??
          '-';
    }
    return styleJson.toString();
  }

  // แยก Logic การเช็ค Boolean (รองรับทั้ง String "true"/"1" และ bool)
  static bool _parseBoolean(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    final str = value.toString().toLowerCase();
    return str == 'true' || str == '1';
  }
}
