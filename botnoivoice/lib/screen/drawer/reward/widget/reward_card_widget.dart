import 'package:botnoivoice/shared/style/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RewardCard extends StatelessWidget {
  // รับค่าจากภายนอกเพื่อกำหนดเนื้อหาในการ์ด
  final String iconUrl;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;

  // ตัวแปรเพื่อเช็คสภาพอุปกรณ์และสถานะการ Redeem
  final bool isTablet;
  final bool isLandscape;
  final bool isRedeemed;

  const RewardCard({
    super.key,
    required this.iconUrl,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
    required this.isTablet,
    required this.isLandscape,
    required this.isRedeemed,
  });

  @override
  Widget build(BuildContext context) {
    // กำหนดขนาดการ์ดตามอุปกรณ์ (มือถือ/แท็บเล็ต และแนวนอน/แนวตั้ง)
    double maxWidth = isTablet ? (isLandscape ? 440.w : 400.w) : double.infinity;
    double minHeight = isTablet ? 200.h : 180.h;

    // สีสำหรับ Gradient
    const Color startColor = Color(0xFF01BFFB);
    const Color endColor = Color(0xFFEB85FC);

    return Container(
      // จำกัดขนาดการ์ด
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minHeight: minHeight,
      ),
      width: double.infinity,

      // Container ชั้นนอกสุดที่มี border แบบไล่สี
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [startColor, endColor], // ไล่จากฟ้าไปม่วง
          begin: Alignment.topLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
      ),

      // ใช้ padding แทน border width เพื่อสร้างพื้นที่ให้ขอบสีไล่เฉด
      padding: const EdgeInsets.all(1.5),

      // Container ด้านใน ที่ใส่ภาพพื้นหลังและเนื้อหา
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.5.r), // ต้องเล็กกว่าชั้นนอกเพื่อให้เห็นขอบ
          image: const DecorationImage(
            image: AssetImage('assets/images/reward_screen/background_card_default.png'),
            fit: BoxFit.cover, // ให้ภาพพอดีกับการ์ด
          ),
          color: Colors.white, // สี fallback หากโหลดภาพไม่ทัน
        ),
        padding: EdgeInsets.all(16.w).copyWith(left: 16.w, right: 16.w), // ระยะห่างภายในการ์ด
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                // ส่วนแสดงไอคอนและหัวข้อ
                Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // แสดงไอคอนด้านซ้าย
                        Align(
                          alignment: Alignment.centerLeft,
                          child: (iconUrl.endsWith('.svg'))
                              ? SvgPicture.asset(
                                  iconUrl,
                                  width: 20.w,
                                  height: 20.h,
                                  fit: BoxFit.contain,
                                  placeholderBuilder: (context) =>
                                      const Icon(Icons.card_giftcard),
                                )
                              : Image.asset(
                                  iconUrl,
                                  width: 20.w,
                                  height: 20.h,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.card_giftcard),
                                ),
                        ),

                        // แสดงหัวข้อด้วย Gradient text
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 30.w),
                            child: ShaderMask(
                              shaderCallback: (bounds) {
                                return const LinearGradient(
                                  colors: [startColor, endColor],
                                  begin: Alignment.topLeft,
                                  end: Alignment.topRight,
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.srcIn, // ใช้ Gradient แทนสีของตัวอักษร
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: isTablet ? 18.sp : 16.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white, // สีพื้นฐานต้องเป็นขาว
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // แสดงคำอธิบาย
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 15.h),
                    child: Text(
                      description,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 20 / 14,
                        letterSpacing: 0.25,
                        color: kDarkGray,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),

                // ปุ่มแลกรางวัล
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    margin: EdgeInsets.only(top: 15.h),
                    constraints: BoxConstraints(
                      maxWidth: 350.w,
                      minHeight: 55.h,
                    ),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      // เปลี่ยนสีพื้นตามสถานะ redeemed
                      color: isRedeemed
                          ? kDark262626
                          : kDark262626.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 4,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),

                    // ข้อความบนปุ่ม
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(14.w),
                        child: Text(
                          buttonText,
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Colors.white,
                            height: 24 / 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
