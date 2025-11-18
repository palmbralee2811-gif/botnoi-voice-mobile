import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:botnoivoice/shared/style/style.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/mar_ads_free_badge.dart';


class AdditionalInfoScreen extends StatefulWidget {
  const AdditionalInfoScreen({super.key});

  @override
  State<AdditionalInfoScreen> createState() => _AdditionalInfoScreenState();
}

class _AdditionalInfoScreenState extends State<AdditionalInfoScreen> {
  final TextEditingController _infoController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // เปิดคีย์บอร์ดอัตโนมัติหลังหน้าสร้างเสร็จ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _infoController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      resizeToAvoidBottomInset: true, // ⭐ เปิดให้เลื่อนเมื่อคีย์บอร์ดขึ้น
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        toolbarHeight: ResponsiveDesignOrientation.isLandscape ? 150.h : 58.h,
        title: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new,
                  size: ResponsiveDesignOrientation.isLandscape ? 12.sp : 25.sp,
                  color: kDark,
                ),
                onPressed: () => context.pop(),
              ),
            ),
            Center(
              child: SvgPicture.asset(
                'assets/images/logo/appbar-icon.svg',
                width: ResponsiveDesignOrientation.isLandscape ? 30.w : 28.w,
                height: ResponsiveDesignOrientation.isLandscape ? 30.h : 28.h,
                fit: BoxFit.contain,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: const MarAdsFreeBadge(remainingCount: '10/10'),
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          SizedBox(height: 16.h),

          /// Gradient Border TextBox
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w),
            padding: EdgeInsets.all(2.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFC9B8FF),
                  Color(0xFFE8C4FF),
                  Color(0xFFFFCEE3),
                ],
              ),
            ),
            child: Container(
              height: 470.h,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Stack(
                children: [
                  /// TextField
                  TextField(
                    controller: _infoController,
                    focusNode: _focusNode, // ⭐ เชื่อม FocusNode
                    maxLines: null,
                    maxLength: 250,
                    onChanged: (_) => setState(() {}), // update counter
                    decoration: InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      hintText: "พลาดไม่ได้, หมดเขตในอีก 3 วัน",
                      hintStyle: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF9E9E9E),
                      ),
                    ),
                    style: GoogleFonts.inter(
                      fontSize: 15.sp,
                      color: _infoController.text.isNotEmpty
                          ? Colors.black
                          : Colors.grey, // สีดำเมื่อมีข้อความ
                    ),
                  ),

                  /// Close Button
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: GestureDetector(
                      onTap: () => context.pop(),
                      child:
                          Icon(Icons.close, size: 20.sp, color: Colors.black),
                    ),
                  ),

                  /// Counter bottom-right
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Text(
                      "${_infoController.text.length}/250",
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const Spacer(),

          /// Confirm button
          Container(
            width: double.infinity,
            margin: EdgeInsets.all(16.w),
            child: ElevatedButton(
              onPressed: () => context.pop(_infoController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF262626),
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              child: Text(
                "ตกลง",
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}