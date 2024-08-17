import 'package:audioplayers/audioplayers.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_speaker_metadata.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/speaker_metadata_model.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/filter_section.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/voice_config_provider.dart';
import 'package:botnoi_voice_mobile/Screens/SharedWidgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';

class AllSpeakerScreen extends StatefulWidget {
  const AllSpeakerScreen({
    super.key,
  });

  @override
  State<AllSpeakerScreen> createState() => _AllSpeakerScreenState();
}

class _AllSpeakerScreenState extends State<AllSpeakerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  String get selectedGender =>
      Provider.of<VoiceConfigProvider>(context).selectedGender;
  String get selectedLanguage =>
      Provider.of<VoiceConfigProvider>(context).selectedLanguage;
  String get selectedSpeakerId =>
      Provider.of<VoiceConfigProvider>(context).selectedSpeakerId;
  double get selectedVolume =>
      Provider.of<VoiceConfigProvider>(context).selectedVolume;
  double get selectedSpeed =>
      Provider.of<VoiceConfigProvider>(context).selectedSpeed;
  List<String> get selectedVoiceStyles =>
      Provider.of<VoiceConfigProvider>(context).selectedVoiceStyles;
  List<String> get selectedSpeechStyles =>
      Provider.of<VoiceConfigProvider>(context).selectedSpeechStyles;
  List<String> get favouriteSpeakerIds =>
      Provider.of<VoiceConfigProvider>(context).favouriteSpeakerIds;
  bool get isFavouriteSelected =>
      Provider.of<VoiceConfigProvider>(context).isFavouriteSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: EdgeInsets.only(left: 89.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/logo/Frame (1).png',
                width: 30.w,
                height: 34.h,
              ),
              Icon(
                Icons.search_rounded,
                size: 24.sp,
                color: const Color(0xFF323130),
              )
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          const FilterSection(),
          const Spacer(),
          _buildSpeakerTable(context),
          GradientButton(
            text: 'ตกลง',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSpeakerTable(BuildContext context) {
    List<SpeakerMetadataModel> speakersToShow =
        List.from(embeddedSpeakerMetadata);
    if (isFavouriteSelected) {
      speakersToShow = embeddedSpeakerMetadata
          .where((speaker) => favouriteSpeakerIds.contains(speaker.speakerId))
          .toList();
    }
    if (selectedGender.isNotEmpty && selectedGender != "ช/ญ") {
      speakersToShow = speakersToShow
          .where((speaker) => speaker.gender.contains(selectedGender))
          .toList();
    }
    if (selectedVoiceStyles.isNotEmpty) {
      speakersToShow = speakersToShow
          .where(
            (speaker) => selectedVoiceStyles.contains(speaker.voiceStyle),
          )
          .toList();
    }
    if (selectedSpeechStyles.isNotEmpty) {
      speakersToShow = speakersToShow
          .where(
            (speaker) => speaker.speechStyle.any(
              (speechStyle) => selectedSpeechStyles.contains(speechStyle),
            ),
          )
          .toList();
    }
    if (selectedLanguage.isNotEmpty) {
      speakersToShow = speakersToShow
          .where(
            (speaker) => speaker.language.contains(selectedLanguage),
          )
          .toList();
    }
    return SizedBox(
      height: 127.h,
      width: 320.w,
      child: GridView.builder(
        itemCount: speakersToShow.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 81.w / 103.h,
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
        ),
        itemBuilder: (context, index) {
          return _buildSpeakerCard(
            speakersToShow[index],
          );
        },
      ),
    );
  }

  Widget _buildSpeakerCard(SpeakerMetadataModel speakerMetadata) {
    return GestureDetector(
      onTap: () async {
        if (_audioPlayer.state == PlayerState.playing) {
          await _audioPlayer.stop();
        }
        if (speakerMetadata.audio.isNotEmpty) {
          await _audioPlayer.play(UrlSource(speakerMetadata.audio));
        }
        Provider.of<VoiceConfigProvider>(context, listen: false)
            .setSpeakerId(speakerMetadata.speakerId);
      },
      child: Container(
        width: 81.w,
        height: 103.h,
        decoration: BoxDecoration(
          border: GradientBoxBorder(
            width: 3.w,
            gradient: selectedSpeakerId == speakerMetadata.speakerId
                ? const LinearGradient(
                    colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
                  )
                : LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.9),
                      Colors.transparent,
                    ],
                    begin: const Alignment(1, 1), ////change new
                  ),
          ),
          borderRadius: BorderRadius.circular(8.r),
          image: DecorationImage(
            image: NetworkImage(
              speakerMetadata.squareImage,
            ),
            fit: BoxFit.cover,
          ),
          boxShadow: selectedSpeakerId == speakerMetadata.speakerId
              ? [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 1,
                    color: const Color(0xFF9340FF).withOpacity(0.6),
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
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
                      top: 5.h,
                      left: 5.w,
                    ),
                    child: selectedSpeakerId == speakerMetadata.speakerId
                        ? Container(
                            width: 31.w,
                            height: 17.h,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Center(
                              child: Text(
                                'เลือก',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: GoogleFonts.prompt().fontStyle,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : null,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5.w, top: 5.h),
                    child: GestureDetector(
                      onTap: () {
                        Provider.of<VoiceConfigProvider>(context, listen: false)
                            .toggleFavouriteSpeaker(speakerMetadata.speakerId);
                      },
                      child: favouriteSpeakerIds
                              .contains(speakerMetadata.speakerId)
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
                                'assets/logo/heart (1).svg',
                                width: 20.w,
                                height: 20.h,
                              ),
                            )
                          : SvgPicture.asset(
                              'assets/logo/heart.svg',
                              width: 20.w,
                              height: 20.h,
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
                  selectedSpeakerId == speakerMetadata.speakerId
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
                            'assets/logo/Vector.svg',
                            width: 16.w,
                            height: 16.h,
                          ),
                        )
                      : SvgPicture.asset(
                          'assets/logo/Vector (1).svg',
                          width: 16.w,
                          height: 16.h,
                        ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      speakerMetadata.thaiName,
                      style: GoogleFonts.prompt(
                        fontSize: 10.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
