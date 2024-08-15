import 'package:audioplayers/audioplayers.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_category_list.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_gender_metadata.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_language_metadata.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_speaker_metadata.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_style_list.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/gender_metadata_model.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/language_metadata_model.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/speaker_metadata_model.dart';
import 'package:botnoi_voice_mobile/MainServer/main_server_provider.dart';
import 'package:botnoi_voice_mobile/Modals/Delete/delete_modal.dart';
import 'package:botnoi_voice_mobile/Screens/DrawerAppBarScreen/drawer_appbar_screen.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/bottom_navbar.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/favourite_genre_filter.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/gradient_shapes.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/view_all_speakers_button.dart';
import 'package:botnoi_voice_mobile/Screens/SharedWidgets/gradient_button.dart';
import 'package:botnoi_voice_mobile/Screens/SharedWidgets/gradient_icon.dart';
import 'package:botnoi_voice_mobile/Screens/SharedWidgets/workspace_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _textController = TextEditingController();

  final List<String> _selectedVoiceStyles = [];
  final List<String> _selectedSpeechStyles = [];
  final List<String> _favouriteSpeakerIds = [];
  String? _generatedAudioUrl;
  String _selectedLanguage = "TH";
  String _selectedLanguageImage = 'assets/logo/Ellipse 12.jpg';
  String _selectedGender = "ช/ญ";
  String _selectedSpeakerId = embeddedSpeakerMetadata.first.speakerId;
  double _selectedVolume = 100;
  double _selectedSpeed = 100;

  bool _isFavouriteSelected = false;
  bool _isSelectingGender = false;
  bool _isSelectingSpeechStyle = false;
  bool _isSelectingVoiceStyle = false;
  bool _isSelectingLangauge = false;

  bool _showTextClearButton = false;

  bool _isMainConfigOpen = false;
  bool _isExtraConfigOpen = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSomeConfigOpen = _isMainConfigOpen || _isExtraConfigOpen;
    final int maxLinesWhenOpen = (404.h / 65.h).floor();
    final int maxLinesWhenClose = (404.h / 180.h).floor();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const DrawerAppbar(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              padding: EdgeInsets.only(left: 15.w),
              icon: Icon(
                Icons.menu_rounded,
                size: 32.sp,
                color: const Color(0xFF323130),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor: Colors.white,
        title: WorkspaceAppBarWidget(context),
      ),
      body: Column(
        children: [
          Container(
            width: 320.w,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            height: isSomeConfigOpen ? 196.h : 404.h,
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: 288.w,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 25.w, right: 10.w, top: 20.h),
                        child: Column(
                          children: [
                            TextField(
                              cursorColor: Colors.white,
                              style: GoogleFonts.prompt(
                                fontSize: 14.sp,
                                color: const Color(0xFF323130),
                              ),
                              minLines: isSomeConfigOpen
                                  ? maxLinesWhenClose
                                  : maxLinesWhenOpen,
                              maxLines: isSomeConfigOpen
                                  ? maxLinesWhenClose
                                  : maxLinesWhenOpen,
                              keyboardType: TextInputType.multiline,
                              controller: _textController,
                              onChanged: (text) {
                                if (_textController.text.length > 1000) {
                                  _textController.text =
                                      _textController.text.substring(0, 1000);
                                  _textController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                      offset: _textController.text.length,
                                    ),
                                  );
                                }
                                setState(() {
                                  _showTextClearButton =
                                      _textController.text.isNotEmpty;
                                });
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    'พิมพ์ข้อความให้ตรงกับภาษาที่เลือก . . .',
                                hintStyle: TextStyle(
                                  color: const Color(0xFFA19F9D),
                                  fontStyle: GoogleFonts.prompt(fontSize: 14.sp)
                                      .fontStyle,
                                ),
                                hintMaxLines: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 25.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      _showTextClearButton
                                          ? const SizedBox()
                                          : Padding(
                                              padding:
                                                  EdgeInsets.only(right: 1.w),
                                              child: InkWell(
                                                child: GradientIcon(
                                                  icon: Icons.close,
                                                  size: 20.sp,
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color(0xFF9340FF),
                                                      Color(0xFF34BDFA)
                                                    ],
                                                    begin: Alignment.topLeft,
                                                    end: Alignment.bottomRight,
                                                  ),
                                                ),
                                              ),
                                            )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GradientText(
                                        _textController.text.length.toString(),
                                        style: GoogleFonts.prompt(
                                          fontSize: 14.sp,
                                          color: const Color(0xFFA19F9D),
                                        ),
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF9340FF),
                                            Color(0xFF34BDFA)
                                          ],
                                        ),
                                      ),
                                      Text(
                                        ' / 1000',
                                        style: GoogleFonts.prompt(
                                          fontSize: 14.sp,
                                          color: const Color(0xFFA19F9D),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              height: 261.h,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isMainConfigOpen = !_isMainConfigOpen;
                        if (_isMainConfigOpen) {
                          _isExtraConfigOpen = false;
                        }
                      });
                    },
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: const Color(0xFFE2E3E9),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: Text(
                              "เลือกเสียง",
                              style: GoogleFonts.prompt(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF323130),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: _isMainConfigOpen
                                ? Icon(
                                    Icons.expand_less,
                                    color: const Color(0xFF323130),
                                    size: 20.sp,
                                  )
                                : Icon(
                                    Icons.expand_more,
                                    color: const Color(0xFF323130),
                                    size: 20.sp,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isMainConfigOpen) _buildMainConfigBar(context),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _isExtraConfigOpen = !_isExtraConfigOpen;
                        if (_isExtraConfigOpen) {
                          _isMainConfigOpen = false;
                        }
                      });
                    },
                    child: Container(
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: const Color(0xFFE2E3E9),
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(left: 20.w),
                            child: Text(
                              "ตั้งค่าเพิ่มเติม",
                              style: GoogleFonts.prompt(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF323130),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 20.w),
                            child: _isExtraConfigOpen
                                ? Icon(
                                    Icons.expand_less,
                                    color: const Color(0xFF323130),
                                    size: 20.sp,
                                  )
                                : Icon(
                                    Icons.expand_more,
                                    color: const Color(0xFF323130),
                                    size: 20.sp,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isExtraConfigOpen) _buildExtraConfigBar(context),
                  Expanded(
                    child: _buildGenerateVoiceButton(context),
                  ),
                  const BottomNavbar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainConfigBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 65.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                color: Colors.white,
                width: 480.w,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w, left: 10.w),
                  child: Row(
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.r)),
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
                          setState(() {
                            _isFavouriteSelected = !_isFavouriteSelected;
                          });
                        },
                        child: FavouriteFilterButton(
                          isFavouriteSelected: _isFavouriteSelected,
                        ),
                      ),
                      const ViewAllSpeakersButton(),
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
                                      style:
                                          GoogleFonts.prompt(fontSize: 12.sp),
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
                                      style:
                                          GoogleFonts.prompt(fontSize: 12.sp),
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
                ),
              ),
            ],
          ),
        ),
        _buildSpeakerTable(context),
      ],
    );
  }

  Widget _buildExtraConfigBar(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 142.h,
          child: Padding(
            padding: EdgeInsets.only(
              left: 20.w,
              top: 20.h,
              right: 10.w,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.volume_up,
                        color: const Color(0xFF323130), size: 20.sp),
                    SizedBox(width: 3.w),
                    SizedBox(
                        width: 46.w,
                        child: Text(
                          'ความดัง',
                          style: GoogleFonts.prompt(fontSize: 12.sp),
                        )),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                            thumbShape: GradientThumbShape(),
                            thumbColor: Colors.transparent,
                            trackShape:
                                const GradeintRoundedRectSliderTrackShape(),
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: const Color(0xFFF7F8FA)),
                        child: Slider(
                          value: _selectedVolume,
                          min: 0,
                          max: 100,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedVolume = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                        width: 55.w,
                        child: Text('${_selectedVolume.toStringAsFixed(1)}%',
                            style: GoogleFonts.prompt(
                              fontSize: 12.sp,
                            )))
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.speed,
                        color: const Color(0xFF323130), size: 20.sp),
                    SizedBox(width: 3.w),
                    SizedBox(
                        width: 46.w,
                        child: Text(
                          'ความเร็ว', //speed
                          style: GoogleFonts.prompt(fontSize: 12.sp),
                        )),
                    Expanded(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                            thumbShape: GradientThumbShape(),
                            thumbColor: Colors.transparent,
                            trackShape:
                                const GradeintRoundedRectSliderTrackShape(),
                            activeTrackColor: Colors.white,
                            inactiveTrackColor: const Color(0xFFF7F8FA)),
                        child: Slider(
                          value: _selectedSpeed,
                          min: 0.2,
                          max: 2.0,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedSpeed = newValue;
                            });
                          },
                        ),
                      ),
                    ),
                    Text(
                      '${_selectedSpeed.toStringAsFixed(1)} x',
                      style: GoogleFonts.prompt(fontSize: 12.sp),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
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
                                  setModalState(() {
                                    _selectedSpeechStyles.add(speechStyle);
                                  });
                                  Navigator.pop(context);
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
                                  setModalState(() {
                                    _selectedVoiceStyles.add(voiceStyle);
                                  });
                                  Navigator.pop(context);
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
        setModalState(() {
          _selectedLanguage = languageModel.languageCode;
          _selectedLanguageImage = languageModel.imagePath;
        });
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
        setModalState(() {
          _selectedGender = gender.genderName;
        });
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

  Widget _buildSpeakerCard(SpeakerMetadataModel speakerMetadata) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: GestureDetector(
            onTap: () async {
              if (_audioPlayer.state == PlayerState.playing) {
                await _audioPlayer.stop();
              }
              if (speakerMetadata.audio.isNotEmpty) {
                await _audioPlayer.play(UrlSource(speakerMetadata.audio));
                _audioPlayer.onPlayerComplete.listen((event) {});
              }
              setState(() {
                _selectedSpeakerId = speakerMetadata.speakerId;
              });
            },
            child: Column(
              children: [
                Container(
                  width: 81.w,
                  height: 103.h,
                  decoration: BoxDecoration(
                    border: GradientBoxBorder(
                      width: 3.w,
                      gradient: _selectedSpeakerId == speakerMetadata.speakerId
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
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        spreadRadius: 1,
                        color: _selectedSpeakerId == speakerMetadata.speakerId
                            ? const Color(0xFF9340FF).withOpacity(0.6) //new
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
                                right: 5.w,
                                top: 5.h,
                                left: 5.w,
                              ),
                              child: _selectedSpeakerId ==
                                      speakerMetadata.speakerId
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
                                        child: Text(
                                          'เลือก',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontStyle:
                                                GoogleFonts.prompt().fontStyle,
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
                                  setState(() {
                                    if (_favouriteSpeakerIds
                                        .contains(speakerMetadata.speakerId)) {
                                      _favouriteSpeakerIds
                                          .remove(speakerMetadata.speakerId);
                                    } else {
                                      _favouriteSpeakerIds
                                          .add(speakerMetadata.speakerId);
                                    }
                                  });
                                },
                                child: _favouriteSpeakerIds
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
                            SizedBox(
                              width: 10.w,
                            ),
                            _selectedSpeakerId == speakerMetadata.speakerId
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
                            SizedBox(
                              width: 3.w,
                            ),
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
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpeakerTable(BuildContext context) {
    List<SpeakerMetadataModel> speakersToShow =
        List.from(embeddedSpeakerMetadata);
    if (_isFavouriteSelected) {
      speakersToShow = embeddedSpeakerMetadata
          .where((speaker) => _favouriteSpeakerIds.contains(speaker.speakerId))
          .toList();
    }
    if (_selectedGender.isNotEmpty && _selectedGender != "ช/ญ") {
      speakersToShow = speakersToShow
          .where((speaker) => speaker.gender.contains(_selectedGender))
          .toList();
    }
    if (_selectedVoiceStyles.isNotEmpty) {
      speakersToShow = speakersToShow
          .where(
            (speaker) => _selectedVoiceStyles.contains(speaker.voiceStyle),
          )
          .toList();
    }
    if (_selectedSpeechStyles.isNotEmpty) {
      speakersToShow = speakersToShow
          .where(
            (speaker) => speaker.speechStyle.any(
              (speechStyle) => _selectedSpeechStyles.contains(speechStyle),
            ),
          )
          .toList();
    }
    if (_selectedLanguage.isNotEmpty) {
      speakersToShow = speakersToShow
          .where(
            (speaker) => speaker.language.contains(_selectedLanguage),
          )
          .toList();
    }

    return SizedBox(
      height: 127.h,
      width: 320.w,
      child: GridView.builder(
        itemCount: speakersToShow.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisExtent: 125,
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return _buildSpeakerCard(
            speakersToShow[index],
          );
        },
      ),
    );
  }

  Widget _buildGenerateVoiceButton(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Padding(
          padding:
              EdgeInsets.only(left: 20.w, top: 10.h, right: 20.w, bottom: 10.h),
          child: GradientButton(
            text: 'สร้างเสียง',
            onPressed: () async {
              setState(() {
                _audioPlayer.stop();
              });

              if (_textController.text.isEmpty) {
                // TODO: Show error message
                return;
              }
              if (_selectedSpeakerId.isEmpty) {
                // TODO: Show error message
                return;
              }

              _generatedAudioUrl =
                  await Provider.of<MainServerProvider>(context).generateAudio(
                _textController.text,
                _selectedSpeakerId,
              );

              if (_generatedAudioUrl?.isNotEmpty ?? false) {
                await textSave();
              }
              if (mounted) {
                //TODO: Go to the work space screen
                //Navigator.pushReplacement(
                //  context,
                //  MaterialPageRoute(
                //    builder: (context) => const WorkspaceScreen(),
                //  ),
                //);
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> textSave() async {
    //TODO: Implement this method
    // Define the new WorkSpace object
    //TextBoxModel newTextBox = TextBoxModel(
    //  text: _textController.text,
    //  speaker: int.parse(_selectedSpeakerId),
    //  audioId: '',
    //  speed: '1',
    //  statusDownload: true,
    //  url: _generatedAudioUrl ?? "",
    //  volume: '1',
    //);
    // Fetch existing workspaces for the project
    //await auth.getAllWorkspace();
    //if (auth.listProjects.isNotEmpty) {
    //  // Assuming you are working with the first project (adjust index as needed)
    //  ListProject project = auth.listProjects[0];
    //  print('Project ID: ${project.workspaceId}');
    //  print('Existing WorkSpaces: ${project.workSpaces.length}');
    //  // Create a new list from existing workspaces
    //  List<WorkSpace> existingWorkSpaces =
    //      List<WorkSpace>.from(project.workSpaces);
    //  print('Existing WorkSpaces (copied): ${existingWorkSpaces.length}');
    //  // Add the new workspace to the existing workspaces
    //  existingWorkSpaces.add(newTextBox);
    //  print(
    //      'New WorkSpace added. Total WorkSpaces: ${existingWorkSpaces.length}');
    //  // Update the workspaces with the new list
    //  await auth.updateWorkSpaces(project.workspaceId, existingWorkSpaces);
    //} else {
    //  print('No projects found.');
    //}
  }
}
