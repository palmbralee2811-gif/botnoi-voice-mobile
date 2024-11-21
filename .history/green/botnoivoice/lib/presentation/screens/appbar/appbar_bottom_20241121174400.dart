import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/data/repositories/speaker_repository_impl.dart';
import 'package:botnoivoice/presentation/screens/speaker/speaker_screen.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_icon.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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
    String selectedName = context.locale.languageCode == 'th'
        ? speakerProvider.speaker?.thaiName ?? 'เอวา'
        : speakerProvider.speaker?.engName ?? 'Ava';

    return SizedBox(
      width: double.infinity,
      height: 60.h,
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
              padding: EdgeInsets.all(8.w),
              child: GradientIcon(
                icon: isPlaying
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                size: 24.sp,
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
                padding: EdgeInsets.all(8.w),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 14.r,
                      backgroundImage: speakerProvider.speakerImagePath != null
                          ? AssetImage(speakerProvider.speakerImagePath!)
                          : const AssetImage(
                              "assets/square_image/square_ava.webp"),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      speakerProvider.speakerName ?? 'เอวา',
                      style: GoogleFonts.prompt(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF323130),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      width: 4.w,
                      height: 4.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    CircleAvatar(
                      radius: 7.r,
                      backgroundImage: speakerProvider.nationalFlagPath != null
                          ? AssetImage(speakerProvider.nationalFlagPath!)
                          : const AssetImage(
                              "assets/images/national_flag/thai.png"),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      speakerProvider.nationalFlagName ?? 'ไทย',
                      style: GoogleFonts.prompt(
                        fontSize: 10.sp,
                        color: const Color(0xFF323130),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'เปลี่ยน',
                      style: GoogleFonts.prompt(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF323130),
                      ),
                    ),
                    SizedBox(width: 16.w),
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
