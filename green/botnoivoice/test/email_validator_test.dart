import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:email_validator/email_validator.dart';
import 'package:string_validator/string_validator.dart';

/// 81%
bool isValidEmail(String email) {
  return isEmail(email);
}

/// 90%
// bool isValidEmail(String email) {
//   return EmailValidator.validate(email);
// }

void main() {
  final logger = Logger();
  int totalTests = 0;
  int totalPassed = 0;
  int totalFailed = 0;
  
  void logResult(String email, bool result, bool expectedResult) {
    try {
      totalTests++;
      if (result == expectedResult) {
        totalPassed++;
        logger.i('PASSED: $email - Expected: ${expectedResult ? "Valid" : "Invalid"}, Result: ${result ? "Valid" : "Invalid"}');
      } else {
        totalFailed++;
        logger.e('ERROR: $email - Expected: ${expectedResult ? "Valid" : "Invalid"}, Result: ${result ? "Valid" : "Invalid"}');
      }
    } catch (e) {
      totalFailed++;
      logger.e('EXCEPTION: $email - Error encountered: $e');
    }
  }

  group('isValidEmail', () {
    test('Test valid email formats', () {
      final validEmails = [
        'user@example.com',
        'firstname.lastname@example.com',
        'user+label@example.co.uk',
        'username123@example-company.com',
        'user@subdomain.example.com',
        'user.name@domain123.org',
        'user_name@domain.name',
        'user-name@example.travel',
        'valid_email@long-domain-example.travel',
      ];

      for (var email in validEmails) {
        final result = isValidEmail(email);
        logResult(email, result, true);
      }
    });

    test('Test invalid email formats', () {
      final invalidEmails = [
        'userexample.com',
        'user@.com',
        '@example.com',
        'user@com',
        'user@domain..com',
        'user@domain.com ',
        'user@ domain.com',
        'user@domain#com.com',
        'user@domain.c',
        'user@-domain.com',
        'user@domain-with-too-many-characters-that-exceeds-the-limit-of-standard-email.com',
        'ben10love#@ggwpez.com',
        'frankza@gg.com',
      ];

      for (var email in invalidEmails) {
        final result = isValidEmail(email);
        logResult(email, result, false);
      }
    });
  });

  tearDownAll(() {
    final double passPercentage = (totalPassed / totalTests) * 100;
    final double failPercentage = (totalFailed / totalTests) * 100;

    logger.i('--- Test Results Summary ---');
    logger.i('Total Tests: $totalTests');
    logger.i('Passed: $totalPassed (${passPercentage.toStringAsFixed(2)}%)');
    logger.e('Failed: $totalFailed (${failPercentage.toStringAsFixed(2)}%)');
  });
}
