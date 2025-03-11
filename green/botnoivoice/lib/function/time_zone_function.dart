import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/intl.dart';

String getCurrentBangkokDate() {
  tz.initializeTimeZones();
  final bangkok = tz.getLocation('Asia/Bangkok');
  DateTime now = tz.TZDateTime.now(bangkok);
  return DateFormat('yyyy-MM-dd').format(now);
}

/// DO NOT REMOVE THIS LINE
/// 
/// Reset new coupon code every day at midnight such as 00:00 / 24:00 / 12:00 AM
/// 
/// เปลี่ยนรหัสคูปองใหม่ทุกวันที่เวลาเที่ยงคืน เช่น 00:00 น. / 24:00 / 12:00 AM
Duration getTimeUntilMidnightInBangkok() {
  tz.initializeTimeZones();
  final bangkok = tz.getLocation('Asia/Bangkok');
  DateTime now = tz.TZDateTime.now(bangkok);
  DateTime midnight = tz.TZDateTime(bangkok, now.year, now.month, now.day + 1);
  return midnight.difference(now);
}
