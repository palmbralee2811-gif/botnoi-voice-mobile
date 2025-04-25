import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/data/entities/speaker_entity.dart';
import 'package:botnoivoice/data/model/speaker_model/gender_filter.dart';
import 'package:botnoivoice/data/model/speaker_model/language_filter.dart';
import 'package:botnoivoice/data/model/speaker_model/speaker_model.dart';
import 'package:botnoivoice/function/get_jwt_token.dart';
import 'package:botnoivoice/service/favorite/favorite_service.dart';
import 'package:botnoivoice/ui/screen/main/home_speaker_data_management.dart';
import 'package:botnoivoice/ui/screen/main/speaker/appbar_speaker_screen.dart';
import 'package:botnoivoice/ui/screen/main/speaker/favorite_button.dart';
import 'package:botnoivoice/ui/screen/main/speaker/speaker_filter_button.dart';
import 'package:botnoivoice/ui/screen/main/speaker/widget/favorite_filter.dart';
import 'package:botnoivoice/ui/screen/main/speaker/widget/speaker_grid_item.dart';
import 'package:botnoivoice/ui/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/ui/style/style.dart';
import 'package:botnoivoice/ui/widget/gradient/gradient_text_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
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

  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    language = tr('default_language_filter_code');
    gender = '';

    _loadInitialData();
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
    return Scaffold(
      appBar: const AppBarSpeakerScreen(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : buildFilterNavbar(context),
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
                          onSpeakerTap: _handleSpeakerTap,
                          onFavoriteToggle: _handleFavoriteToggle,
                          currentLanguage: language ?? 'TH',
                        )
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

// -------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
            final originalIndex = SpeakerModel.speakerItem
                .indexWhere((s) => s.speakerId == data.speakerId);

            // --- ส่วนที่แก้ไข: เรียกใช้ SpeakerGridItem ---
            return SpeakerGridItem(
              speakerItem: data,
              index: originalIndex, // ใช้ original index
              isSelected: selectedIndex.contains(originalIndex),
              isFavorite: selectedIndexFavorites.contains(data.speakerId),
              onSpeakerTap: _handleSpeakerTap, // ส่ง Callback
              onFavoriteToggle: _handleFavoriteToggle, // ส่ง Callback
            );
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

  // เพิ่ม function นี้ใน class _SpeakerScreenState
  void _handleSpeakerTap(int index, SpeakerEntity speakerItem) async {
    // --- โค้ดเดิมจาก onTap ของ buildSingleSpeaker ---
    String audioURL = speakerItem.audio;

    Future<void> playAudio() async {
      try {
        // หยุดการเล่นหากกำลังเล่นอยู่
        if (audioPlayer.state == PlayerState.playing) {
          await audioPlayer.stop();
        }

        // ดาวน์โหลดไฟล์เสียงพร้อม Referer Header
        final response = await http.get(
          Uri.parse(audioURL),
          headers: {
            'Referer': 'https://voice.botnoi.ai/',
          },
        );

        if (response.statusCode == 200) {
          // ใช้ BytesSource เพื่อเล่นไฟล์จากหน่วยความจำ
          final audioBytes = response.bodyBytes;
          if (audioBytes.isNotEmpty) {
            final mimeType = response.headers['content-type'] ?? 'audio/wav';
            audioPlayer.play(BytesSource(audioBytes, mimeType: mimeType));
          }
        } else {
          print('Failed to load audio: ${response.statusCode}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Error loading audio: ${response.statusCode}')),
          );
        }
      } catch (e) {
        print('Error playing audio: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }

    String languageCode = Localizations.localeOf(context).languageCode;
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

    if (selectedIndex.contains(index)) {
      setState(() {
        if (audioPlayer.state == PlayerState.playing) {
          audioPlayer.stop();
        }
        selectedIndex.remove(index);
      });
    } else {
      await playAudio();

      setState(() {
        selectedIndex.clear();
        selectedIndex.add(index);
      });
    }
  }

  void _handleFavoriteToggle(String speakerId) async {
    final bool isCurrentlyFavorite = selectedIndexFavorites.contains(speakerId);
    final originalFavorites = List<String>.from(selectedIndexFavorites);

    setState(() {
      if (isCurrentlyFavorite) {
        // ถ้ากดตอนที่เป็น Favorite อยู่แล้ว = Remove
        selectedIndexFavorites.remove(speakerId);
        _logger.d("UI: Removed $speakerId from state");
      } else {
        // ถ้ากดตอนที่ยังไม่เป็น Favorite = Add
        selectedIndexFavorites.add(speakerId);
        _logger.d("UI: Added $speakerId to state");
      }
      _logger.d("UI list state is now: $selectedIndexFavorites");
    });

    // เรียก API ตามสถานการณ์
    try {
      final String? token = await getJwtTokenAll(context);
      if (token == null || token.isEmpty) {
        throw Exception('Token not found.'); // โยน Error ถ้าไม่มี Token
      }

      final favoriteService = FavoriteService(); // สร้าง Instance Service

      if (isCurrentlyFavorite) {
        // ---------- กรณี Remove ----------
        _logger.i(">>> Calling REMOVE API for ID: $speakerId");
        // เรียกใช้ Method ใหม่สำหรับลบ โดยส่ง ID ตัวเดียว
        await favoriteService.removeFavoriteSpeaker(speakerId, token);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Favorite removed!')), // ข้อความแจ้งเตือน
          );
        }
      } else {
        // ---------- กรณี Add ----------
        // สร้าง List ล่าสุดที่จะ Save (หลังจาก Add ID ใหม่เข้าไปแล้ว)
        final listToSend = List<String>.from(selectedIndexFavorites);
        _logger.i(">>> Calling SAVE API with list: $listToSend");
        // เรียกใช้ Method เดิมสำหรับ Save โดยส่ง List ปัจจุบันทั้งหมด
        await favoriteService.saveFavoriteSpeakers(listToSend, token);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Favorite added!')), // ข้อความแจ้งเตือน
          );
        }
      }
    } catch (e) {
      _logger.e("Error in favorite toggle API call: $e");
      // ถ้าเกิด Error ให้ Rollback การเปลี่ยนแปลง UI กลับไปเป็นเหมือนเดิม
      if (mounted) {
        setState(() {
          _logger.w("Rolling back favorite state due to error: $e");
          selectedIndexFavorites = originalFavorites; // คืนค่า State เดิม
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating favorites: ${e.toString()}')),
        );
      }
    }
  }

  Future<void> _loadInitialData() async {
    try {
      final String? token = await getJwtTokenAll(context);
      if (token == null || token.isEmpty) {
        return;
      }

      final FavoriteService favoriteService = FavoriteService();

      final List<String> fetchedFavorites =
          await favoriteService.getFavoriteSpeakers(token);

      if (mounted) {
        setState(() {
          selectedIndexFavorites = fetchedFavorites;
        });
      }
    } catch (e) {
      _logger.e("Error loading favorite speakers: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // เอาสถานะ Loading ออก
        });
      }
    }
  }
}
