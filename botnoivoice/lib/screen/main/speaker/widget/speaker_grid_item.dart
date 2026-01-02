import 'package:botnoivoice/screen/main/speaker/entities/speaker_entity.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:logger/logger.dart';
import 'package:transparent_image/transparent_image.dart';

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
    return Padding(
      // Spacing around the card
      padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 7.h),
      child: GestureDetector(
        // Handle tap event to select the speaker
        onTap: () => onSpeakerTap(index, speakerItem),
        child: Container(
          // Card dimensions based on orientation
          width: ResponsiveDesignOrientation.isLandscape ? 120.w : 100.w,
          height: ResponsiveDesignOrientation.isLandscape ? 313.h : 113.h,
          decoration: BoxDecoration(
            // Gradient border: colorful if selected, subtle if not
            border: GradientBoxBorder(
              width: 3.w,
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
                    )
                  : LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.05),
                        Colors.white.withOpacity(0.05),
                      ],
                      begin: const Alignment(1, 1),
                    ),
            ),
            // Rounded corners (matches the ClipRRect below)
            borderRadius: BorderRadius.circular(8.r),
            // Glow effect when selected
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
          // Clips the image and overlay to match rounded corners
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Stack(
              children: [
                FadeInImage(
                  // Transparent placeholder while loading
                  placeholder: MemoryImage(kTransparentImage),

                  // Load and resize image to save memory
                  image: ResizeImage(
                    CachedNetworkImageProvider(
                      Uri.encodeFull(speakerItem.squareImage),
                      headers: const {
                        'Referer': 'https://voice.botnoi.ai/',
                        'Accept': 'image/webp,*/*',
                      },
                      // Custom cache config: keep for 7 days, max 50 files
                      cacheManager: CacheManager(
                        Config(
                          'customCache',
                          stalePeriod: const Duration(days: 7),
                          maxNrOfCacheObjects: 50,
                        ),
                      ),
                    ),
                    // Resize to fit within 500x500 without distorting aspect ratio
                    policy: ResizeImagePolicy.fit,
                    width: 500,
                    height: 500,
                  ),

                  // Fill the container
                  fit: BoxFit.cover,

                  // Smooth fade-in effect
                  fadeInDuration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  height: double.infinity,

                  // Show error icon if loading fails
                  imageErrorBuilder: (context, error, stackTrace) {
                    Logger().e(
                        'Image failed to load: ${speakerItem.squareImage}, error: $error');
                    return const Center(
                      child: Icon(Icons.error),
                    );
                  },
                ),

                // Dark gradient overlay to make text readable
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    gradient: LinearGradient(
                      begin: const Alignment(1, 1),
                      colors: [
                        Colors.black.withOpacity(0.9),
                        Colors.transparent
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Top Row: "Select" badge and Favorite icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // "Select" badge (only shows when selected)
                          Padding(
                            padding: EdgeInsets.only(
                                right: 5.w, top: 5.w, left: 5.w),
                            child: isSelected
                                ? Container(
                                    width: 31.w,
                                    height:
                                        ResponsiveDesignOrientation.isLandscape
                                            ? 30.h
                                            : 17.h,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF9A96F5),
                                          Color(0xFF00E0FF)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          ResponsiveDesignOrientation
                                                  .isLandscape
                                              ? 16.r
                                              : 8.r),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'select'.tr(),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontStyle:
                                              GoogleFonts.prompt().fontStyle,
                                          fontSize: ResponsiveDesignOrientation
                                                  .isLandscape
                                              ? 6.sp
                                              : 8.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  )
                                : const Icon(Icons.check,
                                    color: Colors.transparent),
                          ),
                          // Heart icon (toggle favorite)
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
                                            Color(0xFF00E0FF)
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
                          ),
                        ],
                      ),

                      // Bottom Row: Play icon and Speaker Name
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 6.w), // Small spacer
                            // Play icon (color changes if selected)
                            isSelected
                                ? ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return const LinearGradient(
                                        colors: [
                                          Color(0xFF9A96F5),
                                          Color(0xFF00E0FF)
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
                            // Speaker name (Localized: TH/EN)
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
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}