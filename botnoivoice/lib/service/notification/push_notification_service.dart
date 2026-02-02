import 'dart:convert';
import 'package:botnoivoice/service/notification/fcm_token_service.dart';
import 'package:botnoivoice/shared/dialog/open_app_settings/open_app_settings_dialog.dart';
import 'package:botnoivoice/shared/function/get_user_id.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final Logger _logger = Logger();

  static String? _userId; // ⭐ เก็บ userId

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    _logger.i("🔔 Background Notification: ${message.notification?.title}");
    String payloadData = jsonEncode(message.data);
    showNotification(
      title: message.notification?.title ?? "No Title",
      body: message.notification?.body ?? "No Body",
      payload: payloadData,
    );
  }

  /// 🛠 Initialize Push Notification
  static Future<void> init(WidgetRef ref) async {
    _logger.i("🛠 Initializing Push Notification Service...");

    try {
      _userId = await getUserIdAll(ref);
      _logger.i('✅ Fetched User ID: $_userId');
    } catch (e) {
      _logger.e('❌ Failed to fetch User ID: $e');
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    const AndroidInitializationSettings androidInitSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosInitSettings = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(
        android: androidInitSettings, iOS: iosInitSettings);
    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    await _checkNotificationPermission(ref);

    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      _logger.i("🔄 FCM Token เปลี่ยนใหม่: $newToken");

      if (_userId != null) {
        final fcmService = FcmTokenService();
        bool success = await fcmService.updateFcmTokenByUserId(_userId!, newToken);
        if (success) {
          _logger.i("✅ อัปเดต FCM Token ใหม่ไปยัง Server สำเร็จ");
        } else {
          _logger.e("❌ อัปเดต FCM Token ใหม่ไม่สำเร็จ");
        }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _logger.i("🔔 Notification ขณะเปิดแอป: ${message.notification?.title}");
      String payloadData = jsonEncode(message.data);
      if (message.notification != null) {
        showNotification(
          title: message.notification?.title ?? "No Title",
          body: message.notification?.body ?? "No Body",
          payload: payloadData,
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _logger.i("🔄 เปิดแอปจาก Notification: ${message.notification?.title}");
    });
  }

  /// 🔄 ตรวจสอบสิทธิ์ Notification
  static Future<void> _checkNotificationPermission(WidgetRef ref) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission();

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      _logger.i("✅ ผู้ใช้ยอมรับ Notification แล้ว");

      String topicNameFCM = "default";
      await subscribeToTopic(topicNameFCM);

      String? token = await _firebaseMessaging.getToken();
      _logger.i("📲 FCM Token from Device: $token");

      if (token != null && _userId != null) {
        final fcmService = FcmTokenService();
        bool success = await fcmService.updateFcmTokenByUserId(_userId!, token);
        if (success) {
          _logger.i("✅ อัปเดต FCM Token ไปยัง Server สำเร็จ");
        } else {
          _logger.e("❌ อัปเดต FCM Token ไม่สำเร็จ");
        }
      }
    } else {
      _logger.w("🚫 ผู้ใช้ปฏิเสธ Notification");

      Future.delayed(Duration.zero, () {
        OpenAppSettingsDialog(
          context: ref.context,
          text: 'audio_player.permission_denied'.tr(),
        ).showPermissionDeniedDialog();
      });
    }
  }

  /// ✅ Subscribe to Topic
  static Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
    _logger.i("✅ Subscribed to Topic: $topic");
  }

  /// ❌ Unsubscribe from Topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
    _logger.i("❌ Unsubscribed from Topic: $topic");
  }

  /// 🛠 Delete FCM Token
  static Future<void> deleteFcmToken() async {
    _logger.i("🛠 Deleting FCM Token...");

    await _firebaseMessaging.deleteToken();

    if (_userId != null) {
      final fcmService = FcmTokenService();
      await fcmService.deleteFcmTokenByUserId(_userId!);
    }

    _logger.i("✅ FCM Token Deleted Successfully");
  }

  /// 🔔 Show Notification
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

    await _flutterLocalNotificationsPlugin.show(0, title, body, notificationDetails, payload: payload);
  }
}
