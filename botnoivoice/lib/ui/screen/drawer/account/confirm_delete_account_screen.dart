import 'package:botnoivoice/function/open_logout_function.dart';
import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/ui/style/style.dart';
import 'package:botnoivoice/service/delete_account/delete_account_service.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/ui/dialog/notification/notification_popup.dart';
import 'package:botnoivoice/ui/widget/gradient/gradient_text_align.dart';
import 'package:botnoivoice/ui/widget/gradient/gradient_text_button.dart';
import 'package:botnoivoice/ui/dialog/notification/notification_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

/// Confirm Delete Account Screen
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
  bool _isDeleting = false;
  bool _isPasswordVisible = false; // ใช้สำหรับควบคุมการแสดงรหัสผ่าน
  String? _providerId; // ใช้สำหรับเก็บ providerId ของผู้ใช้

  Future<void> _deleteAccount() async {
    setState(() {
      _isDeleting = true;
    });

    // Delete Account for Email/Password and Apple Sign In.
    final deleteAccount =
        Provider.of<DeleteAccountService>(context, listen: false);

    // Email Login
    final emailLogin = Provider.of<EmailLogin>(context, listen: false);

    // Apple Login
    final appleLogin = Provider.of<AppleLogin>(context, listen: false);

    // Check Login with Email/Password or Apple Account ???
    if (emailLogin.isLoggedIn &&
        emailLogin.user?.providerData[0].providerId == 'password') {
      _providerId = 'password';
    } else if (appleLogin.isLoggedIn &&
        appleLogin.user?.providerData[0].providerId == 'apple.com') {
      _providerId = 'apple.com';
    } else {
      // ถ้าไม่มี providerId ให้แสดงข้อความแจ้งเตือน
      if (_providerId == null) {
        NotificationDialog(
          context: context,
          // ไม่สามารถลบบัญชีได้. คุณไม่ได้เข้าสู่ระบบด้วยบัญชี Email หรือ บัญชี Apple
          text: 'confirm_delete_account.unable_to_delete_account'.tr(),
        ).showErrorModal(context);
        setState(() {
          _isDeleting = false;
        });
      }
      return;
    }

    String password = _passwordController.text;
    bool isPasswordValid =
        await deleteAccount.verifyCredentials(password, _providerId!);

    if (!isPasswordValid) {
      NotificationDialog(
        context: context,
        text: deleteAccount.errorMessage ??
            'confirm_delete_account.incorrect_password'
                .tr(), //รหัสผ่านไม่ถูกต้อง
      ).showErrorModal(context);
      setState(() {
        _isDeleting = false;
      });
      return;
    }

    try {
      await deleteAccount.deleteUserDataFromDatabase();
      final errorMessage = deleteAccount.errorMessage;

      if (errorMessage != null && errorMessage.isNotEmpty) {
        NotificationDialog(
          context: context,
          text: errorMessage,
        ).showErrorModal(context);
        setState(() {
          _isDeleting = false;
        });
        return;
      }

      await deleteAccount.deleteUserAccountFromFirebase(context);

      /// Logout and Redirect to `login_screen.dart`
      if (_providerId == 'password') {
        // Logout Email/Password
        openEmailLogout(context);
      } else if (_providerId == 'apple.com') {
        // Redirect to `login_screen.dart`
        openAppleLogout(context);
      }
    } catch (error) {
      NotificationPopup(
        context: context,
        text:
            '${'confirm_delete_account.error_try_again'.tr()} $error', //เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง.
      ).showAsError();
      setState(() {
        _isDeleting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Email Login
    final emailLogin = Provider.of<EmailLogin>(context, listen: false);

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
            // Redirect to Delete Account Screen
            context.pop();
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
                      'confirm_delete_account.confirm_password'
                          .tr(), //ยืนยันรหัสผ่าน
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9340FF),
                          Color(0xFF34BDFA),
                        ],
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveDesignOrientation.isLandscape
                            ? 16.sp
                            : 20.sp,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 8.h),
                    GradientTextAlign(
                      'confirm_delete_account.confirm_password_to_delete'
                          .tr(), //ยืนยันรหัสผ่านของคุณเพื่อดำเนินการลบบัญชี
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9340FF),
                          Color(0xFF34BDFA),
                        ],
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: ResponsiveDesignOrientation.isLandscape
                            ? 10.sp
                            : 14.sp,
                        decoration: TextDecoration.none,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 32.h),
                    if (emailLogin.isLoggedIn &&
                        emailLogin.user?.providerData[0].providerId ==
                            'password')
                      TextFormField(
                        controller: _passwordController,
                        style: TextStyle(
                            fontSize: ResponsiveDesignOrientation.isLandscape
                                ? 12.sp
                                : 16.sp,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          labelText: 'confirm_delete_account.confirm_password'
                              .tr(), //ยืนยันรหัสผ่าน
                          labelStyle: TextStyle(
                              fontSize: ResponsiveDesignOrientation.isLandscape
                                  ? 12.sp
                                  : 16.sp,
                              fontWeight: FontWeight.w400),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                          errorStyle: TextStyle(
                              fontSize: ResponsiveDesignOrientation.isLandscape
                                  ? 10.sp
                                  : 14.sp),
                          errorMaxLines: 5,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: ResponsiveDesignOrientation.isLandscape
                                  ? 16.w
                                  : 24.w,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'confirm_delete_account.please_enter_your_password'
                                .tr(); //โปรดใส่รหัสผ่านของคุณ
                          }
                          return null;
                        },
                      ),
                    SizedBox(height: 16.h),
                    GradientTextButton(
                      text: 'confirm_delete_account.confirm'.tr(), //ยืนยัน
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
          if (_isDeleting)
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
