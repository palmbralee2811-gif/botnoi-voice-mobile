import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/widget/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class BottomNavbarButton extends StatelessWidget {
  final AudioPlayer audioPlayer;

  const BottomNavbarButton({
    super.key,
    required this.audioPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveDesignOrientation.isLandscape ? 40.w : 20.w),
      child: SizedBox(
        height: ResponsiveDesignOrientation.isLandscape ? 70.h : 50.h,
        child: GradientTextButton(
          text: 'confirm'.tr(),
          onPressed: () {
            if (audioPlayer.state == PlayerState.playing) {
              audioPlayer.stop();
            }

            // Redirect to Home Screen
            context.go('/home');
          },
        ),
      ),
    );
  }
}
