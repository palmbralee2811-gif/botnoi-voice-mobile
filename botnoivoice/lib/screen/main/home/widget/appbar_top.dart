import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:botnoivoice/shared/style/style.dart';
import 'package:botnoivoice/screen/main/home/widget/appbar_bottom.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/dialog/payment/payment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AppBarTop extends ConsumerStatefulWidget implements PreferredSizeWidget {
  const AppBarTop({super.key});

  @override
  ConsumerState<AppBarTop> createState() => _AppBarTopState();

  @override
  Size get preferredSize =>
      Size.fromHeight(ResponsiveDesignOrientation.isLandscape ? 130.h : 100.h);
}

class _AppBarTopState extends ConsumerState<AppBarTop> {
  // สร้าง Formatter ไว้เป็นตัวแปรเพื่อไม่ต้องสร้างใหม่ทุกรอบ
  final _numberFormat = NumberFormat('#,###');

  @override
  void initState() {
    super.initState();
    // ✅ Production: ควรโหลดข้อมูลเมื่อ Widget เริ่มทำงาน
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadRemainingCredits();
    });
  }

  Future<void> _loadRemainingCredits() async {
    await loadAllTokensIfLoggedIn(ref);
  }

  // ✅ Production: แยก Logic การจัดรูปแบบออกมาเป็นฟังก์ชัน
  String _formatCredits(dynamic rawCredits) {
    if (rawCredits == null) return 'N/A';

    num? creditValue;

    // 1. ตรวจสอบ Type และแปลงค่าอย่างปลอดภัย
    if (rawCredits is num) {
      creditValue = rawCredits;
    } else if (rawCredits is String) {
      creditValue = num.tryParse(rawCredits);
    } else {
      // กรณีเป็น Type อื่นๆ เช่น Object ให้ลองแปลงเป็น String ก่อน
      creditValue = num.tryParse(rawCredits.toString());
    }

    // 2. คืนค่าที่จัดรูปแบบแล้ว
    if (creditValue != null) {
      return _numberFormat.format(creditValue);
    } else {
      return rawCredits.toString(); // คืนค่าเดิมถ้าแปลงไม่ได้
    }
  }

  @override
  Widget build(BuildContext context) {
    final userTokenState = ref.watch(currentUserTokenStateProvider);
    final isLandscape = ResponsiveDesignOrientation.isLandscape;

    // เรียกใช้ฟังก์ชันที่แยกไว้ โค้ดใน build จะสะอาดขึ้นมาก
    final displayCredits = _formatCredits(userTokenState.remainingCredits);

    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      centerTitle: true,

      // 🔹 Menu Button
      leading: IconButton(
        icon: Icon(
          Icons.menu_rounded,
          size: isLandscape ? 20.sp : 28.sp,
          color: kDark,
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
        tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        splashRadius: 24,
      ),
      leadingWidth: isLandscape ? 50.w : 60.w,

      // 🔹 Logo
      title: SvgPicture.asset(
        'assets/images/logo/appbar-icon.svg',
        width: isLandscape ? 40.w : 100.w,
        height: isLandscape ? 40.h : 32.h,
        fit: BoxFit.contain,
      ),

      // 🔹 Credits Action (Pill Style)
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16.w),
          child: InkWell(
            onTap: () => showPaymentDialog(context),
            borderRadius: BorderRadius.circular(30.r),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: isLandscape ? 8.w : 12.w,
                vertical: isLandscape ? 4.h : 6.h,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.r),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
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
                    width: isLandscape ? 16.w : 20.w,
                    height: isLandscape ? 16.h : 20.h,
                  ),
                  SizedBox(width: 6.w),
                  
                  // แสดงผลตัวเลข
                  Text(
                    displayCredits,
                    style: GoogleFonts.prompt(
                      fontSize: isLandscape ? 10.sp : 14.sp,
                      fontWeight: FontWeight.w600,
                      color: kDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],

      // 🔹 Bottom Section
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(40.h),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade100, width: 1),
            ),
          ),
          child: const AppBarBottom(),
        ),
      ),
    );
  }
}