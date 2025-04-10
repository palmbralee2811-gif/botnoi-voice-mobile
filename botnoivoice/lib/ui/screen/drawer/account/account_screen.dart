import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/ui/screen/drawer/account/row_login_icon_widget.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/ui/screen/appbar/appbar_template.dart';
import 'package:botnoivoice/ui/screen/drawer/account/account_screen_logic.dart';
import 'package:botnoivoice/ui/screen/drawer/account/row_user_info_widget.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/ui/widget/button/delete_account_button.dart';
import 'package:botnoivoice/ui/widget/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final AccountScreenLogic _logic = AccountScreenLogic();
  String displayName = "Loading...";
  String userId = "Loading...";
  String email = "Loading...";
  bool isEmailHidden = true;

  bool isEmailLoggedIn = false;
  bool isAppleLoggedIn = false;
  bool isGoogleLoggedIn = false;
  bool isLineLoggedIn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _logic.loadUserInfo(
        context: context,
        onUpdateState: (
          String newDisplayName,
          String newUserId,
          String newEmail,
          bool emailLoggedIn,
          bool appleLoggedIn,
          bool googleLoggedIn,
          bool lineLoggedIn,
        ) {
          setState(() {
            displayName = newDisplayName;
            userId = newUserId;
            email = newEmail;
            isEmailLoggedIn = emailLoggedIn;
            isAppleLoggedIn = appleLoggedIn;
            isGoogleLoggedIn = googleLoggedIn;
            isLineLoggedIn = lineLoggedIn;
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final emailProvider = Provider.of<EmailLogin>(context, listen: false);
    final appleProvider = Provider.of<AppleLogin>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBarTemplate(
        title: 'app_drawer.profile'.tr(),
        onPressed: () {
          // Redirect to HomeScreen
          context.pop();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                  height:
                      ResponsiveDesignOrientation.isLandscape ? 40.h : 20.h),
              RowLoginIconWidget(
                isEmailLoggedIn: isEmailLoggedIn,
                isLineLoggedIn: isLineLoggedIn,
                isGoogleLoggedIn: isGoogleLoggedIn,
                isAppleLoggedIn: isAppleLoggedIn,
              ),
              SizedBox(height: 24.h),
              RowUserInfoWidget(
                title: 'UID',
                value: _logic.getDisplayUID(userId),
                icon: Icons.copy,
                onIconPressed: () {
                  _logic.copyUID(context, userId);
                },
                isValueOverflow: true,
              ),
              SizedBox(height: 16.h),
              RowUserInfoWidget(
                title: 'account.email'.tr(),
                value: _logic.getMaskedEmail(isEmailHidden, email),
                icon: isEmailHidden ? Icons.visibility_off : Icons.visibility,
                onIconPressed: () {
                  setState(() {
                    isEmailHidden = !isEmailHidden;
                  });
                },
              ),
              SizedBox(height: 16.h),
              emailProvider.isLoggedIn &&
                      emailProvider.user?.providerData[0].providerId ==
                          'password'
                  ? RowUserInfoWidget(
                      // ชื่อผู้ใช้งาน
                      title: 'account.username'.tr(),
                      value: displayName,
                      icon: Icons.edit_rounded,
                      onIconPressed: () {
                        // Redirect to `change_email_username_screen.dart`
                        context.push('/change-email-username');
                      },
                    )
                  : RowUserInfoWidget(
                      // ชื่อผู้ใช้งาน
                      title: 'account.username'.tr(),
                      value: displayName,
                    ),
              SizedBox(
                  height:
                      ResponsiveDesignOrientation.isLandscape ? 24.h : 150.h),
              GradientTextButton(
                text: 'account.logout'.tr(),
                onPressed: () async {
                  await _logic.signOut(context);
                },
              ),
              SizedBox(
                  height: ResponsiveDesignOrientation.isLandscape ? 6.h : 16.h),
              if (emailProvider.isLoggedIn &&
                      emailProvider.user?.providerData[0].providerId ==
                          'password' ||
                  appleProvider.isLoggedIn &&
                      appleProvider.user?.providerData[0].providerId ==
                          'apple.com')
                const DeleteAccountButton(),
              SizedBox(
                  height: ResponsiveDesignOrientation.isLandscape ? 8.h : 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
