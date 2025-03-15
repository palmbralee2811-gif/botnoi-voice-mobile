import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/data/model/speaker_model/gender_filter.dart';
import 'package:botnoivoice/data/model/speaker_model/language_filter.dart';
import 'package:botnoivoice/data/entities/speaker_entity.dart';
import 'package:botnoivoice/data/model/speaker_model/speaker_model.dart';
import 'package:botnoivoice/ui/style/style.dart';
import 'package:botnoivoice/ui/screen/main/speaker/appbar_speaker_screen.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/ui/screen/main/speaker/speaker_filter_button.dart';
import 'package:botnoivoice/ui/screen/main/speaker/favorite_button.dart';
import 'package:botnoivoice/ui/screen/main/home_speaker_data_management.dart';
import 'package:botnoivoice/ui/widget/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class SpeakerScreen extends StatefulWidget {
  const SpeakerScreen({super.key});

  @override
  State<SpeakerScreen> createState() => _SpeakerScreenState();
}

class _SpeakerScreenState extends State<SpeakerScreen> {
  final Logger _logger = Logger();

  AudioPlayer audioPlayer = AudioPlayer();

  String? speakerId;
  String? language;
  String? gender;
  Set<int> selectedIndex = <int>{};

  List<SpeakerEntity>? speakerItem;
  List<String> selectedIndexFavorites = [];

  String selectedLanguage = tr('default_language_filter_name');
  String selectedLanguageImage = tr('default_language_filter_image_path');
  String selectedGender = 'male_female'.tr();
  String selectedGenderImage = 'assets/images/gender/all.svg';

  Set<String> selectedCategories = {};
  Set<String> selectedStyles = {};
  String selectedVoiceStyle = '';
  String selectedStyle = '';

  bool ishover = false;
  bool isExpanded = false;
  bool changeIcon = false;

  @override
  void initState() {
    super.initState();
    language = tr('default_language_filter_code');
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
        SizedBox(height: ResponsiveDesignOrientation.isLandscape ? 25.h : 20.h),
        buildBottomNavbarButton(),
        SizedBox(height: ResponsiveDesignOrientation.isLandscape ? 25.h : 40.h),
      ],
    );
  }

  Widget buildFilterContainer(BuildContext context) {
    return Container(
      height: ResponsiveDesignOrientation.isLandscape ? 150.h : 110.h,
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildFilterRow1(context),
          SizedBox(
              height: ResponsiveDesignOrientation.isLandscape ? 20.h : 10.h),
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

  //TODO: Fix Error เวลากดปุ่มแล้ว แสดงภาษาทั้งหมด สิ่งที่ต้องการคือ แสดงเฉพาะ ภาษาที่กดถูกใจเท่านั้น
  Widget buildFavoriteButton() {
    return InkWell(
      onTap: () {
        setState(() {
          ishover = !ishover;
        });
      },
      child: SizedBox(
        height: ResponsiveDesignOrientation.isLandscape ? 55.h : 35.h,
        child: FavoriteButton(ishover: ishover),
      ),
    );
  }

  Widget buildBottomNavbarButton() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: ResponsiveDesignOrientation.isLandscape ? 40.w : 20.w),
      child: SizedBox(
        height: ResponsiveDesignOrientation.isLandscape ? 70.h : 50.h,
        child: GradientTextButton(
          text: 'confirm'.tr(),
          onPressed: () {
            if (audioPlayer.state == PlayerState.playing) {
              audioPlayer.stop();
            }

            // Redirect to Home Screen
            context.go('/home');
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
                  height:
                      ResponsiveDesignOrientation.isLandscape ? 440.h : 220.h,
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
      width: ResponsiveDesignOrientation.isLandscape ? 90.w : 100.w,
      height: ResponsiveDesignOrientation.isLandscape ? 55.h : 35.h,
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
                  width: ResponsiveDesignOrientation.isLandscape ? 18.w : 28.w,
                  height: ResponsiveDesignOrientation.isLandscape ? 48.h : 28.h,
                )
              : Image.asset(
                  imagePath,
                  width: ResponsiveDesignOrientation.isLandscape ? 18.w : 28.w,
                  height: ResponsiveDesignOrientation.isLandscape ? 48.h : 28.h,
                ),
          SizedBox(width: ResponsiveDesignOrientation.isLandscape ? 5.w : 6.w),
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                text,
                style: GoogleFonts.prompt(
                    fontSize: ResponsiveDesignOrientation.isLandscape
                        ? 12.sp
                        : 16.sp),
              ),
            ),
          ),
          Icon(
            isExpanded
                ? Icons.keyboard_arrow_up_sharp
                : Icons.keyboard_arrow_down_sharp,
            size: ResponsiveDesignOrientation.isLandscape ? 30 : 20,
            color: kDark,
          ),
        ],
      ),
    );
  }

  Widget buildLanguageButton(BuildContext context, StateSetter setState) {
    return Padding(
      padding:
          EdgeInsets.all(ResponsiveDesignOrientation.isLandscape ? 10.w : 12.w),
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            width: ResponsiveDesignOrientation.isLandscape ? 140.w : 280.w,
            child: Column(
              children: [
                buildModalHeader(context, 'language'.tr()),
                SizedBox(
                    height:
                        ResponsiveDesignOrientation.isLandscape ? 10.h : 15.h),
                ...buildLanguageFilters(context, setState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> updateLanguageId(String langCode) {
    List<Map<String, dynamic>> updatedLanguages = List.from(languageFilter);

    for (var lang in updatedLanguages) {
      if (lang['code']!.toLowerCase() == langCode.toLowerCase()) {
        lang['id'] = 1; // กำหนด id เป็น 1 ถ้า code ตรงกับ langCode
      } else {
        lang['id'] = updatedLanguages.indexOf(lang) +
            2; // ให้ id เริ่มจาก 2 สำหรับภาษาอื่น
      }
    }

    // จัดเรียงตาม id
    updatedLanguages.sort((a, b) => a['id'].compareTo(b['id']));

    return updatedLanguages;
  }

  List<Widget> buildLanguageFilters(
      BuildContext context, StateSetter setState) {
    String languageCode = Localizations.localeOf(context).languageCode;

    List<Map<String, dynamic>> sortedLanguages = updateLanguageId(languageCode);

    return sortedLanguages.map((lang) {
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
      padding:
          EdgeInsets.all(ResponsiveDesignOrientation.isLandscape ? 10.w : 20.w),
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            width: ResponsiveDesignOrientation.isLandscape ? 140.w : 280.w,
            child: Column(
              children: [
                buildModalHeader(context, 'gender'.tr()),
                SizedBox(
                    height:
                        ResponsiveDesignOrientation.isLandscape ? 10.h : 15.h),
                ...buildGenderFilters(context, setState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> buildGenderFilters(BuildContext context, StateSetter setState) {
    return genderFilter.map((gender) {
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

        // Close Language Filter Dialog
        context.pop();
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

        // Close Gender Filter Dialog
        context.pop();
      },
      child: buildFilterOption(context, imagePath, displayText),
    );
  }

  Widget buildFilterOption(
      BuildContext context, String imagePath, String text) {
    return Container(
      padding: EdgeInsets.only(
          left: ResponsiveDesignOrientation.isLandscape ? 0.w : 10.w),
      height: ResponsiveDesignOrientation.isLandscape ? 82.h : 42.h,
      width: 320.w,
      color: kWhite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          imagePath.endsWith('.svg')
              ? SvgPicture.asset(
                  imagePath,
                  width: ResponsiveDesignOrientation.isLandscape ? 13.w : 23.w,
                  height: ResponsiveDesignOrientation.isLandscape ? 43.h : 23.h,
                )
              : Image.asset(
                  imagePath,
                  width: ResponsiveDesignOrientation.isLandscape ? 13.w : 23.w,
                  height: ResponsiveDesignOrientation.isLandscape ? 43.h : 23.h,
                ),
          SizedBox(
              width: ResponsiveDesignOrientation.isLandscape ? 10.w : 20.w),
          Text(
            text,
            style: GoogleFonts.prompt(
              fontSize: ResponsiveDesignOrientation.isLandscape ? 10.sp : 14.sp,
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
            fontSize: ResponsiveDesignOrientation.isLandscape ? 12.sp : 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        InkWell(
          onTap: () {
            // Close Modal Header Dialog
            context.pop();
          },
          child: Icon(
            Icons.close,
            size: ResponsiveDesignOrientation.isLandscape ? 16.sp : 24.sp,
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
      _logger.w("No speakers match all filters.");
      return [];
    }

    _logger.i("Total speakers after filtering: ${filteredSpeakers.length}");
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

              String languageCode =
                  Localizations.localeOf(context).languageCode;
              String speakerName;

              switch (languageCode) {
                case 'th':
                  speakerName = speakerItem.thaiName;
                  break;
                case 'en':
                  speakerName = speakerItem.engName;
                  break;
                case 'id':
                  speakerName = speakerItem.engName;
                  break;
                default:
                  speakerName = speakerItem.engName;
                  break;
              }

              Provider.of<HomeSpeakerDataManagement>(context, listen: false)
                  .setLanguage(speakerItem.language.toLowerCase());
              Provider.of<HomeSpeakerDataManagement>(context, listen: false)
                  .setSpeakerId(speakerItem.speakerId);
              Provider.of<HomeSpeakerDataManagement>(context, listen: false)
                  .setSpeakerName(speakerName);
              Provider.of<HomeSpeakerDataManagement>(context, listen: false)
                  .setSpeakerAudio(speakerItem.audio);
              Provider.of<HomeSpeakerDataManagement>(context, listen: false)
                  .setSpeakerImagePath(speakerItem.squareImage);
              Provider.of<HomeSpeakerDataManagement>(context, listen: false)
                  .setNationalFlagPath(selectedLanguageImage);
              Provider.of<HomeSpeakerDataManagement>(context, listen: false)
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
                  width:
                      ResponsiveDesignOrientation.isLandscape ? 120.w : 100.w,
                  height:
                      ResponsiveDesignOrientation.isLandscape ? 313.h : 113.h,
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
                                      height: ResponsiveDesignOrientation
                                              .isLandscape
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
                                            ResponsiveDesignOrientation
                                                    .isLandscape
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
                                                  ResponsiveDesignOrientation
                                                          .isLandscape
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
                                          width: ResponsiveDesignOrientation
                                                  .isLandscape
                                              ? 50.w
                                              : 20.w,
                                          height: ResponsiveDesignOrientation
                                                  .isLandscape
                                              ? 50.h
                                              : 20.h,
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        'assets/images/icon/heart-off.svg',
                                        width: ResponsiveDesignOrientation
                                                .isLandscape
                                            ? 50.w
                                            : 20.w,
                                        height: ResponsiveDesignOrientation
                                                .isLandscape
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
                                      width: ResponsiveDesignOrientation
                                              .isLandscape
                                          ? 12.h
                                          : 16.h,
                                      height: ResponsiveDesignOrientation
                                              .isLandscape
                                          ? 12.w
                                          : 16.w,
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'assets/images/icon/play-off.svg',
                                    width:
                                        ResponsiveDesignOrientation.isLandscape
                                            ? 12.h
                                            : 16.h,
                                    height:
                                        ResponsiveDesignOrientation.isLandscape
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
