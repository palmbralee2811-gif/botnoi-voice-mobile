import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// ignore: depend_on_referenced_packages

class RedeemCoupon extends StatelessWidget {
  const RedeemCoupon({super.key});

  @override
  Widget build(BuildContext context) {
    String languageCode = Localizations.localeOf(context).languageCode;
    final DateTime localizedNow = DateTime.now()
        .toUtc()
        .add(const Duration(hours: 7)); // Adjust to Thailand timezone (UTC+7)
    if (languageCode == 'th') {
      Intl.defaultLocale = 'th_TH';
    } else {
      Intl.defaultLocale = 'en_US';
    }
    // Intl.defaultLocale = 'th_TH';
    final String thaiDate = DateFormat('dd MMMM yyyy', 'th').format(localizedNow);
    final String englishDate = DateFormat('dd MMM yyyy', 'en').format(localizedNow);

    String currentDate;
    if (localizedNow.isAfter(DateTime(localizedNow.year, localizedNow.month, localizedNow.day, 8))) {
      currentDate = languageCode == 'th' ? thaiDate : englishDate;
    } else {
      currentDate = languageCode == 'en' ? thaiDate : englishDate;
    }

    final bool isTablet = MediaQuery.of(context).size.width > 600;
    final bool isLandscape = OrientationHelper.isLandscape;
    int timeout = 12;
    int points = 100;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                // 'คูปองพอยท์ฟรีรายวัน $thaiDate',
                'redeem.daily_coupon_title'.tr(namedArgs: {'thaiDate': thaiDate}),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: isTablet ? (isLandscape ? 48 : 40) : 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                //'08:00 AM',
                'redeem.time'.tr(namedArgs: {'currentDate': currentDate.toString()}),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: isTablet ? (isLandscape ? 28 : 30) : 16,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(isTablet ? 16 : 16),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.card_giftcard,
                      color: Colors.green,
                      size: isTablet ? (isLandscape ? 100 : 120) : 60,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      // 'รับเลย $points พอยท์'.tr(),
                      'redeem.get_points'.tr(namedArgs: {'points': points.toString()}),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: isTablet ? (isLandscape ? 40 : 44) : 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      // 'รับเลย 100 พอยท์ ง่ายๆ แค่เปิดหน้า ราคาและกด คูปอง'.tr(),
                      'redeem.description'.tr(),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: isTablet ? (isLandscape ? 28 : 30) : 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      // 'เหลือเวลาถึงเที่ยง $timeout ชั่วโมง'.tr(),
                      'redeem.time_remaining'.tr(namedArgs: {'Timeout': timeout.toString()}),
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: isTablet ? (isLandscape ? 28 : 30) : 16,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: isLandscape ? 80 : (isTablet ? 500 : 295),
              ),
              Padding(
                padding: EdgeInsets.only(
                left: isTablet ? (isLandscape ? 60.w : 20.w) : 10.w, 
                right: isTablet ? (isLandscape ? 60.w : 20.w) : 10.w),
                child: GradientTextButton(
                  text: 'redeem.use_now'.tr(),
                  onPressed: () {
                    // Handle button press
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
