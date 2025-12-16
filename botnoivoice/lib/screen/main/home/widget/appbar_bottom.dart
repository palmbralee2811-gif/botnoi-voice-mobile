import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/screen/main/home_speaker_data_management.dart';
import 'package:botnoivoice/shared/style/style.dart';
import 'package:botnoivoice/screen/main/home/model/appbar_bottom_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/widget/gradient/gradient_icon.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class AppBarBottom extends ConsumerStatefulWidget {
  const AppBarBottom({super.key});

  @override
  ConsumerState<AppBarBottom> createState() => _AppBarBottomState();
}

class _AppBarBottomState extends ConsumerState<AppBarBottom> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final speakerProvider = ref.watch(homeSpeakerDataProvider); // ใช้ watch เพื่อ update UI
    final isLandscape = ResponsiveDesignOrientation.isLandscape;

    String language = Localizations.localeOf(context).languageCode;
    // Fallback logic
    final defaultSpeaker = appbarBottomModel.firstWhere(
      (speaker) => speaker['language'] == language,
      orElse: () => appbarBottomModel.first,
    );

    final speakerName = speakerProvider.speakerName ?? defaultSpeaker['name'];
    final speakerImagePath = speakerProvider.speakerImagePath ?? defaultSpeaker['image'];
    final speakerAudio = speakerProvider.speakerAudio ?? defaultSpeaker['audio'];
    final nationalFlagName = speakerProvider.nationalFlagName ?? defaultSpeaker['flagName'];
    final nationalFlagPath = speakerProvider.nationalFlagPath ?? defaultSpeaker['flagPath'];

    return Container(
      width: double.infinity,
      height: isLandscape ? 60.h : 50.h,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // 🔹 Play Button
          InkWell(
            onTap: () async {
              if (isPlaying) {
                await audioPlayer.stop();
                setState(() => isPlaying = false);
              } else {
                if (speakerAudio != null && speakerAudio.isNotEmpty) {
                  try {
                    final response = await http.get(
                      Uri.parse(speakerAudio),
                      headers: {'Referer': 'https://voice.botnoi.ai/'},
                    );
                    final audioBytes = response.bodyBytes;
                    if (audioBytes.isNotEmpty) {
                      final mimeType = response.headers['content-type'] ?? 'audio/wav';
                      await audioPlayer.play(BytesSource(audioBytes, mimeType: mimeType));
                      setState(() => isPlaying = true);
                    }
                  } catch (e) {
                    debugPrint("Audio Error: $e");
                  }
                }
              }
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
              child: GradientIcon(
                icon: isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                size: isLandscape ? 20.sp : 24.sp,
                gradient: const LinearGradient(
                  colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          
          SizedBox(width: 12.w),
          
          // 🔹 Vertical Divider
          Container(
            height: 24.h,
            width: 1,
            color: Colors.grey.shade200,
          ),
          
          SizedBox(width: 12.w),

          // 🔹 Speaker Info (Clickable Area)
          Expanded(
            child: InkWell(
              onTap: () {
                if (audioPlayer.state == PlayerState.playing) {
                  audioPlayer.stop();
                }
                context.go('/speaker');
              },
              borderRadius: BorderRadius.circular(8.r),
              child: Row(
                children: [
                  // Speaker Image
                  CircleAvatar(
                    radius: isLandscape ? 16.r : 16.r,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: CachedNetworkImageProvider(
                      speakerImagePath!,
                      headers: const {'Referer': 'https://voice.botnoi.ai/'},
                    ),
                  ),
                  SizedBox(width: 10.w),
                  
                  // Text Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          speakerName!,
                          style: GoogleFonts.prompt(
                            fontSize: isLandscape ? 10.sp : 14.sp,
                            fontWeight: FontWeight.w600,
                            color: kDark,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            ClipOval(
                              child: Image.asset(
                                nationalFlagPath!,
                                width: 12.w,
                                height: 12.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              nationalFlagName!,
                              style: GoogleFonts.prompt(
                                fontSize: isLandscape ? 8.sp : 10.sp,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  // Change Button / Arrow
                  Row(
                    children: [
                      Text(
                        'appbar_bottom.change'.tr(),
                        style: GoogleFonts.prompt(
                          fontSize: isLandscape ? 10.sp : 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.blue,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 10.sp,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}