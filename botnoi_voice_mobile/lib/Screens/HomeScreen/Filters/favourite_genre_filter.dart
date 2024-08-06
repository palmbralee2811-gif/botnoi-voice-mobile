import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavouriteGenreFilter extends StatelessWidget {
  const FavouriteGenreFilter({
    super.key,
    required this.isSelected,
  });

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 25.w,
      height: 25.h,
      decoration: BoxDecoration(
        gradient: isSelected
            ? const LinearGradient(
                colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
              )
            : null,
        borderRadius: const BorderRadius.all(
          Radius.circular(4),
        ),
        border: Border.all(
          color: const Color(0xFFE2E3E9),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              isSelected
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
