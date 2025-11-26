import 'package:botnoivoice/shared/style/style.dart';
import 'package:botnoivoice/shared/function/call_reload_data.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/dialog/payment/payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarSpeakerScreen extends ConsumerStatefulWidget
    implements PreferredSizeWidget {
  final Function()? onBackButtonPressed;

  const AppBarSpeakerScreen({super.key, this.onBackButtonPressed});

  @override
  ConsumerState<AppBarSpeakerScreen> createState() =>
      _AppBarSpeakerScreenState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarSpeakerScreenState extends ConsumerState<AppBarSpeakerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRemainingCredits();
    });
  }

  Future<void> _loadRemainingCredits() async {
    // await context.read<CallReloadData>().callLoadCreditsApi();
    await ref.read(callReloadDataProvider).callLoadCreditsApi();
  }

  @override
  Widget build(BuildContext context) {
    // var remainingCredits = context.watch<CallReloadData>().remainingCredits ?? 'N/A';
    var remainingCredits =
        ref.watch(callReloadDataProvider).remainingCredits ?? 'N/A';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          backgroundColor: kWhite, // ✅ เปลี่ยนพื้นหลังเป็นสีขาว
          elevation: 0, // ✅ เอาเงาออก
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF323130)),
            iconSize: ResponsiveDesignOrientation.isLandscape ? 10.sp : 16.sp,
            onPressed: () {
              // Redirect to HomeScreen
              context.go('/home');

              if (widget.onBackButtonPressed != null) {
                widget.onBackButtonPressed!();
              }
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
          leadingWidth: ResponsiveDesignOrientation.isLandscape ? 35.w : 60.w,
          title: SizedBox(
            height: 140.h,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/logo/appbar-icon.svg',
                width: ResponsiveDesignOrientation.isLandscape ? 53.w : 30.w,
                height: ResponsiveDesignOrientation.isLandscape ? 53.h : 30.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          actions: [
            Container(
              height: ResponsiveDesignOrientation.isLandscape ? 35.h : 30.h,
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 3.0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              margin: EdgeInsets.only(right: 10.w),
              child: InkWell(
                onTap: () {
                  showPaymentDialog(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: ResponsiveDesignOrientation.isLandscape
                            ? 3.w
                            : 5.w),
                    SvgPicture.asset(
                      'assets/images/logo/credit-icon.svg',
                      width:
                          ResponsiveDesignOrientation.isLandscape ? 30.w : 20.w,
                      height:
                          ResponsiveDesignOrientation.isLandscape ? 30.h : 20.h,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      remainingCredits,
                      style: GoogleFonts.prompt(
                        fontSize: ResponsiveDesignOrientation.isLandscape
                            ? 7.5.sp
                            : 12.sp,
                        fontWeight: FontWeight.bold,
                        color: kDark,
                      ),
                    ),
                    SizedBox(
                        width: ResponsiveDesignOrientation.isLandscape
                            ? 3.w
                            : 5.w),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
