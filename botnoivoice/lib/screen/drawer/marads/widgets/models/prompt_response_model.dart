class PromptResponse {
  final String title;
  final String text;
  final String promptId;
  final Map<String, dynamic> promptStyle;
  final Map<String, dynamic> language;
  
  // ฟิลด์อื่นๆ ตามต้องการ

  PromptResponse({
    required this.title,
    required this.text,
    required this.promptId,
    required this.promptStyle,
    required this.language,
  });

  // Factory Constructor สำหรับแปลง JSON Map เป็น Object
  factory PromptResponse.fromJson(Map<String, dynamic> json) {
    return PromptResponse(
      title: json['title'] as String? ?? '',
      text: json['text'] as String? ?? '',
      promptId: json['prompt_id'] as String? ?? '',
      promptStyle: json['prompt_style'] as Map<String, dynamic>? ?? {},
      language: json['language'] as Map<String, dynamic>? ?? {},
      // คุณสามารถเพิ่มการตรวจสอบค่า null หรือการแปลงประเภทข้อมูลอื่นๆ ได้ที่นี่
    );
  }

  // เมธอดสำหรับแปลง Object กลับไปเป็น JSON Map (ถ้าจำเป็น)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'text': text,
      'prompt_id': promptId,
      'prompt_style': promptStyle,
      'language': language,
    };
  }
}