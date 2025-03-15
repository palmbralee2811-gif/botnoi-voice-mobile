import 'package:flutter/material.dart';

/// SnackBar Notification Builder for Multi-Platform.
class NotificationSnackBar {
  NotificationSnackBar({
    required this.context,
    required this.text,
    this.label,
    this.onPressed, // กำหนด onPressed เป็น optional
  });

  final String text;
  final BuildContext context;
  final String? label;
  final VoidCallback? onPressed;

  /// Show Text Notification
  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(seconds: 10),
      ),
    );
  }

  /// Show Text Notification with Action
  void showSnackBarWithAction() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(
          label: label ?? 'OPEN',
          onPressed: onPressed ?? () {},
        ),
        duration: const Duration(seconds: 15),
      ),
    );
  }
}
