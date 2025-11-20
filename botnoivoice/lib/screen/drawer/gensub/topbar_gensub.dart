import 'package:botnoivoice/shared/style/style.dart';
import 'package:botnoivoice/shared/function/call_reload_data.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/dialog/payment/payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart'; // สำหรับใช้ context.go()

class TopbarGensub extends StatefulWidget implements PreferredSizeWidget {
  const TopbarGensub({super.key});

  @override
  State<TopbarGensub> createState() => _TopbarGensubState();

  @override
  Size get preferredSize =>
      Size.fromHeight(ResponsiveDesignOrientation.isLandscape ? 80.h : 60.h);
}

class _TopbarGensubState extends State<TopbarGensub> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRemainingCredits();
    });
  }

  Future<void> _loadRemainingCredits() async {
    await context.read<CallReloadData>().callLoadCreditsApi(context);
  }

  @override
  Widget build(BuildContext context) {
    var remainingCredits =
        context.watch<CallReloadData>().remainingCredits ?? 'N/A';

    return AppBar(
      backgroundColor: kWhite,
      elevation: 4.0,

      // 🔹 เปลี่ยนจากปุ่มเมนู → ปุ่มย้อนกลับ
      leading: Builder(
        builder: (context) => SizedBox(
          width: double.infinity,
          height:
              ResponsiveDesignOrientation.isLandscape ? 150.h : 58.h,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new,
              size: ResponsiveDesignOrientation.isLandscape ? 12.sp : 25.sp,
              color: kDark,
            ),
            onPressed: () {
              context.go('/home'); // 🔙 ไปหน้าโฮม
            },
            tooltip: 'กลับไปหน้าแรก',
          ),
        ),
      ),
      leadingWidth: ResponsiveDesignOrientation.isLandscape ? 35.w : 60.w,

      // 🔹 โลโก้ตรงกลาง (ไม่ต้องกด)
      title: SizedBox(
        height: 120.h,
        child: Center(
          child: SvgPicture.asset(
            'assets/images/logo/appbar-icon.svg',
            width: ResponsiveDesignOrientation.isLandscape ? 30.w : 28.w,
            height: ResponsiveDesignOrientation.isLandscape ? 30.h : 28.h,
            fit: BoxFit.contain,
          ),
        ),
      ),

      // 🔹 ด้านขวา (เครดิต)
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
            borderRadius: BorderRadius.circular(15.r),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 5.w),
                SvgPicture.asset(
                  'assets/images/logo/credit-icon.svg',
                  width:
                      ResponsiveDesignOrientation.isLandscape ? 20.w : 20.w,
                  height:
                      ResponsiveDesignOrientation.isLandscape ? 20.h : 20.h,
                ),
                SizedBox(width: 4.w),
                Text(
                  remainingCredits,
                  style: GoogleFonts.prompt(
                    fontSize: ResponsiveDesignOrientation.isLandscape
                        ? 8.sp
                        : 12.sp,
                    fontWeight: FontWeight.bold,
                    color: kDark,
                  ),
                ),
                SizedBox(width: 5.w),
              ],
            ),
          ),
        ),
        SizedBox(width: 5.w),
      ],
    );
  }
}
