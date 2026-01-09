
// lib/services/api_constants.dart

class ApiConstants {
  static const String baseUrl = "https://api-voice-staging.botnoi.ai";
  static const String uploadEndpoint = "$baseUrl/api/genai/upload_image";

  static const String generateEndpoint = "$baseUrl/openapi/v1/generate-scripts";

  // PDF Endpoints
  static const String countPdf = "$baseUrl/api/genai/count_pdf";
  static const String uploadPdf = "$baseUrl/api/genai/upload_pdf";
  static const String convertPdf = "$baseUrl/api/pptx/convert-pdf-img";

  // PPTX Endpoints
  static const String countPptx = "$baseUrl/api/genai/count_pptx";
  static const String uploadPptx = "$baseUrl/api/genai/upload_pptx";
  static const String convertPptx = "$baseUrl/api/pptx/convert-pptx-img";

  // --- 1. กุญแจสำหรับการอัปโหลดรูปภาพ ---
  static const String Token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NjgwMTIwOTUsImlhdCI6MTc2NzkyNTY5NSwibmJmIjoxNzY3OTI1Njk1LCJ1aWQiOiIwNzk4MGM4Zi1jNzVkLTUyY2MtOTk0YS04YTVlN2YwZjY4MGYiLCJ1c2VyX2lkIjoiTVY0all1aXkwMVVVazlBOUZpYWNQVUl1dTBxMSIsInVzZXJfdHlwZSI6ImxpbmtlZF9hY2NvdW50In0.4zVlA0kgN6Gj-j-UFTcVSUJhlnt1W8N3KrQkBxbx088";
  
  // Headers สำหรับอัปโหลดรูปภาพ (Multipart)
  static Map<String, String> get uploadHeaders => {
    "Authorization": "Bearer $Token", // เช็คใน F12 ว่ามีคำว่า Bearer ไหม
    "Accept": "application/json",
  };

  // Headers สำหรับการสร้างข้อความ (JSON)
  static Map<String, String> get generateHeaders => {
    "Content-Type": "application/json",
    "Authorization": "Bearer $Token",
    "Accept": "application/json",
  };

  // เพิ่มใน ApiConstants
  static const String translateEndpoint = "$baseUrl/api/pptx/translate-scripts/"; // ตัวอย่าง URL API

  static const String genskriptUrl = '$baseUrl/voice/v2/genskript_content_type';
  
  // เพิ่มส่วนนี้เพื่อเก็บ Headers
  // static const Map<String, String> headers = {
  //   "Content-Type": "application/json",
  //   "Accept": "application/json",
  //   // คัดลอกค่าจาก F12 มาใส่ที่นี่
  //   "Referer": "https://voice-staging.botnoi.ai/", 
  //   "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36",
  //   // หาก API ต้องการค่าอื่นๆ เช่น Origin หรือ Cookie สามารถเพิ่มได้ที่นี่
  //   "Origin": "https://voice-staging.botnoi.ai",

  //   "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE3NjY3NDUwMzcsImlhdCI6MTc2NjY1ODYzNywibmJmIjoxNzY2NjU4NjM3LCJ1aWQiOiIwNzk4MGM4Zi1jNzVkLTUyY2MtOTk0YS04YTVlN2YwZjY4MGYiLCJ1c2VyX2lkIjoiTVY0all1aXkwMVVVazlBOUZpYWNQVUl1dTBxMSIsInVzZXJfdHlwZSI6ImxpbmtlZF9hY2NvdW50In0.yiS0J0FZDx3mTa-UdZvdM0I4pOpzpm4NlXmMn1R8Gcg",
  // };
}