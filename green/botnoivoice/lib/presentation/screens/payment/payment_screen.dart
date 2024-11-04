import 'package:botnoivoice/presentation/widgets/gradient/gradient_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('ราคาและโปรโมชั่น', style: TextStyle(fontSize: 20.sp)),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 24.sp),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Balance section
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2.sp,
                        blurRadius: 5.sp,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'พ้อยท์ของฉัน',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.monetization_on,
                              color: Colors.blue, size: 24.sp),
                          SizedBox(width: 8.w),
                          GradientText(
                            text: '100,000,000',
                            style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black,
                            ),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                // Promotions section
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    'ด่วน! โปรโมชั่นจำกัด 1/1',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      _buildPromotionItem('30,500 พ้อยท์', '750', '400'),
                      _buildPromotionItem('80,000 พ้อยท์', '2,000', '1,000'),
                      _buildPromotionItem('200,000 พ้อยท์', '5,000', '2,300'),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                GradientText(
                  text: 'แพ็คเกจผู้เริ่มต้น',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    children: [
                      _buildPromotionItem('4,100 พ้อยท์', '', '99'),
                      _buildPromotionItem('12,500 พ้อยท์', '299', '199'),
                      _buildPromotionItem('23,500 พ้อยท์', '499', '349'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionItem(
      String title, String originalPrice, String currentPrice) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo/credit-icon.svg',
                      width: 20.w,
                      height: 20.h,
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                GradientText(
                  text: '* แถมฟรี No Ads 1 เดือน',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  if (originalPrice.isNotEmpty)
                    Text(
                      originalPrice,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.red,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: Colors.red,
                      ),
                    ),
                  SizedBox(width: 5.w),
                  ElevatedButton(
                    onPressed: () {
                      //TODO: Call Payment API
                      print("Pay $currentPrice");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      '$currentPrice บาท',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    Icons.lock_clock,
                    color: Colors.grey,
                    size: 12.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'ภายใน 14:59',
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
