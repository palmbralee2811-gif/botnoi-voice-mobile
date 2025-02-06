import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/data/models/speaker_model/genders_list.dart';
import 'package:botnoivoice/data/models/speaker_model/languages_list.dart';
import 'package:botnoivoice/data/entities/speaker_entity.dart';
import 'package:botnoivoice/data/models/speaker_model/speaker_model.dart';
import 'package:botnoivoice/presentation/constants/styles.dart';
import 'package:botnoivoice/presentation/screens/appbar/appbar_speaker_screen.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:botnoivoice/presentation/screens/speaker/filter_widgets/speaker_filter_button.dart';
import 'package:botnoivoice/presentation/widgets/filter/favorite.dart';
import 'package:botnoivoice/data/repositories/speaker_repository_impl.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class SpeakerScreen extends StatefulWidget {
  const SpeakerScreen({super.key, required String speakerName});

  @override
  State<SpeakerScreen> createState() => _SpeakerScreenState();
}

class _SpeakerScreenState extends State<SpeakerScreen> {
  final Logger logger = Logger();
  bool ishover = false;
  String? speakerId;
  String? language;
  String? gender;
  Set<int> selectedIndex = <int>{};
  AudioPlayer audioPlayer = AudioPlayer();
  List<SpeakerEntity>? speakerItem;
  List<String> selectedIndexFavorites = [];
  String selectedLanguage = 'thai'.tr();
  String selectedLanguageImage = 'assets/images/national_flag/thai.png';
  bool isExpanded = false;
  String selectedGender = 'mw'.tr();
  String selectedGenderImage = 'assets/images/gender/all.svg';
  bool changeIcon = false;
  Set<String> selectedCategories = {};
  Set<String> selectedStyles = {};
  String selectedVoiceStyle = '';
  String selectedStyle = '';

  @override
  void initState() {
    super.initState();
    language = 'TH';
    gender = '';
  }

  List<String> _getVoiceStyles(BuildContext context) {
    Set<String> voiceStylesSet = {};
    String languageCode = Localizations.localeOf(context).languageCode;

    for (var speaker in SpeakerModel.speakerItem) {
      if (selectedCategories.isNotEmpty) {
        if (languageCode == 'th') {
          if (speaker.speechStyle
              .any((category) => selectedCategories.contains(category))) {
            voiceStylesSet.addAll(speaker.voiceStyle);
          }
        } else {
          if (speaker.engSpeechStyle
              .any((category) => selectedCategories.contains(category))) {
            voiceStylesSet.addAll(speaker.engVoiceStyle);
          }
        }
      } else {
        if (languageCode == 'th') {
          voiceStylesSet.addAll(speaker.voiceStyle);
        } else {
          voiceStylesSet.addAll(speaker.engVoiceStyle);
        }
      }
    }

    return voiceStylesSet.toList();
  }

  List<String> _getSpeechStyles(BuildContext context) {
    Set<String> speechStylesSet = {};
    String languageCode = Localizations.localeOf(context).languageCode;

    for (var speaker in SpeakerModel.speakerItem) {
      if (selectedStyles.isNotEmpty) {
        if (languageCode == 'th') {
          if (speaker.voiceStyle
              .any((style) => selectedStyles.contains(style))) {
            speechStylesSet.addAll(speaker.speechStyle);
          }
        } else {
          if (speaker.engVoiceStyle
              .any((style) => selectedStyles.contains(style))) {
            speechStylesSet.addAll(speaker.engSpeechStyle);
          }
        }
      } else {
        if (languageCode == 'th') {
          speechStylesSet.addAll(speaker.speechStyle);
        } else {
          speechStylesSet.addAll(speaker.engSpeechStyle);
        }
      }
    }

    return speechStylesSet.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarSpeakerScreen(),
      body: buildFilterNavbar(context),
    );
  }

  Widget buildFilterNavbar(BuildContext context) {
    return Column(
      children: [
        buildFilterContainer(context),
        Expanded(
          child: Container(
            color: kWhite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ishover
                      ? buildFavoriteFilter(context)
                      : buildMultipleSpeaker(context),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: OrientationHelper.isLandscape ? 25.h : 20.h),
        buildBottomNavbarButton(),
        SizedBox(height: OrientationHelper.isLandscape ? 25.h : 40.h),
      ],
    );
  }

  Widget buildFilterContainer(BuildContext context) {
    return Container(
      height: OrientationHelper.isLandscape ? 150.h : 110.h,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFilterRow1(context),
          SizedBox(height: OrientationHelper.isLandscape ? 20.h : 10.h),
          buildFilterRow2(context),
        ],
      ),
    );
  }

  Widget buildFilterRow1(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildLanguageButtonTrigger(context),
        SizedBox(width: 10.w),
        buildGenderButtonTrigger(context),
        SizedBox(width: 10.w),
        Expanded(child: buildFavoriteButton()),
      ],
    );
  }

  Widget buildFilterRow2(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 4,
          child: buildFilterButton(
            context,
            title: selectedStyles.isEmpty
                ? 'style'.tr()
                : 'style_plural'
                    .tr(namedArgs: {'count': selectedStyles.length.toString()}),
            items: _getVoiceStyles(context),
            selectedItems: selectedStyles,
            onConfirm: (newSelected) {
              setState(() {
                selectedStyles = newSelected;
                selectedCategories = selectedCategories
                    .where((category) =>
                        _getSpeechStyles(context).contains(category))
                    .toSet();
              });
            },
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          flex: 4,
          child: buildFilterButton(
            context,
            title: selectedCategories.isEmpty
                ? 'category'.tr()
                : 'category_plural'.tr(
                    namedArgs: {'count': selectedCategories.length.toString()}),
            items: _getSpeechStyles(context),
            selectedItems: selectedCategories,
            onConfirm: (newSelected) {
              setState(() {
                selectedCategories = newSelected;
                selectedStyles = selectedStyles
                    .where((style) => _getVoiceStyles(context).contains(style))
                    .toSet();
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildFavoriteButton() {
    return InkWell(
      onTap: () {
        setState(() {
          ishover = !ishover;
        });
      },
      child: SizedBox(
        height: OrientationHelper.isLandscape ? 55.h : 35.h,
        child: Favorite(ishover: ishover),
      ),
    );
  }

  Widget buildBottomNavbarButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: OrientationHelper.isLandscape ? 40.w : 20.w),
      child: SizedBox(
        height: OrientationHelper.isLandscape ? 70.h : 50.h,
        child: GradientTextButton(
          text: 'confirm'.tr(),
          onPressed: () {
            if (audioPlayer.state == PlayerState.playing) {
              audioPlayer.stop();
            }
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  Widget buildLanguageButtonTrigger(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = true;
        });
        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SizedBox(
                  child: SingleChildScrollView(
                    child: buildLanguageButton(context, setState),
                  ),
                );
              },
            );
          },
        ).whenComplete(() {
          setState(() {
            isExpanded = false;
          });
        });
      },
      child: buildButtonContainer(
        context,
        selectedLanguageImage,
        selectedLanguage,
        isExpanded,
      ),
    );
  }

  Widget buildGenderButtonTrigger(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          changeIcon = !changeIcon;
        });
        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
                return SizedBox(
                  height: OrientationHelper.isLandscape ? 440.h : 220.h,
                  child: SingleChildScrollView(
                      child: buildGenderButton(context, setModalState)),
                );
              },
            );
          },
        ).whenComplete(() {
          setState(() {
            changeIcon = false;
          });
        });
      },
      child: buildButtonContainer(
        context,
        selectedGenderImage,
        selectedGender,
        changeIcon,
      ),
    );
  }

  Widget buildButtonContainer(
      BuildContext context, String imagePath, String text, bool isExpanded) {
    return Container(
      width: OrientationHelper.isLandscape ? 90.w : 100.w,
      height: OrientationHelper.isLandscape ? 55.h : 35.h,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(color: const Color(0xFFE2E3E9), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imagePath.endsWith('.svg')
              ? SvgPicture.asset(
                  imagePath,
                  width: OrientationHelper.isLandscape ? 18.w : 28.w,
                  height: OrientationHelper.isLandscape ? 48.h : 28.h,
                )
              : Image.asset(
                  imagePath,
                  width: OrientationHelper.isLandscape ? 18.w : 28.w,
                  height: OrientationHelper.isLandscape ? 48.h : 28.h,
                ),
          SizedBox(width: OrientationHelper.isLandscape ? 5.w : 6.w),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                style: GoogleFonts.prompt(
                    fontSize: OrientationHelper.isLandscape ? 12.sp : 16.sp),
              ),
            ),
          ),
          Icon(
            isExpanded
                ? Icons.keyboard_arrow_up_sharp
                : Icons.keyboard_arrow_down_sharp,
            size: OrientationHelper.isLandscape ? 30 : 20,
            color: kDark,
          ),
        ],
      ),
    );
  }

  Widget buildLanguageButton(BuildContext context, StateSetter setState) {
    return Padding(
      padding: EdgeInsets.all(OrientationHelper.isLandscape ? 10.w : 12.w),
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            width: OrientationHelper.isLandscape ? 140.w : 280.w,
            child: Column(
              children: [
                buildModalHeader(context, 'language'.tr()),
                SizedBox(height: OrientationHelper.isLandscape ? 10.h : 15.h),
                ...buildLanguageFilters(context, setState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildLanguageFilters(
      BuildContext context, StateSetter setState) {
    return languages.map((lang) {
      return _buildLanguageFilter(
        lang['thaiName']!,
        lang['englishName']!,
        lang['indonesianName']!,
        lang['image']!,
        lang['code']!,
        context,
        setState,
      );
    }).toList();
  }

  Widget buildGenderButton(BuildContext context, StateSetter setState) {
    return Padding(
      padding: EdgeInsets.all(OrientationHelper.isLandscape ? 10.w : 20.w),
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            width: OrientationHelper.isLandscape ? 140.w : 280.w,
            child: Column(
              children: [
                buildModalHeader(context, 'gender'.tr()),
                SizedBox(height: OrientationHelper.isLandscape ? 10.h : 15.h),
                ...buildGenderFilters(context, setState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildGenderFilters(BuildContext context, StateSetter setState) {
    return genders.map((gender) {
      return _buildGenderFilter(
        gender['thaiName']!,
        gender['englishName']!,
        gender['indonesianName']!,
        gender['image']!,
        gender['code']!,
        context,
        setState,
      );
    }).toList();
  }

  Widget _buildLanguageFilter(
    String thaiName,
    String englishName,
    String indonesianName,
    String imagePath,
    String lang,
    BuildContext context,
    StateSetter setState,
  ) {
    String languageCode = Localizations.localeOf(context).languageCode;
    languageCode = languageCode.isNotEmpty ? languageCode : 'en';

    Map<String, String> languageMap = {
      'th': thaiName,
      'en': englishName,
      'id': indonesianName,
    };

    String displayText = languageMap[languageCode]?.isNotEmpty == true
        ? languageMap[languageCode]!
        : englishName;

    return InkWell(
      onTap: () {
        setState(() {
          language = lang;
          selectedLanguage = displayText;
          selectedLanguageImage = imagePath;
        });
        Navigator.pop(context);
      },
      child: buildFilterOption(context, imagePath, displayText),
    );
  }

  Widget _buildGenderFilter(
    String thaiName,
    String englishName,
    String indonesianName,
    String imagePath,
    String gen,
    BuildContext context,
    StateSetter setState,
  ) {
    String languageCode = Localizations.localeOf(context).languageCode;
    languageCode = languageCode.isNotEmpty ? languageCode : 'en';

    Map<String, String> languageMap = {
      'th': thaiName,
      'en': englishName,
      'id': indonesianName,
    };

    String displayText = languageMap[languageCode]?.isNotEmpty == true
        ? languageMap[languageCode]!
        : englishName;

    return InkWell(
      onTap: () {
        setState(() {
          selectedGender = displayText;
          selectedGenderImage = imagePath;
          gender = gen;
        });
        Navigator.pop(context);
      },
      child: buildFilterOption(context, imagePath, displayText),
    );
  }

  Widget buildFilterOption(
      BuildContext context, String imagePath, String text) {
    return Container(
      padding:
          EdgeInsets.only(left: OrientationHelper.isLandscape ? 0.w : 10.w),
      height: OrientationHelper.isLandscape ? 82.h : 42.h,
      width: 320.w,
      color: kWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          imagePath.endsWith('.svg')
              ? SvgPicture.asset(
                  imagePath,
                  width: OrientationHelper.isLandscape ? 13.w : 23.w,
                  height: OrientationHelper.isLandscape ? 43.h : 23.h,
                )
              : Image.asset(
                  imagePath,
                  width: OrientationHelper.isLandscape ? 13.w : 23.w,
                  height: OrientationHelper.isLandscape ? 43.h : 23.h,
                ),
          SizedBox(width: OrientationHelper.isLandscape ? 10.w : 20.w),
          Text(
            text,
            style: GoogleFonts.prompt(
              fontSize: OrientationHelper.isLandscape ? 10.sp : 14.sp,
              fontWeight: (selectedLanguage == text || selectedGender == text)
                  ? FontWeight.w600
                  : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildModalHeader(BuildContext context, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.prompt(
            fontSize: OrientationHelper.isLandscape ? 12.sp : 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            size: OrientationHelper.isLandscape ? 16.sp : 24.sp,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget buildMultipleSpeaker(BuildContext context) {
    final filteredItems = _filterSpeakers();

    if (filteredItems.isEmpty) {
      return Center(
        child: Text(
          'ไม่มีผู้พูดที่ตรงกับเงื่อนไข',
          style: GoogleFonts.prompt(fontSize: 16.sp, color: Colors.black),
        ),
      );
    }

    return SingleChildScrollView(
      child: SizedBox(
        height: 420.h,
        width: 320.w,
        child: GridView.builder(
          itemCount: filteredItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 0,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            final data = filteredItems[index];
            return buildSingleSpeaker(data, index);
          },
        ),
      ),
    );
  }

  List<SpeakerEntity> _filterSpeakers() {
    List<SpeakerEntity> filteredSpeakers = [];
    String languageCode = Localizations.localeOf(context).languageCode;

    filteredSpeakers = SpeakerModel.speakerItem.where((item) {
      return item.language == language;
    }).toList();

    if (filteredSpeakers.isEmpty) {
      filteredSpeakers = SpeakerModel.speakerItem.where((item) {
        return item.availableLanguage.contains(language?.toLowerCase()) &&
            item.language != language;
      }).toList();
    }

    if (gender != null && gender!.isNotEmpty) {
      filteredSpeakers =
          filteredSpeakers.where((item) => item.gender == gender).toList();
    }

    if (selectedStyles.isNotEmpty) {
      filteredSpeakers = filteredSpeakers.where((item) {
        if (languageCode == 'th') {
          return item.voiceStyle.isNotEmpty &&
              item.voiceStyle.any((style) => selectedStyles.contains(style));
        } else {
          return item.engVoiceStyle.isNotEmpty &&
              item.engVoiceStyle.any((style) => selectedStyles.contains(style));
        }
      }).toList();
    }

    if (selectedCategories.isNotEmpty) {
      filteredSpeakers = filteredSpeakers.where((item) {
        if (languageCode == 'th') {
          return item.speechStyle.isNotEmpty &&
              item.speechStyle
                  .any((category) => selectedCategories.contains(category));
        } else {
          return item.engSpeechStyle.isNotEmpty &&
              item.engSpeechStyle
                  .any((category) => selectedCategories.contains(category));
        }
      }).toList();
    }

    if (filteredSpeakers.isEmpty) {
      logger.w("No speakers match all filters.");
      return [];
    }

    logger.i("Total speakers after filtering: ${filteredSpeakers.length}");
    return filteredSpeakers;
  }

  Widget buildSingleSpeaker(SpeakerEntity speakerItem, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 7.h),
          child: GestureDetector(
            onTap: () async {
              String audioURL = speakerItem.audio;
              Future<void> playAudio() async {
                if (audioURL.isNotEmpty) {
                  if (audioPlayer.state == PlayerState.playing) {
                    await audioPlayer.stop();
                  }
                  await audioPlayer.play(UrlSource(audioURL));
                }
              }

              await playAudio();

              final speakerProvider =
                  Provider.of<SpeakerRepositoryImpl>(context, listen: false);
              speakerProvider.setSpeaker(speakerItem);

              Provider.of<SpeakerRepositoryImpl>(context, listen: false)
                  .setLanguage(speakerItem.language.toLowerCase());
              Provider.of<SpeakerRepositoryImpl>(context, listen: false)
                  .setSpeakerId(speakerItem.speakerId);
              Provider.of<SpeakerRepositoryImpl>(context, listen: false)
                  .setSpeakerName(speakerItem.thaiName);
              Provider.of<SpeakerRepositoryImpl>(context, listen: false)
                  .setSpeakerAudio(speakerItem.audio);
              Provider.of<SpeakerRepositoryImpl>(context, listen: false)
                  .setSpeakerImagePath(speakerItem.squareImage);
              Provider.of<SpeakerRepositoryImpl>(context, listen: false)
                  .setNationalFlagPath(selectedLanguageImage);
              Provider.of<SpeakerRepositoryImpl>(context, listen: false)
                  .setNationalFlagName(selectedLanguage);

              setState(() {
                if (selectedIndex.contains(index)) {
                  if (audioPlayer.state == PlayerState.playing) {
                    audioPlayer.stop();
                  }
                  selectedIndex.remove(index);
                } else {
                  selectedIndex.clear();
                  selectedIndex.add(index);
                }
              });
            },
            child: Column(
              children: [
                Container(
                  width: OrientationHelper.isLandscape ? 120.w : 100.w,
                  height: OrientationHelper.isLandscape ? 313.h : 113.h,
                  decoration: BoxDecoration(
                    border: GradientBoxBorder(
                      width: 3.w,
                      gradient: selectedIndex.contains(index)
                          ? const LinearGradient(
                              colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
                            )
                          : LinearGradient(
                              colors: [
                                Colors.black.withOpacity(0.9),
                                Colors.transparent,
                              ],
                              begin: const Alignment(1, 1),
                            ),
                    ),
                    borderRadius: BorderRadius.circular(8.r),
                    image: DecorationImage(
                      image: AssetImage(
                        speakerItem.squareImage,
                      ),
                      onError: (exception, stackTrace) => const AssetImage(
                          'assets/images/default-profile-picture.jpg'),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 1,
                        color: selectedIndex.contains(index)
                            ? const Color(0xFF9340FF).withOpacity(0.6)
                            : Colors.transparent,
                        offset: const Offset(0, 4),
                      ),
                    ],
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
                                  right: 5.w, top: 5.w, left: 5.w),
                              child: selectedIndex.contains(index)
                                  ? Container(
                                      width: 31.w,
                                      height: OrientationHelper.isLandscape
                                          ? 30.h
                                          : 17.h,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF9A96F5),
                                            Color(0xFF00E0FF)
                                          ],
                                        ),
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(
                                            OrientationHelper.isLandscape
                                                ? 16.r
                                                : 8.r),
                                      ),
                                      child: Center(
                                        child: Text('select'.tr(),
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontStyle: GoogleFonts.prompt()
                                                  .fontStyle,
                                              fontSize:
                                                  OrientationHelper.isLandscape
                                                      ? 6.sp
                                                      : 8.sp,
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
                              padding: EdgeInsets.only(right: 5.w, top: 5.w),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedIndexFavorites
                                        .contains(speakerItem.speakerId)) {
                                      selectedIndexFavorites
                                          .remove(speakerItem.speakerId);
                                    } else {
                                      selectedIndexFavorites
                                          .add(speakerItem.speakerId);
                                    }
                                  });
                                },
                                child: selectedIndexFavorites
                                        .contains(speakerItem.speakerId)
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
                                          'assets/images/icon/heart-on.svg',
                                          width: OrientationHelper.isLandscape
                                              ? 50.w
                                              : 20.w,
                                          height: OrientationHelper.isLandscape
                                              ? 50.h
                                              : 20.h,
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        'assets/images/icon/heart-off.svg',
                                        width: OrientationHelper.isLandscape
                                            ? 50.w
                                            : 20.w,
                                        height: OrientationHelper.isLandscape
                                            ? 50.h
                                            : 20.h,
                                      ),
                              ),
                            )
                          ],
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
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
                                      'assets/images/icon/play-on.svg',
                                      width: OrientationHelper.isLandscape
                                          ? 12.h
                                          : 16.h,
                                      height: OrientationHelper.isLandscape
                                          ? 12.w
                                          : 16.w,
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'assets/images/icon/play-off.svg',
                                    width: OrientationHelper.isLandscape
                                        ? 12.h
                                        : 16.h,
                                    height: OrientationHelper.isLandscape
                                        ? 12.w
                                        : 16.w,
                                  ),
                            SizedBox(
                              width: 3.w,
                            ),
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
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildFavoriteFilter(BuildContext context) {
    return SizedBox(
      height: 420.h,
      width: 320.w,
      child: GridView.builder(
        itemCount: SpeakerModel.speakerItem
            .where((item) =>
                selectedIndexFavorites.isEmpty ||
                selectedIndexFavorites.contains(item.speakerId))
            .length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 0,
          childAspectRatio: 0.8,
        ),
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final data = SpeakerModel.speakerItem
              .where((item) =>
                  selectedIndexFavorites.isEmpty ||
                  selectedIndexFavorites.contains(item.speakerId))
              .toList()[index];

          return buildSingleSpeaker(data, index);
        },
      ),
    );
  }
}
