import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

// DO NOT REMOVE ALL COMMENTED CODE IN THIS FILE
// HOW TO RUN ON IOS AND UPDATE PODS
// FOR MacOS M1/M2/M3/M4 Chip
/*
cd ios
rm -rf Podfile.lock Pods
arch -x86_64 pod repo update
arch -x86_64 pod install --repo-update
cd ..
flutter clean
flutter pub get
flutter run
*/

//TODO: Function Save Token to Database
// 1.UID from Firebase
// 2.FCM TOKEN
// 3.Email
// 4.OS: Android or iOS
// 5.Device ID
// 6.Device Name
// 7.Device Model

//TODO: Show Local Notification on Home Screen
// 1.เพิ่มการแจ้งเตือนในหน้า Home แสดง เป็น Local Notification

//TODO: Testing on Android

class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final Logger _logger = Logger();

  /// 🔥 Background Notification Handler
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    _logger.i("🔔 Background Notification: ${message.notification?.title}");
    showNotification(message.notification?.title ?? "No Title",
        message.notification?.body ?? "No Body");
  }

  /// 🔥 Initialize Push Notification Service
  static Future<void> init() async {
    _logger.i("🛠 Initializing Push Notification Service...");

    // ตั้งค่า Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // ตั้งค่า Local Notification
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitSettings = DarwinInitializationSettings();
    const InitializationSettings initSettings =
        InitializationSettings(android: androidInitSettings, iOS: iosInitSettings);
    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // ขออนุญาต Notification
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _logger.i("✅ ได้รับอนุญาตให้ใช้ Notification");

      // ดึง Token สำหรับ FCM
      String? token = await _firebaseMessaging.getToken();
      _logger.i("📲 FCM Token from Device: $token");

      // ตั้งค่าการแจ้งเตือนขณะเปิดแอป
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _logger.i("🔔 Notification ขณะเปิดแอป: ${message.notification?.title}");
        showNotification(message.notification?.title ?? "No Title",
            message.notification?.body ?? "No Body");
      });

      // ตั้งค่าการแจ้งเตือนขณะปิดแอป (กด Notification)
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _logger.i("🔄 เปิดแอปจาก Notification: ${message.notification?.title}");
      });
    } else {
      _logger.w("🚫 ผู้ใช้ไม่อนุญาตให้ใช้ Notification");
    }
  }

  /// 🔔 แสดงแจ้งเตือนภายในแอป
  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'default_channel',
      'Default Notifications',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await _flutterLocalNotificationsPlugin.show(0, title, body, details);
  }
}
