import 'package:botnoivoice/domain/repositories/auth_checker.dart';
import 'package:botnoivoice/presentation/providers/email/email_change_username_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/widgets/dialog/alert_notification_dialog.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_align.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:botnoivoice/presentation/widgets/modal/alert_message_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ChangeEmailUsernameScreen extends StatefulWidget {
  const ChangeEmailUsernameScreen({super.key});

  @override
  State<ChangeEmailUsernameScreen> createState() =>
      _ChangeEmailUsernameScreenState();
}

class _ChangeEmailUsernameScreenState extends State<ChangeEmailUsernameScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmUsernameController =
      TextEditingController();

  bool isValidUsername(String username) {
    if (username.length < 3) return false;
    final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
    return usernameRegex.hasMatch(username);
  }

  void sendUsernameResetAPI() async {
    final changeUsername =
        Provider.of<EmailChangeUsernameProvider>(context, listen: false);

    // ตรวจสอบว่าชื่อผู้ใช้งานสองช่องตรงกันหรือไม่
    if (_usernameController.text != _confirmUsernameController.text) {
      AlertNotificationDialog(
        context: context,
        text: "ชื่อผู้ใช้งานทั้งสองช่องต้องตรงกัน",
      ).showAsError();
      return;
    }

    // ตรวจสอบความถูกต้องของชื่อผู้ใช้งาน
    if (!isValidUsername(_usernameController.text.trim())) {
      AlertNotificationDialog(
        context: context,
        text:
            "ชื่อผู้ใช้งานไม่ถูกต้อง กรุณาใช้ตัวอักษร a-z, A-Z, ตัวเลข และเครื่องหมาย _ หรือ -",
      ).showAsError();
      return;
    }

    // ถ้า validate ผ่านหมดแล้ว
    if (_formKey.currentState!.validate()) {
      await changeUsername.postChangeUsername(
          context, _usernameController.text);
      final errorMessage = changeUsername.errorMessage;

      if (errorMessage != null && errorMessage.isNotEmpty) {
        AlertMessageModal(
          context: context,
          text: errorMessage,
        ).showErrorModal(context);
      } else {
        AlertMessageModal(
          context: context,
          text: 'ตั้งชื่อผู้ใช้งานใหม่สำเร็จ',
          onPressed: () async {
            await Provider.of<EmailLoginProvider>(context, listen: false)
                .signOutWithEmail(context);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => AuthChecker(), // Go back to Login Screen
              ),
              (Route<dynamic> route) => false,
            );
          },
        ).showCheckmarkModalWithAction(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                GradientTextAlign(
                  'เปลี่ยนชื่อผู้ใช้',
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF9340FF),
                      Color(0xFF34BDFA),
                    ],
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 8.h),
                GradientTextAlign(
                  'ตั้งชื่อผู้ใช้งานใหม่สำหรับใช้ในการเข้าสู่ระบบ',
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF9340FF),
                      Color(0xFF34BDFA),
                    ],
                  ),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                    decoration: TextDecoration.none,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 32.h),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'ชื่อผู้ใช้งานใหม่',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) =>
                      value!.isEmpty ? 'โปรดใส่ชื่อผู้ใช้งานของคุณ' : null,
                ),
                SizedBox(height: 16.h),
                TextFormField(
                  controller: _confirmUsernameController,
                  decoration: InputDecoration(
                    labelText: 'ยืนยันชื่อผู้ใช้งานใหม่',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.text,
                  validator: (value) =>
                      value!.isEmpty ? 'โปรดยืนยันชื่อผู้ใช้งานของคุณ' : null,
                ),
                SizedBox(height: 16.h),
                GradientTextButton(
                  text: 'ยืนยัน',
                  onPressed: () {
                    sendUsernameResetAPI();
                  },
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
