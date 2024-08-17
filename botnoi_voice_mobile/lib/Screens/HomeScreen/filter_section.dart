import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_category_list.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_gender_metadata.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_language_metadata.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_style_list.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/gender_metadata_model.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/language_metadata_model.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/all_speaker_screen.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/toggle_favourite_button.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/voice_config_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FilterSection extends StatefulWidget {
  const FilterSection({
    super.key,
  });

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  bool _isSelectingGender = false;
  bool _isSelectingSpeechStyle = false;
  bool _isSelectingVoiceStyle = false;
  bool _isSelectingLangauge = false;

  String get selectedGender =>
      Provider.of<VoiceConfigProvider>(context).selectedGender;
  String get selectedLanguage =>
      Provider.of<VoiceConfigProvider>(context).selectedLanguage;
  String get selectedLanguageImage => embeddedLanguageMetadata
      .firstWhere(
        (language) => language.languageCode == selectedLanguage,
      )
      .imagePath;
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
  bool get isFavouriteSelected =>
      Provider.of<VoiceConfigProvider>(context).isFavouriteSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65.h,
      width: 480.w,
      child: Padding(
        padding: EdgeInsets.only(right: 10.w, left: 10.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _isSelectingLangauge = true;
                    });
                    _showLanguageSelectionModal(context);
                  },
                  child: Container(
                    width: 72.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(Radius.circular(4.r)),
                      border: Border.all(
                        color: const Color(0xFFE2E3E9),
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          selectedLanguageImage,
                          width: 14.w,
                          height: 14.h,
                        ),
                        SizedBox(width: 3.w),
                        Flexible(
                          child: Text(
                            selectedLanguage,
                            style: GoogleFonts.prompt(fontSize: 12.sp),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          _isSelectingLangauge
                              ? Icons.keyboard_arrow_up_sharp
                              : Icons.keyboard_arrow_down_sharp,
                          size: 20.sp,
                          color: const Color(0xFF323130),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isSelectingGender = true;
                    });
                    _showGenderSelectionModal(context);
                  },
                  child: Container(
                    width: 62.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.r),
                      ),
                      border: Border.all(
                        color: const Color(0xFFE2E3E9),
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 3.w),
                            Text(
                              selectedGender,
                              style: GoogleFonts.prompt(
                                fontSize: 12.sp,
                              ),
                            ),
                            _isSelectingGender
                                ? Icon(
                                    Icons.keyboard_arrow_up_sharp,
                                    size: 20.sp,
                                    color: const Color(0xFF323130),
                                  )
                                : Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    size: 20.sp,
                                    color: const Color(0xFF323130),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const ToggleFavouriteButton(),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllSpeakerScreen(),
                      ),
                    );
                  },
                  child: Container(
                    width: 63.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.r),
                      ),
                      border: Border.all(
                        color: const Color(0xFFE2E3E9),
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'ดูทั้งหมด',
                              style: GoogleFonts.prompt(
                                fontSize: 12.sp,
                                color: const Color(0xFF323130),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      _isSelectingVoiceStyle = true;
                    });
                    _showVoiceSyleSelectionModal(context);
                  },
                  child: Container(
                    width: 62.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.r),
                      ),
                      border: Border.all(
                        color: const Color(0xFFE2E3E9),
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 3.w),
                            Flexible(
                              child: Text(
                                'สไตล์',
                                style: GoogleFonts.prompt(fontSize: 12.sp),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              _isSelectingVoiceStyle
                                  ? Icons.keyboard_arrow_up_sharp
                                  : Icons.keyboard_arrow_down_sharp,
                              size: 20.sp,
                              color: const Color(0xFF323130),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      _isSelectingSpeechStyle = true;
                    });
                    _showSpeechStyleSelectionModal(context);
                  },
                  child: Container(
                    width: 62.w,
                    height: 26.h,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.r),
                      ),
                      border: Border.all(
                        color: const Color(0xFFE2E3E9),
                        width: 1.w,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 3.w),
                            Flexible(
                              child: Text(
                                'หมวดหมู่',
                                style: GoogleFonts.prompt(fontSize: 12.sp),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Icon(
                              _isSelectingSpeechStyle
                                  ? Icons.keyboard_arrow_up_sharp
                                  : Icons.keyboard_arrow_down_sharp,
                              size: 20.sp,
                              color: const Color(0xFF323130),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSpeechStyleSelectionModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SizedBox(
              height: 230.h,
              child: Padding(
                padding: EdgeInsets.all(25.r),
                child: Column(
                  children: [
                    SizedBox(
                      width: 360.w,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'หมวดหมู่',
                                style: GoogleFonts.prompt(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _isSelectingSpeechStyle = false;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 24.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 13.0,
                            runSpacing: 13.0,
                            children: embeddedCategoryList.map((speechStyle) {
                              return InkWell(
                                onTap: () {
                                  Provider.of<VoiceConfigProvider>(context,
                                          listen: false)
                                      .toggleSpeechStyle(speechStyle);
                                },
                                child: _buildStyleOption(
                                  speechStyle,
                                  selectedSpeechStyles.contains(speechStyle),
                                  context,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showVoiceSyleSelectionModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (
            BuildContext context,
            StateSetter setModalState,
          ) {
            return SizedBox(
              height: 220.h,
              child: Padding(
                padding: EdgeInsets.all(25.w),
                child: Column(
                  children: [
                    SizedBox(
                      width: 360.w,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'สไตล์',
                                style: GoogleFonts.prompt(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _isSelectingVoiceStyle = false;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 24.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 13.0,
                            runSpacing: 13.0,
                            children: embeddedStyleList.map((voiceStyle) {
                              return InkWell(
                                onTap: () {
                                  Provider.of<VoiceConfigProvider>(context,
                                          listen: false)
                                      .toggleVoiceStyle(voiceStyle);
                                },
                                child: _buildStyleOption(
                                  voiceStyle,
                                  selectedVoiceStyles.contains(voiceStyle),
                                  context,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showGenderSelectionModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return SizedBox(
              height: 220.h,
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    SizedBox(
                      width: 360.w,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'เพศ',
                                style: GoogleFonts.prompt(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _isSelectingGender = false;
                                  });
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 24.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          ...embeddedGenderMetadata
                              .map((GenderMetadataModel gender) {
                            return _buildGenderOption(
                              gender,
                              context,
                              setModalState,
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showLanguageSelectionModal(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (
            context,
            setModalState,
          ) {
            return SingleChildScrollView(
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(25.r),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 360.w,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ภาษา',
                                    style: GoogleFonts.prompt(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        _isSelectingLangauge = false;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 24.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              ...embeddedLanguageMetadata.map(
                                (LanguageMetadataModel language) {
                                  return _buildLanguageOption(
                                    language,
                                    context,
                                    setModalState,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStyleOption(
    String style,
    bool isSelected,
    BuildContext context,
  ) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [
                    Color(0xFF9A96F5),
                    Color(0xFF00E0FF),
                  ],
                )
              : null,
          borderRadius: BorderRadius.all(
            Radius.circular(4.r),
          ),
          border: Border.all(
            color: const Color(0xFFE2E3E9),
            width: 1.w,
          ),
        ),
        child: Center(
          child: Text(
            style,
            style: GoogleFonts.prompt(
              fontSize: 12.sp,
              color: isSelected ? Colors.white : const Color(0xFF323130),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    LanguageMetadataModel languageModel,
    BuildContext context,
    StateSetter setModalState,
  ) {
    return InkWell(
      onTap: () {
        Provider.of<VoiceConfigProvider>(context, listen: false)
            .setLanguage(languageModel.languageCode);
      },
      child: Container(
        padding: EdgeInsets.only(left: 10.w),
        height: 42.h,
        width: 320.w,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  languageModel.imagePath,
                  width: 23.w,
                  height: 23.h,
                ),
                SizedBox(
                  width: 20.w,
                ),
                Text(
                  languageModel.languageName,
                  style: GoogleFonts.prompt(
                    fontSize: 14.sp,
                    fontWeight: selectedLanguage == languageModel.languageCode
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderOption(
    GenderMetadataModel gender,
    BuildContext context,
    StateSetter setModalState,
  ) {
    return InkWell(
      onTap: () {
        Provider.of<VoiceConfigProvider>(context, listen: false)
            .setGender(gender.genderName);
      },
      child: Container(
        padding: EdgeInsets.only(left: 10.w),
        height: 42.h,
        width: 320.w,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              gender.imagePath,
              width: 23.w,
              height: 23.h,
            ),
            SizedBox(width: 20.w),
            Text(
              gender.genderName,
              style: GoogleFonts.prompt(
                fontSize: 14.sp,
                fontWeight: selectedGender == gender.genderName
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
