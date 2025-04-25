import 'package:botnoivoice/data/entities/speaker_entity.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:logger/logger.dart';

class SpeakerGridItem extends StatelessWidget {
  final SpeakerEntity speakerItem;
  final int index;
  final bool isSelected;
  final bool isFavorite;
  final Function(int index, SpeakerEntity speaker) onSpeakerTap;
  final Function(String speakerId) onFavoriteToggle;

  const SpeakerGridItem({
    super.key,
    required this.speakerItem,
    required this.index,
    required this.isSelected,
    required this.isFavorite,
    required this.onSpeakerTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 7.h),
          child: GestureDetector(
            onTap: () => onSpeakerTap(index, speakerItem), // ใช้ Callback
            child: Column(
              children: [
                Container(
                  width:
                      ResponsiveDesignOrientation.isLandscape ? 120.w : 100.w,
                  height:
                      ResponsiveDesignOrientation.isLandscape ? 313.h : 113.h,
                  decoration: BoxDecoration(
                    border: GradientBoxBorder(
                      width: 3.w,
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
                            )
                          : LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.9),
                                Colors.transparent,
                              ],
                              begin: const Alignment(1, 1),
                            ),
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                        speakerItem.squareImage,
                        headers: const {
                          'Referer': 'https://voice.botnoi.ai/',
                        },
                      ),
                      onError: (exception, stackTrace) {
                        Logger().e('image not load');
                      },

                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 1,
                        color: isSelected
                            ? const Color(0xFF9340FF).withOpacity(0.6)
                            : Colors.transparent,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Container(
                    width: 100.w,
                    height: 113.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.r),
                      gradient: LinearGradient(
                        begin: const Alignment(1, 1),
                        colors: [
                          Colors.black.withOpacity(0.9),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  right: 5.w, top: 5.w, left: 5.w),
                              child: isSelected // ใช้ isSelected
                                  ? Container(
                                      width: 31.w,
                                      height: ResponsiveDesignOrientation
                                              .isLandscape
                                          ? 30.h
                                          : 17.h,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF9A96F5),
                                            Color(0xFF00E0FF)
                                          ],
                                        ),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            ResponsiveDesignOrientation
                                                    .isLandscape
                                                ? 16.r
                                                : 8.r),
                                      ),
                                      child: Center(
                                        child: Text('select'.tr(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontStyle: GoogleFonts.prompt()
                                                  .fontStyle,
                                              fontSize:
                                                  ResponsiveDesignOrientation
                                                          .isLandscape
                                                      ? 6.sp
                                                      : 8.sp,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                    )
                                  : const Icon(
                                      Icons.check,
                                      color: Colors.transparent,
                                    ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 5.w, top: 5.w),
                              child: GestureDetector(
                                onTap: () =>
                                    onFavoriteToggle(speakerItem.speakerId),
                                child: isFavorite
                                    ? ShaderMask(
                                        shaderCallback: (Rect bounds) {
                                          return const LinearGradient(
                                            colors: [
                                              Color(0xFF9A96F5),
                                              Color(0xFF00E0FF),
                                            ],
                                          ).createShader(bounds);
                                        },
                                        child: SvgPicture.asset(
                                          'assets/images/icon/heart-on.svg',
                                          width: ResponsiveDesignOrientation
                                                  .isLandscape
                                              ? 50.w
                                              : 20.w,
                                          height: ResponsiveDesignOrientation
                                                  .isLandscape
                                              ? 50.h
                                              : 20.h,
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        'assets/images/icon/heart-off.svg',
                                        width: ResponsiveDesignOrientation
                                                .isLandscape
                                            ? 50.w
                                            : 20.w,
                                        height: ResponsiveDesignOrientation
                                                .isLandscape
                                            ? 50.h
                                            : 20.h,
                                      ),
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 10.w),
                            isSelected // ใช้ isSelected
                                ? ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const LinearGradient(
                                        colors: [
                                          Color(0xFF9A96F5),
                                          Color(0xFF00E0FF),
                                        ],
                                      ).createShader(bounds);
                                    },
                                    child: SvgPicture.asset(
                                      'assets/images/icon/play-on.svg',
                                      width: ResponsiveDesignOrientation
                                              .isLandscape
                                          ? 12.h
                                          : 16.h,
                                      height: ResponsiveDesignOrientation
                                              .isLandscape
                                          ? 12.w
                                          : 16.w,
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'assets/images/icon/play-off.svg',
                                    width:
                                        ResponsiveDesignOrientation.isLandscape
                                            ? 12.h
                                            : 16.h,
                                    height:
                                        ResponsiveDesignOrientation.isLandscape
                                            ? 12.w
                                            : 16.w,
                                  ),
                            SizedBox(width: 3.w),
                            Expanded(
                                child: Text(
                              Localizations.localeOf(context).languageCode ==
                                      'th'
                                  ? speakerItem.thaiName
                                  : speakerItem.engName,
                              style: GoogleFonts.prompt(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}