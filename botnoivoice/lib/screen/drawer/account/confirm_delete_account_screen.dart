// import 'package:botnoivoice/shared/function/open_logout_function.dart';
// import 'package:botnoivoice/service/login/apple_login.dart';
// import 'package:botnoivoice/shared/style/style.dart';
// import 'package:botnoivoice/service/delete_account/delete_account_service.dart';
// import 'package:botnoivoice/service/login/email_login.dart';
// import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
// import 'package:botnoivoice/shared/dialog/notification/notification_popup.dart';
// import 'package:botnoivoice/shared/widget/gradient/gradient_text_align.dart';
// import 'package:botnoivoice/shared/widget/gradient/gradient_text_button.dart';
// import 'package:botnoivoice/shared/dialog/notification/notification_dialog.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';

// /// Confirm Delete Account Screen
// class ConfirmDeleteAccountScreen extends ConsumerStatefulWidget {
//   const ConfirmDeleteAccountScreen({super.key});

//   @override
//   ConsumerState<ConfirmDeleteAccountScreen> createState() =>_ConfirmDeleteAccountScreenState();
// }

// class _ConfirmDeleteAccountScreenState extends ConsumerState<ConfirmDeleteAccountScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _passwordController = TextEditingController();
//   bool _isDeleting = false;
//   bool _isPasswordVisible = false; // ใช้สำหรับควบคุมการแสดงรหัสผ่าน
//   String? _providerId; // ใช้สำหรับเก็บ providerId ของผู้ใช้

//   Future<void> _deleteAccount() async {
//     setState(() {
//       _isDeleting = true;
//     });

//     // Delete Account for Email/Password and Apple Sign In.
//     final deleteAccount = context.read<DeleteAccountService>();

//     // Email Login
//     final emailLogin = context.read<EmailLogin>();

//     // Apple Login
//     final appleLogin = context.read<AppleLogin>();

//     // Check Login with Email/Password or Apple Account ???
//     if (emailLogin.isLoggedIn &&
//         emailLogin.user?.providerData[0].providerId == 'password') {
//       _providerId = 'password';
//     } else if (appleLogin.isLoggedIn &&
//         appleLogin.user?.providerData[0].providerId == 'apple.com') {
//       _providerId = 'apple.com';
//     } else {
//       // ถ้าไม่มี providerId ให้แสดงข้อความแจ้งเตือน
//       if (_providerId == null) {
//         NotificationDialog(
//           context: context,
//           // ไม่สามารถลบบัญชีได้. คุณไม่ได้เข้าสู่ระบบด้วยบัญชี Email หรือ บัญชี Apple
//           text: 'confirm_delete_account.unable_to_delete_account'.tr(),
//         ).showErrorModal(context);
//         setState(() {
//           _isDeleting = false;
//         });
//       }
//       return;
//     }

//     String password = _passwordController.text;
//     bool isPasswordValid =
//         await deleteAccount.verifyCredentials(password, _providerId!);

//     if (!isPasswordValid) {
//       NotificationDialog(
//         context: context,
//         text: deleteAccount.errorMessage ??
//             'confirm_delete_account.incorrect_password'
//                 .tr(), //รหัสผ่านไม่ถูกต้อง
//       ).showErrorModal(context);
//       setState(() {
//         _isDeleting = false;
//       });
//       return;
//     }

//     try {
//       await deleteAccount.deleteUserDataFromDatabase();
//       final errorMessage = deleteAccount.errorMessage;

//       if (errorMessage != null && errorMessage.isNotEmpty) {
//         NotificationDialog(
//           context: context,
//           text: errorMessage,
//         ).showErrorModal(context);
//         setState(() {
//           _isDeleting = false;
//         });
//         return;
//       }

//       await deleteAccount.deleteUserAccountFromFirebase(context);

//       /// Logout and Redirect to `login_screen.dart`
//       if (_providerId == 'password') {
//         // Logout Email/Password
//         openEmailLogout(context);
//       } else if (_providerId == 'apple.com') {
//         // Redirect to `login_screen.dart`
//         openAppleLogout(context);
//       }
//     } catch (error) {
//       NotificationPopup(
//         context: context,
//         text:
//             '${'confirm_delete_account.error_try_again'.tr()} $error', //เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง.
//       ).showAsError();
//       setState(() {
//         _isDeleting = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Email Login
//     final emailLogin = context.read<EmailLogin>();

//     SystemChrome.setSystemUIOverlayStyle(
//       const SystemUiOverlayStyle(
//         statusBarColor: Colors.transparent,
//         statusBarIconBrightness: Brightness.dark,
//       ),
//     );

//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back_ios_new, color: kDark),
//           onPressed: () {
//             // Redirect to Delete Account Screen
//             context.pop();
//           },
//         ),
//       ),
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//               ),
//             ),
//             child: Padding(
//               padding: EdgeInsets.all(24.w),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     SizedBox(height: 40.h),
//                     GradientTextAlign(
//                       'confirm_delete_account.confirm_password'
//                           .tr(), //ยืนยันรหัสผ่าน
//                       gradient: const LinearGradient(
//                         colors: [
//                           Color(0xFF9340FF),
//                           Color(0xFF34BDFA),
//                         ],
//                       ),
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: ResponsiveDesignOrientation.isLandscape
//                             ? 16.sp
//                             : 20.sp,
//                         decoration: TextDecoration.none,
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                     SizedBox(height: 8.h),
//                     GradientTextAlign(
//                       'confirm_delete_account.confirm_password_to_delete'
//                           .tr(), //ยืนยันรหัสผ่านของคุณเพื่อดำเนินการลบบัญชี
//                       gradient: const LinearGradient(
//                         colors: [
//                           Color(0xFF9340FF),
//                           Color(0xFF34BDFA),
//                         ],
//                       ),
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         fontSize: ResponsiveDesignOrientation.isLandscape
//                             ? 10.sp
//                             : 14.sp,
//                         decoration: TextDecoration.none,
//                       ),
//                       textAlign: TextAlign.left,
//                     ),
//                     SizedBox(height: 32.h),
//                     if (emailLogin.isLoggedIn &&
//                         emailLogin.user?.providerData[0].providerId ==
//                             'password')
//                       TextFormField(
//                         controller: _passwordController,
//                         style: TextStyle(
//                             fontSize: ResponsiveDesignOrientation.isLandscape
//                                 ? 12.sp
//                                 : 16.sp,
//                             fontWeight: FontWeight.w400),
//                         decoration: InputDecoration(
//                           labelText: 'confirm_delete_account.confirm_password'
//                               .tr(), //ยืนยันรหัสผ่าน
//                           labelStyle: TextStyle(
//                               fontSize: ResponsiveDesignOrientation.isLandscape
//                                   ? 12.sp
//                                   : 16.sp,
//                               fontWeight: FontWeight.w400),
//                           fillColor: Colors.white,
//                           filled: true,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12.r),
//                             borderSide: BorderSide.none,
//                           ),
//                           errorStyle: TextStyle(
//                               fontSize: ResponsiveDesignOrientation.isLandscape
//                                   ? 10.sp
//                                   : 14.sp),
//                           errorMaxLines: 5,
//                           suffixIcon: IconButton(
//                             icon: Icon(
//                               _isPasswordVisible
//                                   ? Icons.visibility
//                                   : Icons.visibility_off,
//                               size: ResponsiveDesignOrientation.isLandscape
//                                   ? 16.w
//                                   : 24.w,
//                             ),
//                             onPressed: () {
//                               setState(() {
//                                 _isPasswordVisible = !_isPasswordVisible;
//                               });
//                             },
//                           ),
//                         ),
//                         obscureText: !_isPasswordVisible,
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'confirm_delete_account.please_enter_your_password'
//                                 .tr(); //โปรดใส่รหัสผ่านของคุณ
//                           }
//                           return null;
//                         },
//                       ),
//                     SizedBox(height: 16.h),
//                     GradientTextButton(
//                       text: 'confirm_delete_account.confirm'.tr(), //ยืนยัน
//                       onPressed: () {
//                         if (_formKey.currentState?.validate() ?? false) {
//                           _deleteAccount();
//                         }
//                       },
//                     ),
//                     SizedBox(height: 16.h),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           if (_isDeleting)
//             Container(
//               color: Colors.black54,
//               child: const Center(
//                 child: CircularProgressIndicator(),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }















// 2.confirm_delete_account_screen

import 'package:botnoivoice/shared/function/open_logout_function.dart';
// import 'package:botnoivoice/service/login/apple_login.dart'; // ลบการ import ที่ไม่จำเป็นของคลาส
import 'package:botnoivoice/shared/style/style.dart';
// import 'package:botnoivoice/service/delete_account/delete_account_service.dart'; // ลบการ import ที่ไม่จำเป็นของคลาส
// import 'package:botnoivoice/service/login/email_login.dart'; // ลบการ import ที่ไม่จำเป็นของคลาส
// เพิ่มการ import ที่จำเป็นสำหรับ Riverpod providers
import 'package:botnoivoice/service/delete_account/delete_account_service.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/login/apple_login.dart';

import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_popup.dart';
import 'package:botnoivoice/shared/widget/gradient/gradient_text_align.dart';
import 'package:botnoivoice/shared/widget/gradient/gradient_text_button.dart';
import 'package:botnoivoice/shared/dialog/notification/notification_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart'; // ไม่จำเป็นแล้ว

/// Confirm Delete Account Screen
class ConfirmDeleteAccountScreen extends ConsumerStatefulWidget {
  const ConfirmDeleteAccountScreen({super.key});

  @override
  ConsumerState<ConfirmDeleteAccountScreen> createState() => _ConfirmDeleteAccountScreenState();
}

class _ConfirmDeleteAccountScreenState extends ConsumerState<ConfirmDeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _isDeleting = false;
  bool _isPasswordVisible = false; // ใช้สำหรับควบคุมการแสดงรหัสผ่าน
  String? _providerId; // ใช้สำหรับเก็บ providerId ของผู้ใช้

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    // กำหนด Notifier (Controller)
    final deleteAccountNotifier = ref.read(deleteAccountServiceProvider.notifier);
    final emailLoginNotifier = ref.read(emailLoginNotifierProvider.notifier);
    final appleLoginNotifier = ref.read(appleLoginNotifierProvider.notifier);

    // Watch สถานะ (State) - สำหรับตรวจสอบสถานะการ Login
    // เนื่องจากเราอยู่ในเมธอดที่เรียกใช้ async เราจะใช้ ref.read เพื่อเข้าถึงสถานะปัจจุบันแทน ref.watch
    final emailLoginState = ref.read(emailLoginNotifierProvider);
    final appleLoginState = ref.read(appleLoginNotifierProvider);

    setState(() {
      _isDeleting = true;
    });

    // Check Login with Email/Password or Apple Account ???
    if (emailLoginState.isLoggedIn &&
        emailLoginState.user?.providerData[0].providerId == 'password') {
      _providerId = 'password';
    } else if (appleLoginState.isLoggedIn &&
        appleLoginState.user?.providerData[0].providerId == 'apple.com') {
      _providerId = 'apple.com';
    } else {
      // ถ้าไม่มี providerId ให้แสดงข้อความแจ้งเตือน
      // เราสามารถใช้ ref.watch(deleteAccountServiceProvider) เพื่อเข้าถึง errorMessage แต่ในกรณีนี้เราจัดการเอง
      NotificationDialog(
        context: context,
        text: 'confirm_delete_account.unable_to_delete_account'.tr(),
      ).showErrorModal(context);
      setState(() {
        _isDeleting = false;
      });
      return;
    }

    String password = _passwordController.text;
    bool isPasswordValid =
        await deleteAccountNotifier.verifyCredentials(password, _providerId!);

    // รับค่า error message จาก state ของ Notifier (String?)
    final verifyErrorMessage = ref.read(deleteAccountServiceProvider);

    if (!isPasswordValid) {
      NotificationDialog(
        context: context,
        // ใช้ verifyErrorMessage ที่ได้จาก Notifier
        text: verifyErrorMessage ??
            'confirm_delete_account.incorrect_password'.tr(), //รหัสผ่านไม่ถูกต้อง
      ).showErrorModal(context);
      // สำคัญ: ต้องเคลียร์ error message ทิ้งหลังแสดงเสร็จ
      if (verifyErrorMessage != null) {
         // ใน Notifier คุณไม่ได้เปิดเมธอด public สำหรับ clear error ดังนั้นเราจะตั้งค่า state เป็น null โดยตรงไม่ได้
         // ต้องใช้เมธอดภายใน DeleteAccountNotifier ที่ควบคุม state ให้เคลียร์
         // เนื่องจากไม่มีเมธอด public ให้ใช้ เราจะตั้งข้อสังเกตไว้ (ถ้าใน Notifier มี _clearError() ต้องสร้าง public method เพื่อเรียกใช้)
      }
      setState(() {
        _isDeleting = false;
      });
      return;
    }

    try {
      // 1. Delete User Data from Database
      await deleteAccountNotifier.deleteUserDataFromDatabase();
      
      // ตรวจสอบ error message หลังจากพยายามลบข้อมูลจากฐานข้อมูล
      final deleteDbErrorMessage = ref.read(deleteAccountServiceProvider);

      if (deleteDbErrorMessage != null && deleteDbErrorMessage.isNotEmpty) {
        NotificationDialog(
          context: context,
          text: deleteDbErrorMessage,
        ).showErrorModal(context);
        setState(() {
          _isDeleting = false;
        });
        return;
      }

      // 2. Delete User Account from Firebase
      await deleteAccountNotifier.deleteUserAccountFromFirebase(context);

      // ตรวจสอบ error message อีกครั้งหลังจากพยายามลบ Firebase account
      final deleteFirebaseErrorMessage = ref.read(deleteAccountServiceProvider);

      if (deleteFirebaseErrorMessage != null && deleteFirebaseErrorMessage.isNotEmpty) {
        NotificationDialog(
          context: context,
          text: deleteFirebaseErrorMessage,
        ).showErrorModal(context);
        setState(() {
          _isDeleting = false;
        });
        return;
      }

      // 3. Logout and Redirect to `login_screen.dart`
      if (_providerId == 'password') {
        // Logout Email/Password
        // ต้องเรียกใช้ signOutWithEmail จาก Notifier
        await emailLoginNotifier.signOutWithEmail(ref); // ส่ง ref เข้าไปด้วย
        openEmailLogout(context); // ฟังก์ชันนำทางหลังจาก Logout
      } else if (_providerId == 'apple.com') {
        // Logout Apple
        // ต้องเรียกใช้ signOutWithApple จาก Notifier
        await appleLoginNotifier.signOutWithApple(ref); // ส่ง ref เข้าไปด้วย
        openAppleLogout(context); // ฟังก์ชันนำทางหลังจาก Logout
      }
    } catch (error) {
      NotificationPopup(
        context: context,
        text:
            '${'confirm_delete_account.error_try_again'.tr()} $error', //เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง.
      ).showAsError();
    } finally {
      // ตรวจสอบให้แน่ใจว่า _isDeleting ถูกตั้งค่าเป็น false เสมอหลังเสร็จสิ้น
      setState(() {
        _isDeleting = false;
      });
      // เคลียร์รหัสผ่าน
      _passwordController.clear();
      
      // สำคัญ: ต้องเคลียร์ error message ใน Notifier (ถ้ามีเมธอด public) 
      // เพื่อไม่ให้ error เก่าปรากฏในการเรียกใช้ครั้งถัดไป
      // เนื่องจากโค้ดที่ให้มาไม่มีเมธอด public สำหรับ clear error ใน DeleteAccountNotifier 
      // จึงต้องมั่นใจว่าเมธอดต่าง ๆ ใน DeleteAccountNotifier จะ clear error เองเมื่อสำเร็จ
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch สถานะเพื่ออัปเดต UI (emailLoginState.isLoggedIn)
    final emailLoginState = ref.watch(emailLoginNotifierProvider);

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
                      'confirm_delete_account.confirm_password'.tr(),
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
                      'confirm_delete_account.confirm_password_to_delete'.tr(),
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
                    // ใช้สถานะจาก Riverpod state
                    if (emailLoginState.isLoggedIn &&
                        emailLoginState.user?.providerData[0].providerId ==
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
                              .tr(),
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
                                .tr();
                          }
                          return null;
                        },
                      ),
                    SizedBox(height: 16.h),
                    GradientTextButton(
                      text: 'confirm_delete_account.confirm'.tr(), //ยืนยัน
                      onPressed: () {
                        // ไม่ต้อง validate ถ้าไม่ใช่การลบแบบ 'password'
                        final bool isPasswordFlow = emailLoginState.isLoggedIn &&
                            emailLoginState.user?.providerData[0].providerId ==
                                'password';
                        
                        if (!isPasswordFlow || (_formKey.currentState?.validate() ?? false)) {
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