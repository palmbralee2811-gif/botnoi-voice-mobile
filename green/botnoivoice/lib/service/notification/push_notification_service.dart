// import 'dart:convert';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:logger/logger.dart';

// class PushNotificationService {
//   static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
//   static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//   static final Logger _logger = Logger();

//   /// 🔥 Background Notification Handler (เมื่อแอปปิดอยู่)
//   static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     await Firebase.initializeApp();
//     _logger.i("🔔 Background Notification: ${message.notification?.title}");
//     String payloadData = jsonEncode(message.data);
//     showNotification(
//       title: message.notification?.title ?? "No Title",
//       body: message.notification?.body ?? "No Body",
//       payload: payloadData,
//     );
//   }

//   /// 🔥 Initialize Push Notification Service
//   static Future<void> init() async {
//     _logger.i("🛠 Initializing Push Notification Service...");

//     // ตั้งค่า Background Handler
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//     // ตั้งค่า Local Notification
//     const AndroidInitializationSettings androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
//     const DarwinInitializationSettings iosInitSettings = DarwinInitializationSettings();
//     const InitializationSettings initSettings = InitializationSettings(
//         android: androidInitSettings, iOS: iosInitSettings);
//     await _flutterLocalNotificationsPlugin.initialize(initSettings);

//     // ✅ ขออนุญาต Notification สำหรับ iOS (แก้ปัญหา Foreground)
//     await _flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             IOSFlutterLocalNotificationsPlugin>()
//         ?.requestPermissions(
//           alert: true,
//           badge: true,
//           sound: true,
//         );

//     // ✅ ตั้งค่าให้ FirebaseMessaging แสดงแจ้งเตือนแบบ Foreground (iOS)
//     await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // ขออนุญาต Notification
//     NotificationSettings settings = await _firebaseMessaging.requestPermission();
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       _logger.i("✅ ได้รับอนุญาตให้ใช้ Notification");

//       // ดึง Token สำหรับ FCM
//       String? token = await _firebaseMessaging.getToken();
//       _logger.i("📲 FCM Token from Device: $token");

//       // ✅ [แก้ไข] ใช้งาน FirebaseMessaging.onMessage เพื่อให้แสดงแจ้งเตือนใน Foreground
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         _logger.i("🔔 Notification ขณะเปิดแอป: ${message.notification?.title}");
//         String payloadData = jsonEncode(message.data);
//         if (message.notification != null) {
//           showNotification(
//               title: message.notification?.title ?? "No Title",
//               body: message.notification?.body ?? "No Body",
//               payload: payloadData);
//         }
//       });

//       // ✅ ตั้งค่าการแจ้งเตือนขณะปิดแอป (กด Notification)
//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//         _logger.i("🔄 เปิดแอปจาก Notification: ${message.notification?.title}");
//       });
//     } else {
//       _logger.w("🚫 ผู้ใช้ไม่อนุญาตให้ใช้ Notification");
//     }
//   }

//   /// 🔔 แสดงแจ้งเตือนภายในแอป
//   static Future<void> showNotification({
//     required String title,
//     required String body,
//     required String payload,
//   }) async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'channel_id',
//       'channel_name',
//       channelDescription: 'channel_description',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );

//     const DarwinNotificationDetails iosNotificationDetails =
//         DarwinNotificationDetails();

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: iosNotificationDetails,
//     );

//     await _flutterLocalNotificationsPlugin
//         .show(0, title, body, notificationDetails, payload: payload);
//   }
// }
