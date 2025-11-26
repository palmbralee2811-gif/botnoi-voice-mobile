import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/screen/main/speaker/entities/speaker_entity.dart';
import 'package:botnoivoice/screen/main/speaker/model/gender_filter.dart';
import 'package:botnoivoice/screen/main/speaker/model/language_filter.dart';
import 'package:botnoivoice/screen/main/speaker/model/speaker_model.dart';
import 'package:botnoivoice/screen/main/speaker/widget/appbar_speaker_screen.dart';
import 'package:botnoivoice/screen/main/speaker/widget/favorite_button.dart';
import 'package:botnoivoice/screen/main/speaker/function/load_initial_data.dart';
import 'package:botnoivoice/screen/main/speaker/function/speaker_tap_handler.dart';
import 'package:botnoivoice/screen/main/speaker/function/speaker_toggle_favorite_handler.dart';
import 'package:botnoivoice/screen/main/speaker/widget/speaker_filter_button.dart';
import 'package:botnoivoice/screen/main/speaker/widget/bottom_navbar_button.dart';
import 'package:botnoivoice/screen/main/speaker/widget/build_multiple_speaker.dart';
import 'package:botnoivoice/screen/main/speaker/widget/favorite_filter.dart';
import 'package:botnoivoice/screen/main/speaker/widget/gender_filter_widget.dart';
import 'package:botnoivoice/screen/main/speaker/widget/language_filter_widget.dart';
import 'package:botnoivoice/screen/main/speaker/widget/modal_header.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/shared/style/style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';

class SpeakerScreen extends ConsumerStatefulWidget {
  const SpeakerScreen({super.key});

  @override
  ConsumerState<SpeakerScreen> createState() => _SpeakerScreenState();
}

class _SpeakerScreenState extends ConsumerState<SpeakerScreen> {
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

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    language = tr('default_language_filter_code');
    gender = '';

    loadInitialData(
      context: context,
      ref: ref,
      logger: _logger,
      setSelectedIndexFavorites: (fetchedFavorites) {
        if (mounted) {
          setState(() {
            selectedIndexFavorites = fetchedFavorites;
          });
        }
      },
      setLoading: (isLoading) {
        if (mounted) {
          setState(() {
            _isLoading = isLoading;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
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
    return SafeArea(
      child: Scaffold(
        appBar: const AppBarSpeakerScreen(),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : buildFilterNavbar(context),
      ),
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
                  // --- ส่วนที่แก้ไข ---
                  ishover
                      ? FavoriteFilter(
                          selectedIndexFavorites: selectedIndexFavorites,
                          selectedIndex: selectedIndex,
                          currentCategories: selectedCategories,
                          currentStyles: selectedStyles,
                          currentGender: gender ?? '',
                          onSpeakerTap: (index, speakerItem) async {
                            await handleSpeakerTap(
                              context: context,
                              ref: ref,
                              index: index,
                              speakerItem: speakerItem,
                              audioPlayer: audioPlayer,
                              selectedIndex: selectedIndex,
                              setSelectedIndex: (newSelected) {
                                setState(() {
                                  selectedIndex = newSelected;
                                });
                              },
                              selectedLanguage: selectedLanguage,
                              selectedLanguageImage: selectedLanguageImage,
                            );
                          },
                          onFavoriteToggle: (speakerId) async {
                            await handleFavoriteToggle(
                              context: context,
                              ref: ref,
                              logger: _logger,
                              speakerId: speakerId,
                              selectedIndexFavorites: selectedIndexFavorites,
                              setSelectedIndexFavorites: (newFavorites) {
                                setState(() {
                                  selectedIndexFavorites = newFavorites;
                                });
                              },
                            );
                          },
                          currentLanguage: language ?? 'TH',
                        )
                      : BuildMultipleSpeaker(
                          audioPlayer: audioPlayer,
                          selectedIndex: selectedIndex,
                          selectedIndexFavorites: selectedIndexFavorites,
                          language: language,
                          gender: gender,
                          selectedCategories: selectedCategories,
                          selectedStyles: selectedStyles,
                          logger: _logger,
                          onSpeakerTap: (index, speakerItem) async {
                            await handleSpeakerTap(
                              context: context,
                              ref: ref,
                              index: index,
                              speakerItem: speakerItem,
                              audioPlayer: audioPlayer,
                              selectedIndex: selectedIndex,
                              setSelectedIndex: (newSelected) {
                                setState(() {
                                  selectedIndex = newSelected;
                                });
                              },
                              selectedLanguage: selectedLanguage,
                              selectedLanguageImage: selectedLanguageImage,
                            );
                          },
                          onFavoriteToggle: (speakerId) async {
                            await handleFavoriteToggle(
                              context: context,
                              ref: ref,
                              logger: _logger,
                              speakerId: speakerId,
                              selectedIndexFavorites: selectedIndexFavorites,
                              setSelectedIndexFavorites: (newFavorites) {
                                setState(() {
                                  selectedIndexFavorites = newFavorites;
                                });
                              },
                            );
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 5.h),
        BottomNavbarButton(audioPlayer: audioPlayer),
        SizedBox(height: 5.h),
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
            return SafeArea(
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SizedBox(
                    child: SingleChildScrollView(
                      child: buildLanguageButton(context, setState),
                    ),
                  );
                },
              ),
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
            return SafeArea(
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setModalState) {
                  return SizedBox(
                    height:
                        ResponsiveDesignOrientation.isLandscape ? 440.h : 220.h,
                    child: SingleChildScrollView(
                        child: buildGenderButton(context, setModalState)),
                  );
                },
              ),
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
                ModalHeader(title: 'language'.tr()),
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
      return buildLanguageFilterWidget(
        thaiName: lang['thaiName']!,
        englishName: lang['englishName']!,
        indonesianName: lang['indonesianName']!,
        imagePath: lang['image']!,
        lang: lang['code']!,
        context: context,
        setState: setState,
        onSelected: (langCode, displayText, imagePath) {
          setState(() {
            language = langCode;
            selectedLanguage = displayText;
            selectedLanguageImage = imagePath;
          });
        },
        selectedLanguage: selectedLanguage,
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
                ModalHeader(title: 'gender'.tr()),
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
      return GenderFilterWidget(
        thaiName: gender['thaiName']!,
        englishName: gender['englishName']!,
        indonesianName: gender['indonesianName']!,
        imagePath: gender['image']!,
        gender: gender['code']!,
        selectedGender: selectedGender,
        onSelected: (displayText, imagePath, gender) {
          setState(() {
            selectedGender = displayText;
            selectedGenderImage = imagePath;
            this.gender = gender;
          });
        },
      );
    }).toList();
  }
}
