import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/ui/screen/main/home_speaker_data_management.dart';
import 'package:botnoivoice/ui/style/style.dart';
import 'package:botnoivoice/data/model/appbar_bottom_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/ui/widget/gradient/gradient_icon.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

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
    final speakerProvider = Provider.of<HomeSpeakerDataManagement>(context);
    String language = Localizations.localeOf(context).languageCode;

    final speakerInfo = appbarBottomModel
        .firstWhere((speaker) => speaker['language'] == language);

    final speakerName = speakerProvider.speakerName ?? speakerInfo['name'];
    final speakerImagePath =
        speakerProvider.speakerImagePath ?? speakerInfo['image'];
    final speakerAudio = speakerProvider.speakerAudio ?? speakerInfo['audio'];
    final nationalFlagName =
        speakerProvider.nationalFlagName ?? speakerInfo['flagName'];
    final nationalFlagPath =
        speakerProvider.nationalFlagPath ?? speakerInfo['flagPath'];

    return SizedBox(
      width: double.infinity,
      height: ResponsiveDesignOrientation.isLandscape ? 80.h : 60.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          InkWell(
            onTap: () async {
              if (isPlaying) {
                await audioPlayer.stop();
                setState(() {
                  isPlaying = false;
                });
              } else {
                if (speakerAudio != null && speakerAudio.isNotEmpty) {
                   // ดาวน์โหลดไฟล์เสียงพร้อม Referer Header
                  final response = await http.get(
                    Uri.parse(speakerAudio),
                    headers: {
                      'Referer': 'https://voice.botnoi.ai/',
                    },
                  );
                  final audioBytes = response.bodyBytes;
                  await audioPlayer.play(BytesSource(audioBytes));
                  setState(() {
                    isPlaying = true;
                  });
                }
              }
            },
            child: Padding(
              padding: EdgeInsets.all(
                  ResponsiveDesignOrientation.isLandscape ? 2.w : 8.w),
              child: GradientIcon(
                icon: isPlaying
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline,
                size: ResponsiveDesignOrientation.isLandscape ? 18.sp : 24.sp,
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
                // Redirect to SpeakerScreen
                context.go('/speaker');
              },
              child: Padding(
                padding: EdgeInsets.all(
                    ResponsiveDesignOrientation.isLandscape ? 2.w : 8.w),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius:
                          ResponsiveDesignOrientation.isLandscape ? 22.r : 14.r,
                      backgroundImage: CachedNetworkImageProvider(speakerImagePath!, headers: {
                          'Referer': 'https://voice.botnoi.ai/',
                        }),
                    ),
                    SizedBox(
                        width: ResponsiveDesignOrientation.isLandscape
                            ? 6.w
                            : 8.w),
                    Text(
                      speakerName!,
                      style: GoogleFonts.prompt(
                        fontSize: ResponsiveDesignOrientation.isLandscape
                            ? 8.sp
                            : 14.sp,
                        fontWeight: FontWeight.w600,
                        color: kDark,
                      ),
                    ),
                    SizedBox(
                        width: ResponsiveDesignOrientation.isLandscape
                            ? 6.w
                            : 8.w),
                    Container(
                      width:
                          ResponsiveDesignOrientation.isLandscape ? 2.w : 4.w,
                      height:
                          ResponsiveDesignOrientation.isLandscape ? 2.w : 4.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    SizedBox(
                        width: ResponsiveDesignOrientation.isLandscape
                            ? 6.w
                            : 8.w),
                    CircleAvatar(
                      radius:
                          ResponsiveDesignOrientation.isLandscape ? 16.r : 7.r,
                      backgroundImage: AssetImage(nationalFlagPath!),
                    ),
                    SizedBox(
                        width: ResponsiveDesignOrientation.isLandscape
                            ? 4.w
                            : 8.w),
                    Text(
                      nationalFlagName!,
                      style: GoogleFonts.prompt(
                        fontSize: ResponsiveDesignOrientation.isLandscape
                            ? 7.sp
                            : 10.sp,
                        color: kDark,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'appbar_bottom.change'.tr(),
                      style: GoogleFonts.prompt(
                        fontSize: ResponsiveDesignOrientation.isLandscape
                            ? 8.sp
                            : 14.sp,
                        fontWeight: FontWeight.w600,
                        color: kDark,
                      ),
                    ),
                    SizedBox(
                        width: ResponsiveDesignOrientation.isLandscape
                            ? 10.w
                            : 16.w),
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
