import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavouriteFilterButton extends StatelessWidget {
  const FavouriteFilterButton({
    super.key,
    required this.isFavouriteSelected,
  });

  final bool isFavouriteSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25.w,
      height: 25.h,
      decoration: BoxDecoration(
        gradient: isFavouriteSelected
            ? const LinearGradient(
                colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
              )
            : null,
        borderRadius: BorderRadius.all(
          Radius.circular(4.r),
        ),
        border: Border.all(
          color: const Color(0xFFE2E3E9),
          width: 1.w,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isFavouriteSelected
                  ? Icon(
                      Icons.favorite,
                      size: 16.sp,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.favorite_border,
                      size: 16.sp,
                      color: Colors.black,
                    ),
            ],
          )
        ],
      ),
    );
  }
}
