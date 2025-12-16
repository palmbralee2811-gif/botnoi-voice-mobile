import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/dialog/payment/payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class TopbarGensub extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const TopbarGensub({super.key});

  @override
  ConsumerState<TopbarGensub> createState() => _TopbarGensubState();

  @override
  Size get preferredSize =>
      Size.fromHeight(ResponsiveDesignOrientation.isLandscape ? 70.h : 56.h);
}

class _TopbarGensubState extends ConsumerState<TopbarGensub> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRemainingCredits();
    });
  }

  Future<void> _loadRemainingCredits() async {
    await loadAllTokensIfLoggedIn(ref);
  }

  @override
  Widget build(BuildContext context) {
    final userTokenState = ref.watch(currentUserTokenStateProvider);
    final remainingCredits = userTokenState.remainingCredits ?? 'N/A';

    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white, // ป้องกันสีเพี้ยนเวลา Scroll
      elevation: 0, // ลบเงาหนักๆ ออกเพื่อให้ดู Clean
      
      // เพิ่มเส้นขอบบางๆ ด้านล่างให้ดูมีสัดส่วน (Optional)
      shape: Border(
        bottom: BorderSide(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),

      // 🔹 ปุ่มย้อนกลับ Minimal
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded, // ใช้ Rounded icon ให้ดูนุ่มนวล
          size: 20.sp,
          color: Colors.black87,
        ),
        onPressed: () => context.go('/home'),
        tooltip: 'Back',
        splashRadius: 24, // ลดขนาดวงคลื่นเวลากด
      ),
      leadingWidth: 50.w,

      // 🔹 โลโก้ตรงกลาง
      centerTitle: true,
      title: SvgPicture.asset(
        'assets/images/logo/appbar-icon.svg',
        height: 28.h,
        fit: BoxFit.contain,
      ),

      // 🔹 ส่วนแสดงเครดิต (Modern Pill Style)
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: InkWell(
            onTap: () => showPaymentDialog(context),
            borderRadius: BorderRadius.circular(30.r),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: Colors.grey.shade200), // ขอบบางๆ
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05), // เงาฟุ้งๆ นุ่มๆ
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    'assets/images/logo/credit-icon.svg',
                    width: 18.w,
                    height: 18.h,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    remainingCredits.toString(),
                    style: GoogleFonts.prompt(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87, // สีเข้มตัดกับพื้นขาว
                    ),
                  ),
                  // Optional: เพิ่มไอคอน + เล็กๆ เพื่อสื่อว่าเติมเงินได้
                  // SizedBox(width: 4.w),
                  // Icon(Icons.add_circle, size: 14.sp, color: Colors.blue),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}