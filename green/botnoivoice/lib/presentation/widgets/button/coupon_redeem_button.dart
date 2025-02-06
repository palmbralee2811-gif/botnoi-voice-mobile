import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CouponRedeemButton extends StatelessWidget {
  final String text;
  final String text2;
  final String text3;
  final Color textColor;
  final Color textColor2;
  final Color textColor3;
  final String points;
  final VoidCallback onTap;

  const CouponRedeemButton({
    super.key,
    required this.onTap,
    required this.text,
    required this.text2,
    required this.text3,
    required this.textColor,
    required this.textColor2,
    required this.textColor3,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = MediaQuery.of(context).size.width >= 600;
    final bool isLandscape = OrientationHelper.isLandscape;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: isTablet
            ? (isLandscape ? 200.w : 180.w) //Tablet
            : (isLandscape ? 120.w : 200.w), //Mobile
        height: isTablet
            ? (isLandscape ? 340.h : 250.h) //Tablet
            : (isLandscape ? 250.h : 200.h), //Mobile
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(42),
          border: Border.all(color: Colors.blue[700]!, width: 3),
        ),
        child: Column(
          children: [
            Icon(
              Icons.card_giftcard,
              color: Colors.green,
              size: isTablet ? (isLandscape ? 100 : 120) : 75,
            ),
            const SizedBox(height: 12),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontSize: isTablet ? (isLandscape ? 30 : 44) : 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  text2,
                  style: TextStyle(
                    color: textColor2,
                    fontSize: isTablet ? (isLandscape ? 30 : 44) : 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                text3,
                style: TextStyle(
                  color: textColor3,
                  fontSize: isTablet ? (isLandscape ? 28 : 30) : 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
