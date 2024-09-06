import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class ErrorDialog {
  ErrorDialog({
    required this.context,
    required this.text,
  });

  final String text;
  final BuildContext context;

  void showAsError({bool speak = false}) {
    showToastWidget(
      Container(
        height: 180.h,
        width: 280.w,
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 20.w,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(205, 244, 67, 54),
          borderRadius: BorderRadius.circular(
            30.h,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              color: Colors.white,
              size: 30.h,
            ),
            SizedBox(height: 10.h),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 3,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.h,
                ),
              ),
            ),
          ],
        ),
      ),
      context: context,
      animation: StyledToastAnimation.slideFromTopFade,
      reverseAnimation: StyledToastAnimation.slideToTopFade,
      animDuration: const Duration(milliseconds: 300),
      duration: const Duration(seconds: 4),
      position: StyledToastPosition.top,
    );
  }

  void showAsSuccess({bool speak = false}) {
    showToastWidget(
      Container(
        height: 180.h,
        width: 400.w,
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 20.w,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(199, 76, 175, 79),
          borderRadius: BorderRadius.circular(
            30.h,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_rounded,
              color: Colors.white,
              size: 30.h,
            ),
            SizedBox(height: 10.h),
            Flexible(
              child: Text(
                text,
                textAlign: TextAlign.center,
                softWrap: true,
                maxLines: 3,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.h,
                ),
              ),
            ),
          ],
        ),
      ),
      context: context,
      animation: StyledToastAnimation.slideFromTopFade,
      reverseAnimation: StyledToastAnimation.slideToTopFade,
      animDuration: const Duration(milliseconds: 300),
      duration: const Duration(seconds: 4),
      position: StyledToastPosition.top,
    );
  }

  void showAsInfo({bool speak = false}) {
    showToastWidget(
      Container(
        height: 180.h,
        width: 400.w,
        padding: EdgeInsets.symmetric(
          vertical: 10.h,
          horizontal: 20.w,
        ),
        decoration: BoxDecoration(
          color: const Color.fromARGB(234, 255, 255, 255),
          borderRadius: BorderRadius.circular(
            30.h,
          ),
        ),
        child: Center(
          child: Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              softWrap: true,
              maxLines: 3,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 18.h,
              ),
            ),
          ),
        ),
      ),
      context: context,
      animation: StyledToastAnimation.slideFromTopFade,
      reverseAnimation: StyledToastAnimation.slideToTopFade,
      animDuration: const Duration(milliseconds: 300),
      duration: const Duration(seconds: 4),
      position: StyledToastPosition.top,
    );
  }
}
