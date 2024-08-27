import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/Screens/AllSpeakerScreen/speaker_provider.dart';
import 'package:botnoivoice/Screens/AllSpeakerScreen/all_speaker_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class AppbarBottomNavbar extends StatefulWidget {
  const AppbarBottomNavbar({
    super.key,
  });

  @override
  State<AppbarBottomNavbar> createState() => _AppbarBottomNavbarState();
}

class _AppbarBottomNavbarState extends State<AppbarBottomNavbar> {
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
    final speakerProvider = Provider.of<SpeakerProvider>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            String? audioURL = speakerProvider.speakerAudio ??
                "https://bn-voice-pics.s3.ap-southeast-1.amazonaws.com/picture/ava/sound_1_ava.wav";
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
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                Icon(
                  isPlaying
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                  size: 24.sp,
                  color: Colors.black,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AllSpeakerScreen()),
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
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF323130),
                      fontFamily: 'Prompt',
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
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: const Color(0xFF323130),
                      fontFamily: 'Prompt',
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'เปลี่ยน',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF323130),
                      fontFamily: 'Prompt',
                    ),
                  ),
                  SizedBox(width: 16.w),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
