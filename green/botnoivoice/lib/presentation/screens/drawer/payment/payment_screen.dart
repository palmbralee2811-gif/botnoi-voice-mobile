import 'package:botnoivoice/presentation/constants/color.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/providers/google/google_token_provider.dart';
import 'package:botnoivoice/presentation/providers/line/line_token_provider.dart';
import 'package:botnoivoice/presentation/providers/payment/mock_payment_provider.dart';
import 'package:botnoivoice/presentation/widgets/dialog/notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    final mockProvider = Provider.of<MockPaymentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('ราคาและโปรโมชั่น', style: TextStyle(fontSize: 20.sp)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 24.sp),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section: My Points
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                  decoration: BoxDecoration(
                    color: kDark,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'พ้อยท์ของฉัน',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Flexible(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 28.sp,
                                height: 28.sp,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(4.w),
                                  child: SvgPicture.asset(
                                    'assets/images/logo/credit-icon.svg',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              Flexible(
                                child: GradientText(
                                  text:
                                      " ${Provider.of<LineTokenProvider>(context).getRemainingCredits ?? Provider.of<GoogleTokenProvider>(context).getRemainingCredits ?? Provider.of<EmailTokenProvider>(context).getRemainingCredits ?? " N/A"}",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF9340FF),
                                      Color(0xFF34BDFA)
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 5.w),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                // Section: Hot Promotion
                Container(
                  padding: EdgeInsets.all(1.5.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 12.w),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12.r),
                              topRight: Radius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'ด่วน! โปรโมชั่นจำกัด 1/1',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Column(
                          children: mockProvider.mockProducts
                              .map((product) => _buildPromotionItem(
                                    product['title']!,
                                    product['originalPrice'] ?? '',
                                    product['currentPrice']!,
                                    mockProvider,
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                // Section: Starter Promotion (Unchanged UI)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 12.w),
                        child: GradientText(
                          text: 'แพ็คเกจผู้เริ่มต้น',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.grey[300],
                        thickness: 2.0,
                      ),
                      Column(
                        children: mockProvider.mockStarterProducts
                            .map((product) => _buildPromotionItem(
                                  product['title']!,
                                  product['originalPrice'] ?? '',
                                  product['currentPrice']!,
                                  mockProvider,
                                ))
                            .toList(),
                      ),
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
    String title,
    String originalPrice,
    String currentPrice,
    MockPaymentProvider mockProvider,
  ) {
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
                    onPressed: () async {
                      try {
                        await mockProvider.simulatePurchase(title);
                        NotificationDialog(
                          context: context,
                          text: "ได้รับพ้อยท์จำนวน $title",
                          onPressed: () {},
                        ).showCheckmarkModal(context);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("ไม่สามารถทำรายการได้: $e")),
                        );
                      }
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
