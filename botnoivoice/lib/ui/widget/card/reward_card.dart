import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class RewardCard extends StatelessWidget {
  final String iconUrl;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;

  final bool isTablet;
  final bool isLandscape;
  final bool isRedeemed;

  const RewardCard(
      {Key? key,
      required this.iconUrl,
      required this.title,
      required this.description,
      required this.buttonText,
      required this.onTap,
      required this.isTablet,
      required this.isLandscape,
      required this.isRedeemed})
      : super(key: key);

   @override
  Widget build(BuildContext context) {
    // Use ScreenUtil to adjust sizes based on screen size
    double maxWidth = isTablet ? (isLandscape ? 440.w : 400.w) : double.infinity;
    double minHeight = isTablet ? 200.h : 180.h;
    EdgeInsets padding = EdgeInsets.all(16.w).copyWith(left: 16.w, right: 16.w);

    const Color startColor = Color(0xFF01BFFB);
    const Color endColor = Color(0xFFEB85FC);
    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minHeight: minHeight,
      ),
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: startColor),
        borderRadius: BorderRadius.circular(24.r),
        //     gradient: LinearGradient(
        //   colors: [startColor, endColor], // กำหนดสีเริ่มต้นและสีปลาย
        //   begin: Alignment.topLeft,
        //   end: Alignment.bottomRight,
        // ),
        image: DecorationImage(
          image: AssetImage(
              'assets/images/reward/background_card_default.png'), // ระบุ path ของภาพ
          fit: BoxFit.cover, // ปรับให้ภาพพอดีกับขนาดของ Container
        ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
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
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only(left: 30.w),
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                colors: [startColor, endColor],
                                begin: Alignment.topLeft,
                                end: Alignment.topRight,
                              ).createShader(bounds);
                            },
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: isTablet ? 24.sp : 20.sp,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF01BFFB),
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
              // ใช้ Row เพื่อให้ description อยู่ตรงแนวเดียวกับไอคอน
              // ใช้ Align เพื่อจัดตำแหน่ง description ให้ตรงแนวเดียวกับไอคอน
              Align(
                alignment: Alignment
                    .centerLeft, // ให้ description อยู่ทางซ้ายตามแนวไอคอน
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 15.h), // เพิ่ม padding
                  child: Text(
                    description,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                      height: 20 / 14,
                      letterSpacing: 0.25,
                      color: Color(0xFF4F4F4F),
                    ),
                    textAlign: TextAlign.start, // ตั้งข้อความให้ชิดซ้าย
                  ),
                ),
              ),

              GestureDetector(
                onTap: onTap,
                child: Container(
                  margin: EdgeInsets.only(top: 15.h),
                  constraints: BoxConstraints(
                    maxWidth: 350.w,
                    minHeight: 60.h,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isRedeemed
                        ? Color(0xFF262626)
                        : Color(0xFF262626)
                            .withOpacity(0.2), // สีจางเมื่อไม่ได้ redeemed,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
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
    );
  }
}
