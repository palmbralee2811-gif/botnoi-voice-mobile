import 'package:flutter_test/flutter_test.dart';
import 'dart:math';
import 'package:logger/logger.dart';

final _logger = Logger();

void main() {
  group('Coupon Name Extraction', () {
    test('Extract coupon name from message - 1,000 iterations', () {
      runTestIterations(1000);
    });
  });
}

void runTestIterations(int totalIterations) {
  int successCount = 0;
  int failureCount = 0;

  for (int i = 0; i < totalIterations; i++) {
    final message = generateRandomMessage();
    _logger.d('Generated message: $message');
    
    final couponCode = extractCouponCode(message);
    _logger.d('Extracted coupon code: $couponCode');
    
    if (couponCode != null && couponCode.length == 6 && RegExp(r'^[A-Z]{2}\d{4}$').hasMatch(couponCode)) {
      successCount++;
    } else {
      failureCount++;
    }
  }

  final successPercentage = (successCount / totalIterations) * 100;
  final failurePercentage = (failureCount / totalIterations) * 100;

  _logger.i('Total Iterations: $totalIterations');
  _logger.i('Success: $successCount ($successPercentage%)');
  _logger.e('Failure: $failureCount ($failurePercentage%)');

  expect(successCount + failureCount, totalIterations);
  expect(successPercentage + failurePercentage, 100.0);
}

String generateRandomMessage() {
  final randomCoupon = generateRandomCouponName();
  _logger.d('Generated random coupon: $randomCoupon');
  
  return "<div>โบนัสพิเศษ แบบใหม่ พอยท์ฟรีรายวัน</div><div>รับเลย 100 พอยท์ ง่ายๆ แค่ไปที่หน้า ราคาและกด คูปอง </div>\n<div class='noti-text-bold'>✨ $randomCoupon ✨<br/></div><div>รีบเลย จำนวนจำกัด!!</div>";
}

String generateRandomCouponName() {
  const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  const numbers = '0123456789';
  final random = Random();

  final letterPart = String.fromCharCodes(Iterable.generate(2, (_) => letters.codeUnitAt(random.nextInt(letters.length))));
  final numberPart = String.fromCharCodes(Iterable.generate(4, (_) => numbers.codeUnitAt(random.nextInt(numbers.length))));

  return '$letterPart$numberPart';
}

String? extractCouponCode(String message) {
  final regex = RegExp(r'✨\s*([A-Z]{2}\d{4})\s*✨');
  final match = regex.firstMatch(message);
  if (match != null) {
    return match.group(1);
  }
  return null;
}