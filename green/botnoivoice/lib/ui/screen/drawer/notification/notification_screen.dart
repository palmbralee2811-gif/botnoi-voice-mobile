// import 'package:botnoivoice/service/notification/push_notification_service.dart';
// import 'package:botnoivoice/ui/screen/appbar/appbar_template.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:logger/logger.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class NotificationScreen extends StatefulWidget {
//   const NotificationScreen({super.key});

//   @override
//   State<NotificationScreen> createState() => _NotificationScreenState();
// }

// class _NotificationScreenState extends State<NotificationScreen> {
//   final Logger _logger = Logger();
//   String _notificationTitle = "ยังไม่มีการแจ้งเตือน";
//   String _notificationBody = "";

//   @override
//   void initState() {
//     super.initState();

//     // ตั้งค่าการแจ้งเตือนขณะเปิดแอป
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       setState(() {
//         _notificationTitle = message.notification?.title ?? "No Title";
//         _notificationBody = message.notification?.body ?? "No Body";
//       });
//       _logger.i("🔔 แสดง Notification บน UI: $_notificationTitle");
//       PushNotificationService.showNotification(
//           _notificationTitle, _notificationBody);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBarTemplate(
//         title: 'แจ้งเตือน (ยังไม่ใส่ .tr())',
//         onPressed: () {
//           // Redirect to HomeScreen
//           context.go('/home');
//         },
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Text("🔔 การแจ้งเตือนล่าสุด",
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               Text(
//                 _notificationTitle,
//                 style:
//                     const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
//               ),
//               const SizedBox(height: 5),
//               Text(
//                 _notificationBody,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(fontSize: 16),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
