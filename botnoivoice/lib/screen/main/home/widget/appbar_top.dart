import 'package:botnoivoice/shared/style/style.dart';
import 'package:botnoivoice/shared/function/call_reload_data.dart';
import 'package:botnoivoice/screen/main/home/widget/appbar_bottom.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/dialog/payment/payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AppBarTop extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const AppBarTop({super.key});

  @override
  ConsumerState<AppBarTop> createState() => _AppBarTopState();

  @override
  Size get preferredSize =>
      Size.fromHeight(ResponsiveDesignOrientation.isLandscape ? 135.h : 100.h);
}

class _AppBarTopState extends ConsumerState<AppBarTop> {
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
    var remainingCredits = ref.read(callReloadDataProvider).remainingCredits ?? 'N/A';

    return AppBar(
      backgroundColor: kWhite,
      elevation: 4.0,
      leading: SizedBox(
        width: double.infinity,
        height: ResponsiveDesignOrientation.isLandscape ? 150.h : 58.h,
        child: IconButton(
          icon: Icon(
            Icons.menu_rounded,
            size: ResponsiveDesignOrientation.isLandscape ? 12.sp : 25.sp,
            color: kDark,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
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
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 224, 221, 221),
                blurRadius: 3.0,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
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
                    width: ResponsiveDesignOrientation.isLandscape ? 3.w : 5.w),
                SizedBox(
                  height: ResponsiveDesignOrientation.isLandscape ? 40.h : 20.h,
                  width: ResponsiveDesignOrientation.isLandscape ? 10.w : 20.w,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: SvgPicture.asset(
                      'assets/images/logo/credit-icon.svg',
                      width:
                          ResponsiveDesignOrientation.isLandscape ? 30.w : 20.w,
                      height:
                          ResponsiveDesignOrientation.isLandscape ? 30.h : 20.h,
                    ),
                  ),
                ),
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
                    width: ResponsiveDesignOrientation.isLandscape ? 3.w : 5.w),
              ],
            ),
          ),
        ),
        Container(
          height: ResponsiveDesignOrientation.isLandscape ? 35.h : 30.h,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 224, 221, 221),
                blurRadius: 3.0,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
          ),
          margin: EdgeInsets.only(right: 10.w),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(30.h),
        child: const AppBarBottom(),
      ),
    );
  }
}
