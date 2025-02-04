import 'package:botnoivoice/presentation/constants/styles.dart';
import 'package:botnoivoice/presentation/providers/credits/credits_provider.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/widgets/dialog/payment/payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AppBarSpeakerScreen extends StatefulWidget
    implements PreferredSizeWidget {
  const AppBarSpeakerScreen({super.key});

  @override
  State<AppBarSpeakerScreen> createState() => _AppBarSpeakerScreenState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _AppBarSpeakerScreenState extends State<AppBarSpeakerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRemainingCredits();
    });
  }

  Future<void> _loadRemainingCredits() async {
    await Provider.of<CreditsProvider>(context, listen: false)
        .callLoadCreditsApi(context);
  }

  @override
  Widget build(BuildContext context) {
    var remainingCredits =
        Provider.of<CreditsProvider>(context).remainingCredits ?? 'N/A';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          backgroundColor: kWhite, // ✅ เปลี่ยนพื้นหลังเป็นสีขาว
          elevation: 0, // ✅ เอาเงาออก
          shadowColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF323130)),
            iconSize: OrientationHelper.isLandscape ? 10.sp : 16.sp,
            onPressed: () => Navigator.pop(context),
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          ),
          leadingWidth: OrientationHelper.isLandscape ? 35.w : 60.w,
          title: SizedBox(
            height: 140.h,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/logo/appbar-icon.svg',
                width: OrientationHelper.isLandscape ? 53.w : 30.w,
                height: OrientationHelper.isLandscape ? 53.h : 30.h,
                fit: BoxFit.contain,
              ),
            ),
          ),
          actions: [
            Container(
              height: OrientationHelper.isLandscape ? 35.h : 30.h,
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
                    SizedBox(width: OrientationHelper.isLandscape ? 3.w : 5.w),
                    SvgPicture.asset(
                      'assets/images/logo/credit-icon.svg',
                      width: OrientationHelper.isLandscape ? 30.w : 20.w,
                      height: OrientationHelper.isLandscape ? 30.h : 20.h,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      remainingCredits,
                      style: GoogleFonts.prompt(
                        fontSize:
                            OrientationHelper.isLandscape ? 7.5.sp : 12.sp,
                        fontWeight: FontWeight.bold,
                        color: kDark,
                      ),
                    ),
                    SizedBox(width: OrientationHelper.isLandscape ? 3.w : 5.w),
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
