import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

String _extractCodeFromLink(String link) {
  try {
    // ตรวจสอบรูปแบบเบื้องต้นของลิงก์
    if (!link.startsWith('https://') && !link.startsWith('http://')) {
      _logger.e("Invalid link format");
      return '';
    }

    Uri uri = Uri.parse(link);
    String? code = uri.queryParameters['oobCode'];

    // ตรวจสอบความยาวและรูปแบบของรหัสเพิ่มเติม
    if (code != null &&
        code.isNotEmpty &&
        RegExp(r'^[A-Za-z0-9_-]{10,}$').hasMatch(code)) {
      return code;
    } else {
      _logger.e("Invalid or missing code in link");
      return '';
    }
  } catch (e) {
    _logger.e("Error parsing reset link: $e");
    return '';
  }
}

void main() {
  group('_extractCodeFromLink', () {
    test('ควรคืนค่าโค้ดเมื่อได้รับลิงก์ที่ถูกต้อง', () {
      String link = 'https://example.com/reset?oobCode=abcdef12345';
      String result = _extractCodeFromLink(link);
      expect(result, 'abcdef12345');
    });

    test('ควรคืนค่าเป็นค่าว่างเมื่อได้รับลิงก์ที่ไม่ถูกต้อง', () {
      String link = 'invalid_link';
      String result = _extractCodeFromLink(link);
      expect(result, '');
    });

    test('ควรคืนค่าเป็นค่าว่างเมื่อไม่มีพารามิเตอร์ oobCode', () {
      String link = 'https://example.com/reset?otherParam=xyz';
      String result = _extractCodeFromLink(link);
      expect(result, '');
    });

    test('ควรคืนค่าเป็นค่าว่างเมื่อโค้ดไม่ตรงตามรูปแบบ', () {
      String link = 'https://example.com/reset?oobCode=short';
      String result = _extractCodeFromLink(link);
      expect(result, '');
    });
  });
}
