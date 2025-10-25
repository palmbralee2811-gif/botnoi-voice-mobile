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
      // ระยะห่างรอบๆ item แต่ละตัว
      padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 7.h),
      child: GestureDetector(
        // เมื่อกดที่ item จะเรียก callback ส่ง index และ speaker กลับไป
        onTap: () => onSpeakerTap(index, speakerItem),
        child: Container(
          // ขนาดหลักของ item (ขึ้นอยู่กับแนวตั้ง/แนวนอน)
          width: ResponsiveDesignOrientation.isLandscape ? 120.w : 100.w,
          height: ResponsiveDesignOrientation.isLandscape ? 313.h : 113.h,
          decoration: BoxDecoration(
            // เส้นขอบแบบ gradient ใช้เมื่อ item ถูกเลือก
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
            // มุมโค้งของกล่อง ต้องใช้ค่าเดียวกันกับ ClipRRect และ overlay เพื่อให้พอดีกัน
            borderRadius: BorderRadius.circular(8.r),
            // เงาสีม่วงแสดงเมื่อ item ถูกเลือก
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
          // ใช้ ClipRRect ครอบ Stack เพื่อให้รูปและ overlay ถูกตัดโค้งเหมือนกัน
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.r),
            child: Stack(
              children: [
                // // รูปพื้นหลังจาก network
                // CachedNetworkImage(
                //   imageUrl: Uri.encodeFull(speakerItem.squareImage),
                //   httpHeaders: const {
                //     'Referer': 'https://voice.botnoi.ai/',
                //     'Accept': 'image/webp,*/*'
                //   },
                //   fit: BoxFit.cover, // ให้รูปขยายครอบเต็ม container
                //   placeholder: (context, url) =>
                //       const Center(child: CircularProgressIndicator()),
                //   errorWidget: (context, url, error) {
                //     Logger().e('Image failed to load: $url, error: $error');
                //     return const Icon(Icons.error);
                //   },
                //   width: double.infinity,  // กำหนดเต็ม container
                //   height: double.infinity, // กำหนดเต็ม container
                // ),
                // รูปพื้นหลังจาก network (optimized)

                // FadeInImage(
                //   placeholder:
                //       MemoryImage(kTransparentImage), // ภาพโปร่งใสเล็ก ๆ
                //   image: ResizeImage(
                //     NetworkImage(
                //       Uri.encodeFull(speakerItem.squareImage),
                //       headers: const {
                //         'Referer': 'https://voice.botnoi.ai/',
                //         'Accept': 'image/webp,*/*'
                //       },
                //     ),
                //     width: 300, // ลดขนาดภาพตอน decode เพื่อลดการใช้หน่วยความจำ
                //     height: 300,
                //   ),
                //   fit: BoxFit.cover,
                //   width: double.infinity,
                //   height: double.infinity,
                //   fadeInDuration: const Duration(milliseconds: 250),
                //   imageErrorBuilder: (context, error, stackTrace) {
                //     Logger().e(
                //         'Image failed to load: ${speakerItem.squareImage}, error: $error');
                //     return const Center(
                //         child: Icon(Icons.error, color: Colors.white70));
                //   },
                // ),

                FadeInImage(
                  // Placeholder: ภาพเล็กโปร่งใส ใช้ในช่วงที่รูปจริงกำลังโหลด
                  // Placeholder image: small transparent image used while the real image is loading
                  placeholder: MemoryImage(kTransparentImage),

                  // Image: ใช้ CachedNetworkImageProvider + ResizeImage
                  // Image provider: Cached + resize to reduce memory usage
                  image: ResizeImage(
                    CachedNetworkImageProvider(
                      Uri.encodeFull(speakerItem
                          .squareImage), // encode URL ให้ถูกต้อง / encode URL correctly
                      headers: const {
                        'Referer':
                            'https://voice.botnoi.ai/', // กำหนด Referer header
                        'Accept': 'image/webp,*/*', // กำหนด Accept header
                      },
                      cacheManager: CacheManager(
                        Config(
                          'customCache', // ชื่อ cache ของเรา / custom cache name
                          stalePeriod: const Duration(
                              days:
                                  7), // เก็บ cache ไว้ 7 วัน / keep cache for 7 days
                          maxNrOfCacheObjects:
                              50, // จำกัดจำนวนไฟล์ cache เพื่อประหยัด storage / limit number of cached objects
                        ),
                      ),
                    ),
                    width:
                        1500, // ปรับขนาดให้ใกล้เคียงกับ UI / resize for UI size
                    height: 1500,
                  ),

                  // ปรับขนาดภาพให้เต็ม container / fit image to container
                  fit: BoxFit.cover,

                  // fade-in effect เพื่อ smooth UX เวลาโหลดรูป / fade-in duration for smooth UX
                  fadeInDuration: const Duration(milliseconds: 200),

                  // กำหนดขนาดให้เต็ม container / width & height to fill container
                  width: double.infinity,
                  height: double.infinity,

                  // Error builder: ถ้าภาพโหลดไม่สำเร็จ จะแสดง icon แทน
                  // Error handling: show icon if image fails to load
                  imageErrorBuilder: (context, error, stackTrace) {
                    Logger().e(
                        'Image failed to load: ${speakerItem.squareImage}, error: $error');
                    return const Center(
                      child: Icon(Icons.error, color: Colors.white70),
                    );
                  },
                ),

                // Overlay ทับบนรูป เพื่อใส่ gradient มืดและแสดงข้อความชัดเจน
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                        8.r), // ให้ตรงกับ Container และ ClipRRect
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
                      // แถวด้านบน แสดงสถานะการเลือก และปุ่ม favorite
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ถ้า item ถูกเลือกจะแสดงป้าย select
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
                          // ปุ่ม favorite หัวใจ (toggle on/off)
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

                      // แถวด้านล่าง ไอคอน play และชื่อ speaker
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 6.w), // เว้นเล็กน้อยไม่ให้ชิดเกินไป
                            // ไอคอน play ขึ้นอยู่กับสถานะการเลือก
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
                            // ชื่อ speaker ข้อความจะบีบให้อยู่ในพื้นที่และตัดด้วย ...
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
