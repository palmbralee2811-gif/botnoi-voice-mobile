import 'package:botnoivoice/screen/drawer/marads/widgets/models/mar_ads_history_model.dart';
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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
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
              // Speaker Selection
              GestureDetector(
                onTap: onSelectSpeaker,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(speaker.image),
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              speaker.thaiName,
                              style: GoogleFonts.prompt(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: MarAdsUIStyle.primary,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down,
                                size: 16.sp, color: Colors.black54),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              if (item.hasAudio && item.audioUrl.isNotEmpty)
                InkWell(
                  onTap: onDownload,
                  child: Icon(Icons.file_download_outlined,
                      color: Colors.black54, size: 24.sp),
                ),
              SizedBox(width: 8.w),
              InkWell(
                onTap: onOptions,
                child:
                    Icon(Icons.more_vert, color: Colors.black54, size: 24.sp),
              ),
            ],
          ),
          SizedBox(height: 12.h),

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
              color: MarAdsUIStyle
                  .textBody, // หรือ MarAdsUIStyle.textBody ถ้าเพิ่มแล้ว
              height: 1.5,
            ),
            maxLines: 3,
          ),
          SizedBox(height: 12.h),

          // Action Area: Audio Player OR Generate Button
          if (item.hasAudio && item.audioUrl.isNotEmpty)
            _buildAudioPlayer(context, durationText)
          else
            _buildGenerateButton(),

          SizedBox(height: 8.h),
          const Divider(),
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
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
              Text(
                '${item.points} | ${item.chars}',
                style: GoogleFonts.inter(
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

  Widget _buildAudioPlayer(BuildContext context, String durationText) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          InkWell(
            onTap: onPlayPause,
            child: Icon(
              isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
              color: MarAdsUIStyle.primary,
              size: 32.sp,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: MarAdsUIStyle.primary,
                inactiveTrackColor: Colors.grey[300],
                thumbColor: MarAdsUIStyle.primary,
                trackHeight: 2.h,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
              ),
              child: Slider(
                min: 0,
                max: totalDuration.inMilliseconds.toDouble() > 0
                    ? totalDuration.inMilliseconds.toDouble()
                    : 1.0,
                value: currentPosition.inMilliseconds
                    .toDouble()
                    .clamp(0.0, totalDuration.inMilliseconds.toDouble()),
                onChanged: onSeek,
              ),
            ),
          ),
          Text(
            durationText,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return InkWell(
      onTap: onGenerateAudio,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: MarAdsUIStyle.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: MarAdsUIStyle.primary, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.graphic_eq_rounded,
                color: MarAdsUIStyle.primary, size: 20.sp),
            SizedBox(width: 8.w),
            Text(
              'สร้างเสียง',
              style: GoogleFonts.prompt(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: MarAdsUIStyle.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
