import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_category_list.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_gender_metadata.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_language_metadata.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_style_list.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/gender_metadata_model.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/language_metadata_model.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/favourite_genre_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class FilterSection extends StatefulWidget {
  const FilterSection({
    super.key,
    required this.selectedLanguage,
    required this.selectedGender,
    required this.isFavouriteSelected,
    required this.selectedVoiceStyles,
    required this.selectedSpeechStyles,
    required this.onLanguageSelected,
    required this.onGenderSelected,
    required this.onFavouriteSelected,
    required this.onVoiceStyleSelected,
    required this.onSpeechStyleSelected,
  });

  // Initial values
  final String selectedLanguage;
  final String selectedGender;
  final bool isFavouriteSelected;
  final List<String> selectedVoiceStyles;
  final List<String> selectedSpeechStyles;

  // Setters
  final Function(String) onLanguageSelected;
  final Function(String) onGenderSelected;
  final Function(bool) onFavouriteSelected;
  final Function(String) onVoiceStyleSelected;
  final Function(String) onSpeechStyleSelected;

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  List<String> _selectedVoiceStyles = [];
  List<String> _selectedSpeechStyles = [];
  String _selectedLanguage = "TH";
  String _selectedLanguageImage = 'assets/logo/Ellipse 12.jpg';
  String _selectedGender = "ช/ญ";

  bool _isFavouriteSelected = false;

  bool _isSelectingGender = false;
  bool _isSelectingSpeechStyle = false;
  bool _isSelectingVoiceStyle = false;
  bool _isSelectingLangauge = false;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.selectedLanguage;
    _selectedLanguageImage = embeddedLanguageMetadata
        .firstWhere((element) => element.languageCode == _selectedLanguage)
        .imagePath;
    _selectedGender = widget.selectedGender;
    _isFavouriteSelected = widget.isFavouriteSelected;
    _selectedVoiceStyles = widget.selectedVoiceStyles;
    _selectedSpeechStyles = widget.selectedSpeechStyles;
  }

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
                          _selectedLanguageImage,
                          width: 14.w,
                          height: 14.h,
                        ),
                        SizedBox(width: 3.w),
                        Flexible(
                          child: Text(
                            _selectedLanguage,
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
                              _selectedGender,
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
                InkWell(
                  onTap: () {
                    widget.onFavouriteSelected(!_isFavouriteSelected);
                    setState(() {
                      _isFavouriteSelected = !_isFavouriteSelected;
                    });
                  },
                  child: FavouriteFilterButton(
                    isFavouriteSelected: _isFavouriteSelected,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // TODO: Push to all speakers screen
                    //Navigator.push(
                    //    context,
                    //    MaterialPageRoute(
                    //        builder: (context) => const DisplayAllVoiceScreen()));
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
                                  widget.onSpeechStyleSelected(speechStyle);
                                  setModalState(() {
                                    if (_selectedSpeechStyles
                                        .contains(speechStyle)) {
                                      _selectedSpeechStyles.remove(speechStyle);
                                    } else {
                                      _selectedSpeechStyles.add(speechStyle);
                                    }
                                  });
                                  setState(() {});
                                },
                                child: _buildStyleOption(
                                  speechStyle,
                                  _selectedSpeechStyles.contains(speechStyle),
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
                                  widget.onVoiceStyleSelected(voiceStyle);
                                  setModalState(() {
                                    if (_selectedVoiceStyles
                                        .contains(voiceStyle)) {
                                      _selectedVoiceStyles.remove(voiceStyle);
                                    } else {
                                      _selectedVoiceStyles.add(voiceStyle);
                                    }
                                  });
                                  setState(() {});
                                },
                                child: _buildStyleOption(
                                  voiceStyle,
                                  _selectedVoiceStyles.contains(voiceStyle),
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
        widget.onLanguageSelected(languageModel.languageCode);
        setModalState(() {
          _selectedLanguage = languageModel.languageCode;
          _selectedLanguageImage = languageModel.imagePath;
        });
        setState(() {});
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
                    fontWeight: _selectedLanguage == languageModel.languageCode
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
        widget.onGenderSelected(gender.genderName);
        setModalState(() {
          _selectedGender = gender.genderName;
        });
        setState(() {});
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
                fontWeight: _selectedGender == gender.genderName
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
