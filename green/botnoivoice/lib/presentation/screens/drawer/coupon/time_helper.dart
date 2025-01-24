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
  DateTime midnight = tz.TZDateTime(bangkok, now.year, now.month, now.day + 1);
  return midnight.difference(now);
}