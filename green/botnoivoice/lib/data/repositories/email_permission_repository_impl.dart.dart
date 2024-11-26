import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:botnoivoice/presentation/providers/user/user_info_provider.dart';

class EmailPermissionRepositoryImpl with ChangeNotifier {
  final Logger _logger = Logger();
  final UserInfoProvider _userInfoProvider;

  EmailPermissionRepositoryImpl(this._userInfoProvider);

  bool get isEmailAccessEnabled => _userInfoProvider.isShowEmail ?? false;

  Future<void> loadEmailAccessState(BuildContext context) async {
    try {
      await _userInfoProvider.getUserInfoShowMail(context);
      notifyListeners();
    } catch (error) {
      _logger.e("Failed to load email access state: $error");
    }
  }

  Future<void> updateEmailAccessState(BuildContext context, bool value) async {
    try {
      await _userInfoProvider.updateUserInfoShowMail(context, value);
      notifyListeners();
    } catch (error) {
      _logger.e("Failed to update email access state: $error");
    }
  }
}


