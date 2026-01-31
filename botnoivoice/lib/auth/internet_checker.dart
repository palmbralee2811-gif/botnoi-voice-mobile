import 'dart:async';
import 'package:botnoivoice/shared/dialog/notification/notification_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

/// Check if the internet connection is available on `login_screen.dart` and `home_screen.dart`
/// ตรวจสอบการเชื่อมต่ออินเทอร์เน็ตใน `login_screen.dart` และ `home_screen.dart`
class InternetChecker {
  late StreamSubscription<InternetStatus> _listener;
  bool _isInternetAvailable = true;

  bool get isInternetAvailable => _isInternetAvailable;

  void startListeningToInternetChanges(BuildContext context, Function(bool) onInternetChange) {
    _listener = InternetConnection().onStatusChange.listen((status) {
      final isAvailable = status == InternetStatus.connected;
      if (_isInternetAvailable != isAvailable) {
        _isInternetAvailable = isAvailable;
         onInternetChange(_isInternetAvailable);
        if (!_isInternetAvailable) {
          NotificationDialog(
            context: context,
            text: 'no_internet_connection'.tr(),
          ).showErrorModal(context);
        }
      }
    });
  }

  void cancelListener() {
    _listener.cancel();
  }
}
