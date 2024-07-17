/*

import 'dart:ui';
import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/Database/data.dart';
import 'package:botnoivoice/filters/advert.dart';
import 'package:botnoivoice/filters/all.dart';
import 'package:botnoivoice/filters/favorite.dart';
// import 'package:botnoivoice/filters/favorite.dart';
import 'package:botnoivoice/filters/language.dart';
import 'package:botnoivoice/filters/new.dart';
import 'package:botnoivoice/filters/podcast.dart';
import 'package:botnoivoice/filters/recomman.dart';
import 'package:botnoivoice/filters/sex.dart';
import 'package:botnoivoice/filters/voice.dart';
// import 'package:botnoivoice/model/favoritemodel.dart';
import 'package:botnoivoice/widgets/favoriteVoice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
// import 'package:provider/provider.dart';
// import 'package:botnoivoice/widgets/story_viewer.dart';



class CategoryVoice extends StatefulWidget {
  const CategoryVoice({
    super.key,
    // required this.onToggleFavorite,
  });
  // final void Function(Data data) onToggleFavorite;

  @override
  _CategoryVoiceState createState() => _CategoryVoiceState();
}

class _CategoryVoiceState extends State<CategoryVoice> {
  bool ishover = false;
  @override
  Widget build(BuildContext context) {
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;

    // var screenSize = MediaQuery.of(context).size;
    final data = AppDataBase.data;
    // final filterModel = Provider.of<FilterModel>(context);

    String speakerId = data[0].speakerId;
    String language = data[0].language;
    List<String> availableLanguage = data[0].availableLanguage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: screenSizeheight * 0.05.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                color: const Color(0xFFFFFFFF),
                width: 600.w,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w, left: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // const Language(),
                      // const Sex(),
                      // const Recommand(),
                      // InkWell(
                      //   onTap: () {
                      //     setState(() {
                      //       ishover = !ishover;
                      //     });
                      //   },
                      //   child: Favorite(ishover: ishover),
                      // ),
                      // const All(),
                      // const New(),
                      // const Voice(),
                      // const Advert(),
                      // const Podcast(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          // color: Colors.amber,
          color: const Color(0xFFFFFFFF),
          height: 148.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ishover
                  ? FavoriteVoice(
                      screenSizeheight: screenSizeheight,
                      screenSizewidth: screenSizewidth,
                      data: data,
                    )
                  : VoiceWidget(
                      screenSizeheight: screenSizeheight,
                      screenSizewidth: screenSizewidth,
                      data: data,
                      speakerId: speakerId,
                      language: language,
                      availableLanguage: availableLanguage,
                    )
            ],
          ),
        ),
      ],
    );
  }
}

class VoiceWidget extends StatefulWidget {
  const VoiceWidget({
    super.key,
    required this.screenSizeheight,
    required this.screenSizewidth,
    required this.data,
    required this.speakerId,
    required this.language,
    required this.availableLanguage,
    // required this.onToggleFavorite,
  });

  final double screenSizeheight;
  final double screenSizewidth;
  final List<Data> data;
  // final void Function(Data data) onToggleFavorite;

  // Generate Audio
  final String speakerId;
  // String? token;
  final String language;
  final List<String> availableLanguage;

  @override
  State<VoiceWidget> createState() => _VoiceWidgetState();
}

class _VoiceWidgetState extends State<VoiceWidget> {
  // Generate Audio
  late String speakerId;
  // String? token;
  late String language;
  late List<String> availableLanguage;

  // Player Audio
  bool isAudioPlaying = false;
  AudioPlayer audioPlayer = AudioPlayer();
  List<Data> data = [];

  Set<int> selectedIndex2 = <int>{};
  Set<int> selectedIndex = <int>{};
  // final List<Data> _favoriteVoice = [];

  // void _toggleVoiceFavorite(Data data) {
  //   final isExist = _favoriteVoice.contains(data);

  //   if (isExist) {
  //     _favoriteVoice.remove(data);
  //   } else {
  //     _favoriteVoice.add(data);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140.h,
      width: widget.screenSizewidth * 0.95.w,
      child: GridView.builder(
        itemCount: widget.data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisExtent: 150,
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final data = widget.data[index];

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: GestureDetector(
                  onTap: () async {

                    print("\n### VoiceWidget -> Line 197 is working !!! ### \n");

                    String audioURL = data.audio;
                    Future<void> playAudio() async {
                      if (audioURL.isNotEmpty) {
                        if (isAudioPlaying) {
                          // ถ้ามีการเล่นเสียงอยู่ ให้หยุดก่อน
                          await audioPlayer.stop();
                        }
                        await audioPlayer.play(UrlSource(audioURL));
                        setState(() {
                          isAudioPlaying = true;
                        });

                        audioPlayer.onPlayerComplete.listen((event) {
                          print("#### Play Audio's Complete");
                          setState(() {
                            isAudioPlaying = false;
                          });
                        });
                      } else {
                        setState(() {
                          isAudioPlaying = false;
                        });
                        print("Audio URL is empty, cannot play audio");
                      }
                    }

                    await playAudio();

                    // get data in value to the generate audio function
                    speakerId = data.speakerId;
                    language = data.language.toLowerCase();
                    availableLanguage = data.availableLanguage.toList();

                    print('\nspeakerId -> Widget(DataVoice): $speakerId');
                    print(
                        'squareImage -> Widget(DataVoice): ${data.squareImage}');
                    print('thaiName -> Widget(DataVoice): ${data.thaiName}');
                    print('engName -> Widget(DataVoice): ${data.engName}');
                    print(
                        'language -> Widget(DataVoice): ${data.language.toLowerCase()}');
                    print(
                        'availableLanguage -> Widget(DataVoice): ${data.availableLanguage.toList()} \n');

                    setState(() {
                      if (selectedIndex.contains(index)) {
                        selectedIndex.remove(index);
                      } else {
                        selectedIndex.add(index);
                      }
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        width: 100.w,
                        height: 113.h,
                        decoration: BoxDecoration(
                          border: GradientBoxBorder(
                            width: 3.w,
                            gradient: selectedIndex.contains(index)
                                ? const LinearGradient(colors: [
                                    Color(0xFF9A96F5),
                                    Color(0xFF00E0FF)
                                  ])
                                : const LinearGradient(colors: [
                                    Colors.transparent,
                                    Colors.transparent
                                  ]),
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                          image: DecorationImage(
                            image: NetworkImage(
                              widget.data[index].squareImage,
                            ),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: selectedIndex.contains(index)
                                  ? Colors.blue.withOpacity(0.5)
                                  : Colors.transparent,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      right: 5.w, top: 5.w, left: 5.w),
                                  child: selectedIndex.contains(index)
                                      ? Container(
                                          width: 31.w,
                                          height: 17.h,
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF9A96F5),
                                                Color(0xFF00E0FF)
                                              ],
                                            ),
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                          ),
                                          child: Center(
                                            child: Text('เลือก',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontStyle:
                                                      GoogleFonts.prompt()
                                                          .fontStyle,
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold,
                                                )),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.check,
                                          color: Colors.transparent,
                                        ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(right: 5.w, top: 5.w),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (selectedIndex2.contains(index)) {
                                          selectedIndex2.remove(index);
                                        } else {
                                          // widget.onToggleFavorite(widget.data[index]);
                                          selectedIndex2.add(index);
                                        }
                                      });
                                    },
                                    child: selectedIndex2.contains(index)
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
                                              color: Colors.white,
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
                            const Spacer(), // Add Spacer to push the content below to the bottom
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                selectedIndex.contains(index)
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
                                          width: 16.h,
                                          height: 16.w,
                                          color: Colors.white,
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        'assets/logo/Vector (1).svg',
                                        width: 16.h,
                                        height: 16.w,
                                      ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Text(
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: null,
                                  widget.data[index].thaiName,
                                  style: GoogleFonts.prompt(
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      // Text(
                      //   softWrap: true,
                      //   overflow: TextOverflow.ellipsis,
                      //   maxLines: null,
                      //   widget.data[index].name,
                      //   style: GoogleFonts.prompt(
                      //     fontSize: 12.sp,
                      //     color: Colors.black,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

*/