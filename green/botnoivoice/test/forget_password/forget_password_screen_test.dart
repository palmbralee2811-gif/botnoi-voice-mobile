import 'package:flutter_test/flutter_test.dart';
import 'package:string_validator/string_validator.dart';

/// **WARNING**
/// กรณีทดสอบ ไม่เป็นไร Firebase Auth สามารถตรวจสอบแทนฟังก์ชันนี้ได้
bool isValidEmail(String email) {
  return isEmail(email);
}

void main() {
  group('isValidEmail', () {
    test('should return true for a valid email', () {
      expect(isValidEmail('user@example.com'), isTrue);
    });

    test('should return false for an email missing "@" symbol', () {
      expect(isValidEmail('userexample.com'), isFalse);
    });

    test('should return false for an email with invalid domain', () {
      expect(isValidEmail('user@.com'), isFalse);
    });

    test('should return false for an empty email', () {
      expect(isValidEmail(''), isFalse);
    });

    test('should return false for an email with spaces', () {
      expect(isValidEmail('user @example.com'), isFalse);
    });

    test('should return false for an email with multiple "@" symbols', () {
      expect(isValidEmail('user@@example.com'), isFalse);
    });

    test('should return false for an email with invalid special characters', () {
      expect(isValidEmail('user!@example.com'), isFalse);
    });

    test('should return true for a valid edge case email', () {
      expect(isValidEmail('user.name+alias@example.co.uk'), isTrue);
    });

    test('should return true for an email with an IDN domain', () {
      expect(isValidEmail('user@โดเมนทดสอบ.com'), isTrue);
    });
  });
}
