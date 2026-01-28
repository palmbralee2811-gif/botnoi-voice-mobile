import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsDropdown extends StatefulWidget {
  final String label;
  final String value;
  final bool showInfoIcon;
  final VoidCallback onTap;

  const MarAdsDropdown({
    super.key,
    required this.label,
    required this.value,
    this.showInfoIcon = false,
    required this.onTap,
  });

  @override
  State<MarAdsDropdown> createState() => _MarAdsDropdownState();
}

class _MarAdsDropdownState extends State<MarAdsDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: GoogleFonts.prompt(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF262626),
                    height: 1.43,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
              if (widget.showInfoIcon)
                // ใช้ Tooltip แบบ Tap เพื่อแสดงข้อมูลเมื่อกด
                Tooltip(
                  triggerMode: TooltipTriggerMode.tap,
                  preferBelow: false,
                  padding: EdgeInsets.all(12.w),
                  showDuration: const Duration(seconds: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF424242), // พื้นหลังสีเทาเข้มตามรูป
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  richMessage: TextSpan(
                    style: GoogleFonts.prompt(
                      fontSize: 12.sp,
                      color: Colors.white,
                      height: 1.5,
                    ),
                    children: [
                      const TextSpan(
                        text: 'การสร้างข้อความมีผลต่อพอยท์ที่ใช้ ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      // [เพิ่ม] ใช้ WidgetSpan เพื่อแทรกรูป SVG
                      WidgetSpan(
                        alignment: PlaceholderAlignment
                            .middle, // จัดให้อยู่กึ่งกลางบรรทัด
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 4.w, right: 2.w, bottom: 2.h),
                          child: SvgPicture.asset(
                            'assets/images/logo/credit-icon.svg',
                            height: 16.sp, // ปรับขนาดให้พอดีกับตัวหนังสือ
                          ),
                        ),
                      ),
                      const TextSpan(
                          text: '\n50 พอยท์/ครั้ง สำหรับ ~15 วินาที\n'),
                      const TextSpan(
                          text: '100 พอยท์/ครั้ง สำหรับ ~30 วินาที\n'),
                      const TextSpan(text: '150 พอยท์/ครั้ง สำหรับ ~60 วินาที')
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 6.w), // เพิ่มระยะห่างจาก Text นิดหน่อย
                    child: Icon(
                      Icons.info_outline,
                      size: 16.w, // ปรับขนาดไอคอนให้กดง่ายขึ้นเล็กน้อย
                      color: const Color(0xFF262626),
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 5.h),
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: const Color(0xFFDBDBDB), // สีขอบเทา
                  width: 1.0,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      widget.value,
                      style: GoogleFonts.prompt(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF262626),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.sp,
                    color: const Color(0xFF262626),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
