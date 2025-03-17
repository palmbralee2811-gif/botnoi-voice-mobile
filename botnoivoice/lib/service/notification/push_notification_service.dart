import 'dart:convert';
import 'package:botnoivoice/service/notification/fcm_token_service.dart';
import 'package:botnoivoice/ui/dialog/open_app_settings/open_app_settings_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final Logger _logger = Logger();

  /// 🔥 Background Notification Handler (เมื่อแอปปิดอยู่)
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    _logger.i("🔔 Background Notification: ${message.notification?.title}");
    String payloadData = jsonEncode(message.data);
    showNotification(
      title: message.notification?.title ?? "No Title",
      body: message.notification?.body ?? "No Body",
      payload: payloadData,
    );
  }

  /// 🔥 Initialize Push Notification Service
  static Future<void> init(BuildContext context) async {
    _logger.i("🛠 Initializing Push Notification Service...");

    // ตั้งค่า Background Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // ตั้งค่า Local Notification
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
        android: androidInitSettings, iOS: iosInitSettings);
    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    // ✅ ขออนุญาต Notification สำหรับ iOS
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    // ✅ ตั้งค่าให้ FirebaseMessaging แสดงแจ้งเตือนแบบ Foreground
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 🔄 **ตรวจสอบสิทธิ์ Notification**
    NotificationSettings settings =
        await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _logger.i("✅ ผู้ใช้ยอมรับ Notification แล้ว");

      // ✅ ดึง Token สำหรับ FCM
      String? token = await _firebaseMessaging.getToken();
      _logger.i("📲 FCM Token from Device: $token");

      // ✅ อัปเดต FCM Token ไปยัง Server
      if (token != null) {
        final fcmService = FcmTokenService();
        bool success = await fcmService.updateFcmToken(context, token);
        if (success) {
          _logger.i("✅ อัปเดต FCM Token ไปยัง Server สำเร็จ");
        } else {
          _logger.e("❌ อัปเดต FCM Token ไม่สำเร็จ");
        }
      }
    } else {
      _logger.w("🚫 ผู้ใช้ปฏิเสธ Notification");

      /// ✅ แจ้งให้ผู้ใช้ไปเปิดสิทธิ์แจ้งเตือนเอง
      /// 🔄 `Future.delayed(Duration.zero, () {...})`
      /// - ใช้เพื่อ **เลื่อนการรันโค้ดไปยัง event loop ถัดไป**
      /// - ป้องกันปัญหา `showDialog()` ถูกเรียกก่อนที่ UI จะโหลดเสร็จ
      /// - ทำให้ `Dialog` แสดงผลได้ถูกต้อง โดยไม่มี error จาก `context`
      Future.delayed(
        Duration.zero,
        () {
          OpenAppSettingsDialog(
            context: context,
            //สิทธิ์ถูกปฏิเสธ กรุณาไปที่การตั้งค่า
            text: 'audio_player.permission_denied'.tr(),
          ).showPermissionDeniedDialog();
        },
      );
    }

    // ✅ **Update FCM Token when user logs in from a new device**
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      _logger.i("🔄 FCM Token เปลี่ยนใหม่: $newToken");

      final fcmService = FcmTokenService();
      bool success = await fcmService.updateFcmToken(context, newToken);
      if (success) {
        _logger.i("✅ อัปเดต FCM Token ใหม่ไปยัง Server สำเร็จ");
      } else {
        _logger.e("❌ อัปเดต FCM Token ใหม่ไม่สำเร็จ");
      }
    });

    // ✅ ตั้งค่าการแจ้งเตือนขณะเปิดแอป
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.i("🔔 Notification ขณะเปิดแอป: ${message.notification?.title}");
      String payloadData = jsonEncode(message.data);
      if (message.notification != null) {
        showNotification(
            title: message.notification?.title ?? "No Title",
            body: message.notification?.body ?? "No Body",
            payload: payloadData);
      }
    });

    // ✅ ตั้งค่าการแจ้งเตือนขณะปิดแอป (กด Notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logger.i("🔄 เปิดแอปจาก Notification: ${message.notification?.title}");
    });
  }

  /// 🔔 แสดงแจ้งเตือนภายในแอป
  static Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'channel_description',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }
}
