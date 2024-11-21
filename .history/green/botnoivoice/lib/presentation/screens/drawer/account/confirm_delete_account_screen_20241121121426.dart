import 'package:botnoivoice/domain/repositories/auth_checker.dart';
import 'package:botnoivoice/presentation/constants/color.dart';
import 'package:botnoivoice/presentation/providers/email/email_delete_account_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/widgets/popup/notification_popup.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_align.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:botnoivoice/presentation/widgets/dialog/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ConfirmDeleteAccountScreen extends StatefulWidget {
  const ConfirmDeleteAccountScreen({super.key});

  @override
  State<ConfirmDeleteAccountScreen> createState() =>
      _ConfirmDeleteAccountScreenState();
}

class _ConfirmDeleteAccountScreenState
    extends State<ConfirmDeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  bool isDeleting = false;
  bool isPasswordVisible = false; // ใช้สำหรับควบคุมการแสดงรหัสผ่าน

  Future<void> _deleteAccount() async {
    setState(() {
      isDeleting = true;
    });

    final emailDeleteAccountProvider =
        Provider.of<EmailDeleteAccountProvider>(context, listen: false);
    final emailProvider =
        Provider.of<EmailLoginProvider>(context, listen: false);

    if (!emailProvider.isLoggedIn ||
        emailProvider.user == null ||
        emailProvider.user?.providerData[0].providerId != 'password') {
      NotificationDialog(
        context: context,
        text: 'ไม่สามารถลบบัญชีได้. คุณไม่ได้เข้าสู่ระบบด้วยอีเมล',
      ).showErrorModal(context);
      setState(() {
        isDeleting = false;
      });
      return;
    }

    String password = _passwordController.text;
    bool isPasswordValid =
        await emailDeleteAccountProvider.verifyPassword(password);

    if (!isPasswordValid) {
      NotificationDialog(
        context: context,
        text: emailDeleteAccountProvider.errorMessage ?? 'รหัสผ่านไม่ถูกต้อง',
      ).showErrorModal(context);
      setState(() {
        isDeleting = false;
      });
      return;
    }

    try {
      await emailDeleteAccountProvider.deleteUserAccountWithDatabase();
      final errorMessage = emailDeleteAccountProvider.errorMessage;

      if (errorMessage != null && errorMessage.isNotEmpty) {
        NotificationDialog(
          context: context,
          text: errorMessage,
        ).showErrorModal(context);
        setState(() {
          isDeleting = false;
        });
        return;
      }

      await emailDeleteAccountProvider.deleteUserAccountWithFirebase(context);
      await Provider.of<EmailLoginProvider>(context, listen: false)
          .signOutWithEmail(context);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => AuthChecker(),
        ),
        (Route<dynamic> route) => false,
      );
    } catch (error) {
      NotificationPopup(
        context: context,
        text: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง. $error',
      ).showAsError();
      setState(() {
        isDeleting = false;
      });
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
          icon: Icon(Icons.arrow_back_ios_new, color: kDark),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
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
                      'ยืนยันรหัสผ่าน', /
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
                      'ยืนยันรหัสผ่านของคุณเพื่อดำเนินการลบบัญชี', //ยืนยันรหัสผ่านของคุณเพื่อดำเนินการลบบัญชี
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
                      controller: _passwordController,
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w400),
                      decoration: InputDecoration(
                        labelText: 'ยืนยันรหัสผ่าน', //ยืนยันรหัสผ่าน
                        labelStyle: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w400),
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                        errorStyle: TextStyle(fontSize: 14.sp),
                        errorMaxLines: 5,
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 24.w,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordVisible = !isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'โปรดใส่รหัสผ่านของคุณ'; //โปรดใส่รหัสผ่านของคุณ
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16.h),
                    GradientTextButton(
                      text: 'ยืนยัน', //ยืนยัน
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _deleteAccount();
                        }
                      },
                    ),
                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ),
          if (isDeleting)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
