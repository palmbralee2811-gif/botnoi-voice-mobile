import 'package:botnoivoice/shared/dialog/redeem_coupon/redeem_coupon_dialog.dart';
import 'package:botnoivoice/shared/function/app_language_function.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/screen/drawer/drawer_appbar_logic.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/dialog/payment/payment_dialog.dart';
import 'package:botnoivoice/screen/drawer/app_language_selection/app_language_selection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerAppbar extends ConsumerStatefulWidget {
  const DrawerAppbar({super.key});

  @override
  ConsumerState<DrawerAppbar> createState() => _DrawerAppbarState();
}

class _DrawerAppbarState extends ConsumerState<DrawerAppbar> {
  final DrawerAppbarLogic _logic = DrawerAppbarLogic();
  String displayName = "Loading...";
  String uid = "Loading...";
  String profilePictureUrl = "";
  String selectedLanguage = 'th';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _logic.loadUserInfo(
        ref: ref,
        onUpdateState: (newDisplayName, newUid, newProfilePictureUrl) {
          if (mounted) {
            setState(() {
              displayName = newDisplayName;
              uid = newUid;
              profilePictureUrl = newProfilePictureUrl;
            });
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final emailProvider = ref.watch(emailLoginNotifierProvider);
    final isLandscape = ResponsiveDesignOrientation.isLandscape;

    return Drawer(
      width: isLandscape ? 200.w : 280.w,
      elevation: 0, // Minimal Style: No heavy shadow
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. Header Section ---
            _buildHeader(isLandscape),

            const Divider(height: 1, color: Color(0xFFF0F0F0)),

            // --- 2. Menu Items ---
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                children: [
                  _buildSectionLabel('app_drawer.services'.tr()),
                  _DrawerTile(
                    icon: Icons.subtitles_rounded,
                    title: 'app_drawer.gensub'.tr(),
                    onTap: () => context.push('/gensub'),
                  ),
                  _DrawerTile(
                    icon: Icons.school_rounded,
                    title: 'app_drawer.education'.tr(),
                    onTap: () => context.push('/education'),
                  ),
                  
                  SizedBox(height: 10.h),
                  _buildSectionLabel('app_drawer.account'.tr()),
                  
                  _DrawerTile(
                    icon: Icons.person_rounded,
                    title: 'app_drawer.profile'.tr(),
                    onTap: () => context.push('/account'),
                  ),
                  _DrawerTile(
                    icon: Icons.card_giftcard_rounded,
                    title: 'app_drawer.redeem'.tr(),
                    onTap: () {
                      context.pop();
                      RedeemCouponDialog(
                        context: context,
                        ref: ref,
                        text: 'app_drawer.redeem'.tr(),
                      ).showModal(context);
                    },
                  ),
                  _DrawerTile(
                    icon: Icons.account_balance_wallet_rounded,
                    title: 'app_drawer.buy_points'.tr(),
                    onTap: () => showPaymentDialog(context),
                  ),
                  _DrawerTile(
                    icon: Icons.stars_rounded,
                    title: 'app_drawer.reward'.tr(),
                    iconColor: Colors.amber,
                    onTap: () => context.push('/reward'),
                  ),

                  // Show Security only for password login
                  if (emailProvider.isLoggedIn &&
                      emailProvider.user?.providerData[0].providerId == 'password') ...[
                    SizedBox(height: 10.h),
                    _buildSectionLabel('app_drawer.system'.tr()),
                    _DrawerTile(
                      icon: Icons.security_rounded,
                      title: 'app_drawer.security'.tr(),
                      onTap: () => context.push('/email-permission'),
                    ),
                  ],
                ],
              ),
            ),

            const Divider(height: 1, color: Color(0xFFF0F0F0)),

            // --- 3. Footer (Language) ---
            Padding(
              padding: EdgeInsets.all(16.w),
              child: _DrawerTile(
                icon: Icons.language_rounded,
                title: 'language'.tr(),
                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 12.sp, color: Colors.grey),
                onTap: () {
                  showLanguageBottomSheet(
                    context: context,
                    onLanguageSelected: (language) {
                      setState(() => selectedLanguage = language);
                      saveSelectedLanguage(language);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isLandscape) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 10.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: isLandscape ? 40.w : 60.w,
                height: isLandscape ? 40.w : 60.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade200, width: 2),
                  image: DecorationImage(
                    image: profilePictureUrl.isNotEmpty
                        ? NetworkImage(profilePictureUrl)
                        : const AssetImage('assets/images/default-profile-picture.jpg')
                            as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => context.pop(),
                icon: Icon(Icons.close_rounded, color: Colors.grey[400], size: 24.sp),
                splashRadius: 20,
              )
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            displayName,
            style: GoogleFonts.prompt(
              fontSize: isLandscape ? 14.sp : 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            'UID: $uid',
            style: GoogleFonts.prompt(
              fontSize: isLandscape ? 10.sp : 12.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey[600],
            ),
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.prompt(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: Colors.grey[400],
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// --- Helper Widget for Uniform Tiles ---
class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Widget? trailing;

  const _DrawerTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.transparent, // หรือ Colors.grey[50] ถ้าต้องการพื้นหลังจางๆ
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 0.h),
        leading: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: (iconColor ?? Colors.black87).withOpacity(0.05),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            size: 20.sp,
            color: iconColor ?? Colors.black87,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.prompt(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}