// lib/services/api_constants.dart

class ApiConstants {
  static const String baseUrl = "https://api-voice.botnoi.ai";
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

  // สำหรับ Download
  static const String downloadVoiceEndpoint =
      "$baseUrl/api/dashboard/download_voice";
  static const String mergeVoiceEndpoint =
      "$baseUrl/voice/v2/merge_voice_to_s3";

  // --- 1. กุญแจสำหรับการอัปโหลดรูปภาพ ---
  static String Token = "";
  static String botnoiVideoToken = ""; // สำหรับเก็บ Token สร้างวิดีโอ

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
  static const String translateEndpoint =
      "$baseUrl/api/pptx/translate-scripts/"; // ตัวอย่าง URL API

// --- Voice Service Endpoints ---
  // Step 1: Generate Audio
  static const String genskriptUrl =
      'https://api-genvoice.botnoi.ai/voice/v1/generate_voice?provider=studio';
  // Step 2: Save Workspace (State) - NEW
  static const String workspaceEndpoint =
      "$baseUrl/api/genai/genskript-workspaces";
  static const String botnoiIntroSound =
      "https://voice-staging.botnoi.ai/assets/audio/botnoi%20(1).mp3";
}
