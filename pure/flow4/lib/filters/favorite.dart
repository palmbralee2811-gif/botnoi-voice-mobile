import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Favorite extends StatefulWidget {
  const Favorite({
    super.key,
  });

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  bool ishover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          ishover = !ishover;
        });
        /////////////////////////////////////
      },
      child: Container(
        width: 25.w,
        height: 25.h,
        decoration: BoxDecoration(
          gradient: ishover
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
                ishover ? Icon(
                  Icons.favorite,
                  size: 16.sp,
                  color: Colors.white,
                ):
                Icon(
                  Icons.favorite_border,
                  size: 16.sp,
                  color: Colors.black,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
