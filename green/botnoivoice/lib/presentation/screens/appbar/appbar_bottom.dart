import 'package:audioplayers/audioplayers.dart';
// import 'package:botnoivoice/data/models/speaker_model.dart';
import 'package:botnoivoice/data/repositories/speaker_repository_impl.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/screens/speaker/speaker_screen.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
// import 'package:botnoivoice/data/models/speaker_entity.dart';

class AppBarBottom extends StatefulWidget {
  const AppBarBottom({
    super.key,
  });

  @override
  State<AppBarBottom> createState() => _AppBarBottomState();
}

class _AppBarBottomState extends State<AppBarBottom> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final speakerProvider = Provider.of<SpeakerRepositoryImpl>(context);
    return SizedBox(
      width: double.infinity,
      height: OrientationHelper.isLandscape ? 80.h : 42.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              String? audioURL = speakerProvider.speakerAudio ??
                  "https://botnoi-voice.s3.ap-southeast-1.amazonaws.com/picture/ava/sound_ava.wav";
              if (isPlaying) {
                await audioPlayer.stop();
                setState(() {
                  isPlaying = false;
                });
              } else {
                if (audioURL.isNotEmpty) {
                  await audioPlayer.play(UrlSource(audioURL));
                  setState(() {
                    isPlaying = true;
                  });
                }
              }
            },
            child: Padding(
              padding:
                  EdgeInsets.all(OrientationHelper.isLandscape ? 2.w : 8.w),
              child: GradientIcon(
                icon: isPlaying
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                size: OrientationHelper.isLandscape ? 18.sp : 24.sp,
                gradient: const LinearGradient(
                  colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SpeakerScreen()),
                );
              },
              child: Padding(
                padding:
                    EdgeInsets.all(OrientationHelper.isLandscape ? 2.w : 8.w),
                child: Row(
                  children: [
                    // CircleAvatar(
                    //   radius: OrientationHelper.isLandscape ? 22.r : 14.r,
                    //   backgroundImage: speakerProvider.speakerImagePath != null
                    //       ? AssetImage(speakerProvider.speakerImagePath!)
                    //       : const AssetImage(
                    //           "assets/square_image/square_ava.webp"),
                    // ),
                    CircleAvatar(
                      radius: OrientationHelper.isLandscape ? 22.r : 14.r,
                      backgroundImage: speakerProvider.speakerImagePath != null
                          ? NetworkImage(speakerProvider.speakerImagePath!)
                          : const AssetImage(
                                  "assets/square_image/square_ava.webp")
                              as ImageProvider,
                    ),
                    SizedBox(width: OrientationHelper.isLandscape ? 6.w : 8.w),
                    Text(
                      speakerProvider.getName(context),
                      // speakerProvider.speakerName ?? 'เอวา',
                      style: GoogleFonts.prompt(
                        fontSize: OrientationHelper.isLandscape ? 8.sp : 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF323130),
                      ),
                    ),
                    SizedBox(width: OrientationHelper.isLandscape ? 6.w : 8.w),
                    Container(
                      width: OrientationHelper.isLandscape ? 2.w : 4.w,
                      height: OrientationHelper.isLandscape ? 2.w : 4.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(width: OrientationHelper.isLandscape ? 6.w : 8.w),
                    CircleAvatar(
                      radius: OrientationHelper.isLandscape ? 16.r : 7.r,
                      backgroundImage: speakerProvider.nationalFlagPath != null
                          ? AssetImage(speakerProvider.nationalFlagPath!)
                          : const AssetImage(
                              "assets/images/national_flag/thai.png"),
                    ),
                    SizedBox(width: OrientationHelper.isLandscape ? 4.w : 8.w),
                    Text(
                      speakerProvider.nationalFlagName ??
                          'appbar_bottom.thai'.tr(),
                      style: GoogleFonts.prompt(
                        fontSize: OrientationHelper.isLandscape ? 7.sp : 10.sp,
                        color: const Color(0xFF323130),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'appbar_bottom.change'.tr(),
                      style: GoogleFonts.prompt(
                        fontSize: OrientationHelper.isLandscape ? 8.sp : 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF323130),
                      ),
                    ),
                    SizedBox(
                        width: OrientationHelper.isLandscape ? 10.w : 16.w),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
