import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

String getCurrentBangkokDate() {
  tz.initializeTimeZones();
  final bangkok = tz.getLocation('Asia/Bangkok');
  DateTime now = tz.TZDateTime.now(bangkok);
  return DateFormat('yyyy-MM-dd').format(now);
}

Duration getTimeUntilMidnightInBangkok() {
  tz.initializeTimeZones();
  final bangkok = tz.getLocation('Asia/Bangkok');
  DateTime now = tz.TZDateTime.now(bangkok);
  // เวลานับถอยหลัง ให้เป็น 00:00 ตามเวลาประเทศไทย
  DateTime midnight = tz.TZDateTime(bangkok, now.year, now.month, now.day + 1);
  //TODO: ถามพี่เพชรให้แน่ใจว่า เวลานับถอยหลัง เปลี่ยนเป็น รหัสใหม่ ตอนเวลาไหน 00:00 หรือ 08:00 ตามเวลาประเทศไทย
  return midnight.difference(now);
}