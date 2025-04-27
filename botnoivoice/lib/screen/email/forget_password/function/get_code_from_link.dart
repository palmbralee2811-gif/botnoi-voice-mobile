import 'package:logger/logger.dart';

final Logger _logger = Logger(); // For debugging

// Get Code from Link `oobCode=?`
String extractCodeFromLink(String link) {
  try {
    Uri uri = Uri.parse(link);
    return uri.queryParameters['oobCode'] ?? '';
  } catch (e) {
    _logger.e("Error parsing reset link: $e");
    return '';
  }
}
