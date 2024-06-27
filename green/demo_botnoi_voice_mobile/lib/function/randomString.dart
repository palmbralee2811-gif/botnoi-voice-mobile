import 'dart:math';

// ฟังก์ชันสุ่มชื่อไฟล์ a-z, A-Z และ 0-9
String randomString(int length) {
  // const characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  const characters = '0123456789';

  final random = Random();
  return String.fromCharCodes(Iterable.generate(
      length, (_) => characters.codeUnitAt(random.nextInt(characters.length))));
}
