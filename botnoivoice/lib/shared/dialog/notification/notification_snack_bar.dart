import 'package:botnoivoice/shared/style/style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// SnackBar Notification Builder for Multi-Platform.
class NotificationSnackBar {
  NotificationSnackBar({
    required this.context,
    required this.text,
    this.label,
    this.onPressed, // กำหนด onPressed เป็น optional
    this.color,
  });

  final String text;
  final BuildContext context;
  final String? label;
  final VoidCallback? onPressed;
  final Color? color;

  /// Show Text Notification
  /// Display Notification with Snackbar
  void showSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text.tr()),
        backgroundColor: color ?? kDarkGray,
        duration: const Duration(seconds: 5),
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
