import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Selectvoice extends StatelessWidget {
  const Selectvoice({
    super.key,
    required this.screenSizeheight,
    required int selectedPageIndexVoice,
  }) : _selectedPageIndexVoice = selectedPageIndexVoice;

  final double screenSizeheight;
  final int _selectedPageIndexVoice;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: screenSizeheight * 0.06.h,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.grey,
              width: 1.w,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Text(
                "เลือกเสียง",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: _selectedPageIndexVoice == 1
                    ? Icon(
                        Icons.expand_less,
                        color: const Color(0xFF323130),
                        size: 20.sp,
                      )
                    : Icon(
                        Icons.expand_more,
                        color: const Color(0xFF323130),
                        size: 20.sp,
                      )),
          ],
        ));
  }
}
