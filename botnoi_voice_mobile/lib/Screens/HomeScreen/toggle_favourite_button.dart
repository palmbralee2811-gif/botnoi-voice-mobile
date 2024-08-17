import 'package:botnoi_voice_mobile/Screens/HomeScreen/voice_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ToggleFavouriteButton extends StatelessWidget {
  const ToggleFavouriteButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Provider.of<VoiceConfigProvider>(context, listen: false)
            .toggleFavouriteSelected();
      },
      child: Container(
        width: 25.w,
        height: 25.h,
        decoration: BoxDecoration(
          gradient:
              Provider.of<VoiceConfigProvider>(context).isFavouriteSelected
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
                Provider.of<VoiceConfigProvider>(context).isFavouriteSelected
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
      ),
    );
  }
}
