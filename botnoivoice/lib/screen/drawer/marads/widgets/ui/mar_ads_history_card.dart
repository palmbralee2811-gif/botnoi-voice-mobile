import 'package:botnoivoice/screen/drawer/marads/widgets/models/mar_ads_history_model.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/gradient_slider_shape.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';
import 'package:botnoivoice/screen/main/speaker/entities/speaker_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class MarAdsHistoryCard extends StatelessWidget {
  final MarAdsHistoryModel item;
  final SpeakerEntity speaker;
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final String searchQuery;

  // Callbacks
  final VoidCallback onSelectSpeaker;
  final VoidCallback onPlayPause;
  final Function(double) onSeek;
  final VoidCallback onGenerateAudio;
  final VoidCallback onDownload;
  final VoidCallback onOptions;

  const MarAdsHistoryCard({
    super.key,
    required this.item,
    required this.speaker,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    required this.searchQuery,
    required this.onSelectSpeaker,
    required this.onPlayPause,
    required this.onSeek,
    required this.onGenerateAudio,
    required this.onDownload,
    required this.onOptions,
  });

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  Widget _buildHighlightedText(String text, TextStyle style, {int? maxLines}) {
    if (searchQuery.isEmpty ||
        !text.toLowerCase().contains(searchQuery.toLowerCase())) {
      return Text(
        text,
        style: style,
        maxLines: maxLines,
        overflow: maxLines != null ? TextOverflow.ellipsis : null,
      );
    }

    final List<TextSpan> spans = [];
    final String lowerText = text.toLowerCase();
    final String lowerQuery = searchQuery.toLowerCase();
    int start = 0;
    int indexOfHighlight = lowerText.indexOf(lowerQuery);

    while (indexOfHighlight != -1) {
      if (indexOfHighlight > start) {
        spans.add(TextSpan(
          text: text.substring(start, indexOfHighlight),
          style: style,
        ));
      }

      spans.add(TextSpan(
        text: text.substring(
            indexOfHighlight, indexOfHighlight + searchQuery.length),
        style: style.copyWith(
          backgroundColor: const Color(0xFFFFD54F).withOpacity(0.4),
          color: Colors.black,
        ),
      ));

      start = indexOfHighlight + searchQuery.length;
      indexOfHighlight = lowerText.indexOf(lowerQuery, start);
    }

    if (start < text.length) {
      spans.add(TextSpan(
        text: text.substring(start),
        style: style,
      ));
    }

    return Text.rich(
      TextSpan(children: spans),
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String durationText = isPlaying
        ? "${_formatDuration(currentPosition)}/${_formatDuration(totalDuration)}"
        : item.duration == '00:00/00:00'
            ? "00:00/00:00"
            : item.duration; // Fallback to item duration if not playing

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEEDDF3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar + Title + Actions
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Speaker Selection (ใช้ Expanded เพื่อกันพื้นที่ส่วนนี้ไม่ให้ดันไอคอนขวาตกขอบ)
              Expanded(
                child: GestureDetector(
                  onTap: onSelectSpeaker,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(speaker.image),
                      ),
                      SizedBox(width: 12.w),
                      // ใช้ Flexible เพื่อให้ชื่อหดลงได้ถ้าพื้นที่ไม่พอ (เช่น มีปุ่ม Generate)
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    speaker.thaiName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis, // ตัดคำถ้าชื่อยาวเกิน
                                    style: GoogleFonts.prompt(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: MarAdsUIStyle.primary,
                                    ),
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_down,
                                    size: 16.sp, color: Colors.black54),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // [1] ปุ่ม Generate
                      if (!item.hasAudio) ...[
                        SizedBox(width: 8.w),
                        InkWell(
                          onTap: onGenerateAudio,
                          borderRadius: BorderRadius.circular(4.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              border: Border.all(color: const Color(0xFF01BFFB)),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              "Generate",
                              style: GoogleFonts.prompt(
                                  fontSize: 10.sp,
                                  color: const Color(0xFF01BFFB)),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              // ลบ Spacer() ออก เพราะเราใช้ Expanded ที่ Widget ด้านซ้ายแล้ว
              // แต่เพิ่มระยะห่างนิดหน่อยเพื่อความสวยงาม
              SizedBox(width: 8.w),

              // [2] ปุ่ม Download
              InkWell(
                onTap: item.hasAudio ? onDownload : null,
                child: Icon(
                  Icons.file_download_outlined,
                  color: item.hasAudio ? Colors.black54 : Colors.grey[300],
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 8.w),
              InkWell(
                onTap: onOptions,
                child:
                    Icon(Icons.more_vert, color: Colors.black54, size: 24.sp),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          const Divider(
              color: Color(0xFFF5F5F5), thickness: 2),
          SizedBox(height: 2.h),

          // Title
          _buildHighlightedText(
            item.title,
            GoogleFonts.prompt(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: MarAdsUIStyle.primary,
            ),
          ),
          SizedBox(height: 8.h),

          // Content Text
          _buildHighlightedText(
            item.content,
            GoogleFonts.sarabun(
              fontSize: 14.sp,
              color: MarAdsUIStyle.textBody,
              height: 1.5,
            ),
            maxLines: 3,
          ),
          SizedBox(height: 12.h),

          _buildAudioPlayer(context, durationText, isEnabled: item.hasAudio),

          SizedBox(height: 8.h),

          // Footer Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (item.style.isNotEmpty && item.style != '-')
                    Text(
                      item.style,
                      style: GoogleFonts.prompt(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
              Text(
                '${item.points}  ${item.chars}',
                style: GoogleFonts.prompt(
                  fontSize: 12.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer(BuildContext context, String durationText,
      {required bool isEnabled}) {
    const List<Color> activeGradient = [Color(0xFF9340FF), Color(0xFF34BDFA)];
    final Gradient gradient = LinearGradient(colors: activeGradient);
    final Color inactiveColor = Colors.grey[300]!;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        children: [
          InkWell(
            onTap: isEnabled ? onPlayPause : null,
            child: isEnabled
                ? ShaderMask(
                    shaderCallback: (Rect bounds) =>
                        gradient.createShader(bounds),
                    child: Icon(
                      isPlaying
                          ? Icons.pause_circle_outlined
                          : Icons.play_circle_outlined,
                      color: Colors.white,
                      size: 30.sp,
                    ),
                  )
                : Icon(
                    isPlaying
                        ? Icons.pause_circle_outlined
                        : Icons.play_circle_outlined,
                    color: inactiveColor,
                    size: 30.sp,
                  ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4.h,
                trackShape: GradientSliderTrackShape(
                    gradient: gradient, darkenInactive: false),
                thumbShape: RingSliderThumbShape(
                    gradient: gradient, radius: 8.r, ringThickness: 2.5),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: inactiveColor.withOpacity(0.3),
              ),
              child: Slider(
                min: 0,
                max: totalDuration.inMilliseconds.toDouble() > 0
                    ? totalDuration.inMilliseconds.toDouble()
                    : 1.0,
                value: currentPosition.inMilliseconds
                    .toDouble()
                    .clamp(0.0, totalDuration.inMilliseconds.toDouble()),
                onChanged: isEnabled ? onSeek : null,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            durationText,
            style: GoogleFonts.prompt(
              fontSize: 12.sp,
              color: const Color(0xFF9E9E9E),
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}