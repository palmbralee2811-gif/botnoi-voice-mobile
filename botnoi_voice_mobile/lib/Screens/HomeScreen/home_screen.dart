import 'package:audioplayers/audioplayers.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_category_list.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_gender_metadata.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_language_metadata.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_speaker_metadata.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_style_list.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/gender_metadata_model.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/language_metadata_model.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/speaker_metadata_model.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/text_box_model.dart';
import 'package:botnoi_voice_mobile/MainServer/main_server_provider.dart';
import 'package:botnoi_voice_mobile/Modals/Delete/delete_modal.dart';
import 'package:botnoi_voice_mobile/Screens/DrawerAppBarScreen/drawer_appbar_screen.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/Filters/favourite_genre_filter.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/Filters/recommended_filters.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/Filters/select_all_genre_button.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/category_setting_widget.dart';
import 'package:botnoi_voice_mobile/Screens/SharedWidgets/gradient_icon.dart';
import 'package:botnoi_voice_mobile/Screens/SharedWidgets/workspace_appbar_widget.dart';
import 'package:botnoi_voice_mobile/Screens/WorkspaceScreen/workspace_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController textController = TextEditingController();

  String _generatedAudioUrl = '';
  String? _selectedSpeakerId;
  String _selectedLanguage = "TH";
  String _selectedLanguageImage = 'assets/logo/Ellipse 12.jpg';
  String _selectedGender = "";
  final List<String> _selectedStyles = [];
  final List<String> _selectedCategories = [];

  bool _isAudioPlaying = false;
  bool _isFavouriteSelected = false;
  bool _isSelectingGender = false;
  bool _isSelectingCategory = false;
  bool _isSelectingStyle = false;
  int _isTypingText = 0;

  Set<int> selectedIndex2 = {};
  Set<int> selectedIndex = {};
  List<String> selectedIndexFavorites = [];

  int _selectedPageIndexVoice = 0;
  int _selectedPageIndexSetting = 0;

  void _selectPageVoice(int index) {
    setState(() {
      _selectedPageIndexVoice = index;
    });
  }

  void _selectPageSetting(int index) {
    setState(() {
      _selectedPageIndexSetting = index;
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;
    final maxLinesopen = (404.h / 65).floor();
    final maxLinesclose = (404.h / 180).floor();
    bool showClearIcon = false;

    if (_selectedPageIndexVoice == 1) {
      _isTypingText = 1;
      if (_selectedPageIndexSetting == 1) {
        _selectedPageIndexVoice = 0;
        _selectedPageIndexSetting = 1;
      }
    }
    if (_selectedPageIndexSetting == 2) {
      _selectedPageIndexVoice = 1;
      _selectedPageIndexSetting = 0;
    }
    if (_selectedPageIndexVoice == 2) {
      _isTypingText = 0;
    }
    if (_selectedPageIndexSetting == 1) {
      _isTypingText = 1;
    }

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
        children: <Widget>[
          Container(
            width: 320.w,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            height: _isTypingText == 1 ? 196.h : 404.h,
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
                              minLines: _isTypingText == 1
                                  ? maxLinesclose
                                  : maxLinesopen,
                              maxLines: _isTypingText == 1
                                  ? maxLinesclose
                                  : maxLinesopen,
                              keyboardType: TextInputType.multiline,
                              controller: textController,
                              onChanged: (text) {
                                if (textController.text.length > 1000) {
                                  textController.text =
                                      textController.text.substring(0, 1000);
                                  textController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                      offset: textController.text.length,
                                    ),
                                  );
                                }
                                setState(() {
                                  showClearIcon =
                                      textController.text.isNotEmpty;
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
                                      showClearIcon
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(right: 1.w),
                                              child: InkWell(
                                                child: Icon(
                                                  Icons.close_sharp,
                                                  size: 20.sp,
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  EdgeInsets.only(right: 1.w),
                                              child: InkWell(
                                                child: GradientIcon(
                                                  icon: Icons.close_sharp,
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
                                        '${textController.text.length}',
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
              height: _isTypingText == 1 ? 261.h : 261.h,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      if (_selectedPageIndexVoice == 0) {
                        _selectPageVoice(1);
                      } else if (_selectedPageIndexVoice == 1) {
                        _selectPageVoice(2);
                      } else if (_selectedPageIndexVoice == 2) {
                        _selectPageVoice(1);
                      }
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
                            child: _selectedPageIndexVoice == 1
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
                  if (_selectedPageIndexVoice == 1) ...[
                    _buildConfigurationBar(context)
                  ],
                  InkWell(
                    onTap: () {
                      if (_selectedPageIndexSetting == 0) {
                        _selectPageSetting(1);
                      } else if (_selectedPageIndexSetting == 1) {
                        _selectPageSetting(2);
                      } else if (_selectedPageIndexSetting == 2) {
                        _selectPageSetting(1);
                      }
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
                            child: _selectedPageIndexSetting == 1
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
                  if (_selectedPageIndexSetting == 1) ...[
                    const CategorySettings()
                  ],
                  Expanded(
                    child: buildVoiceHome(context),
                  ),
                  Container(
                    height: 54.h,
                    width: 320.w,
                    color: const Color(0xFF27282B),
                    child: InkWell(
                      onTap: () {},
                      child: currentIndex == 1
                          ? SvgPicture.asset(
                              'assets/logo/Property 1=studio, Property 2=deault (2).svg',
                            )
                          : SvgPicture.asset(
                              'assets/logo/Property 1=studio, Property 2=hover (1).svg',
                            ),
                    ),
                  )
                ],
              ), // 40% of the screen height
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfigurationBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 65.h, // ระยะห่าง BOTTOM "เลือกเสียง" กับ TOP "Filtter"
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                color: Colors.white,
                width: 480.w, // ระยะห่างระหว่าง Filter
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w, left: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          _showLanguageOptionModal(context);
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
                                _isLanguageOptionExpanded
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
                            _isSelectingGender = !_isSelectingGender;
                          });
                          showModalBottomSheet(
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setModalState) {
                                  return SizedBox(
                                    height: 220.h,
                                    child: Padding(
                                      padding: const EdgeInsets.all(25),
                                      child: Column(
                                        children: [
                                          Container(
                                            color: Colors.transparent,
                                            width: 360.w,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'เพศ',
                                                      style: GoogleFonts.prompt(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
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
                                                ...embeddedGenderMetadata.map(
                                                    (GenderMetadataModel g) {
                                                  return _buildGenderOption(
                                                    g,
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
                                  if (_selectedGender == '')
                                    Text(
                                      'ช/ญ',
                                      style: GoogleFonts.prompt(
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  if (_selectedGender.toString() != '')
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
                      const RecommendedFilters(),
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
                      const SelectAllGenreButton(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isSelectingStyle = !_isSelectingStyle;
                          });
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
                                          Container(
                                            color: Colors.transparent,
                                            width: 360.w,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'สไตล์',
                                                      style: GoogleFonts.prompt(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
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
                                                  alignment:
                                                      WrapAlignment.start,
                                                  spacing: 13.0,
                                                  runSpacing: 13.0,
                                                  children: embeddedStyleList
                                                      .map((style) {
                                                    return InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          _selectedStyles
                                                              .add(style);
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: _buildFilterButton(
                                                          style),
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
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Flexible(
                                    child: Text(
                                      'สไตล์',
                                      style:
                                          GoogleFonts.prompt(fontSize: 12.sp),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    _isSelectingStyle
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
                            _isSelectingCategory = !_isSelectingCategory;
                          });
                          showModalBottomSheet(
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setModalState) {
                                  return SizedBox(
                                    height: 230.h,
                                    child: Padding(
                                      padding: EdgeInsets.all(25.r),
                                      child: Column(
                                        children: [
                                          Container(
                                            color: Colors.transparent,
                                            width: 360.w,
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'หมวดหมู่',
                                                      style: GoogleFonts.prompt(
                                                        fontSize: 16.sp,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
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
                                                  alignment:
                                                      WrapAlignment.start,
                                                  spacing: 13.0,
                                                  runSpacing: 13.0,
                                                  children: embeddedCategoryList
                                                      .map((category) {
                                                    return InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          _selectedCategories
                                                              .add(category);
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: _buildFilterButton(
                                                          category),
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
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Flexible(
                                    child: Text(
                                      'หมวดหมู่',
                                      style:
                                          GoogleFonts.prompt(fontSize: 12.sp),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Icon(
                                    selectCategory
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
        Container(
          color: Colors.white,
          height: 148.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _isFavouriteSelected
                  ? _buildFavouriteSpeakerOption(context)
                  : _buildSpeakerOption(context),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showLanguageOptionModal(BuildContext context) {
    return showModalBottomSheet(
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
                        Container(
                          color: Colors.transparent,
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
                                (LanguageMetadataModel l) {
                                  return _buildLanguageOption(
                                    l,
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

  Widget _buildFilterButton(String text) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
        decoration: BoxDecoration(
          gradient: _selectedStyles.contains(text)
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
            text,
            style: GoogleFonts.prompt(
              fontSize: 12.sp,
              color: _selectedStyles.contains(text)
                  ? Colors.white
                  : const Color(0xFF323130),
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
        Navigator.pop(context);
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
    GenderMetadataModel genderModel,
    BuildContext context,
    StateSetter setState,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          if (genderModel.gender == 'ช/ญ') {
            _selectedGender = '';
          } else {
            _selectedGender = genderModel.gender;
          }
        });
        Navigator.pop(context);
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
              genderModel.imagePath,
              width: 23.w,
              height: 23.h,
            ),
            SizedBox(width: 20.w),
            Text(
              genderModel.gender,
              style: GoogleFonts.prompt(
                fontSize: 14.sp,
                fontWeight:
                    (_selectedGender.isEmpty ? "ช/ญ" : _selectedGender) ==
                            genderModel.gender
                        ? FontWeight.w600
                        : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeakerOption(BuildContext context) {
    return SizedBox(
      height: 127.h,
      width: 320.w,
      child: GridView.builder(
        itemCount: embeddedSpeakerMetadata
            .where(
              (item) =>
                  (_selectedGender == '' || item.gender == _selectedGender) &&
                  (_selectedLanguage == '' ||
                      item.language == _selectedLanguage) &&
                  (_selectedVoiceStyle == '' ||
                      item.voiceStyle == _selectedVoiceStyle) &&
                  (_selectedSpeechStyle == '' ||
                      item.speechStyle.contains(_selectedSpeechStyle)),
            )
            .length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisExtent: 125,
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final speaker = embeddedSpeakerMetadata
              .where(
                (item) =>
                    (_selectedGender == '' || item.gender == _selectedGender) &&
                    (_selectedLanguage == '' ||
                        item.language == _selectedLanguage) &&
                    (_selectedVoiceStyle == '' ||
                        item.voiceStyle == _selectedVoiceStyle) &&
                    (_selectedSpeechStyle == '' ||
                        item.speechStyle.contains(_selectedSpeechStyle)),
              )
              .toList()[index]; ////new
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: GestureDetector(
                  onTap: () async {
                    String audioURL = speaker.audio;
                    Future<void> playAudio() async {
                      if (audioURL.isNotEmpty) {
                        if (_isAudioPlaying) {
                          await _audioPlayer.stop();
                        }
                        await _audioPlayer.play(UrlSource(audioURL));
                        setState(() {
                          _isAudioPlaying = true;
                        });
                        _audioPlayer.onPlayerComplete.listen((event) {
                          setState(() {
                            _isAudioPlaying = false;
                          });
                        });
                      } else {
                        setState(() {
                          _isAudioPlaying = false;
                        });
                      }
                    }

                    await playAudio();
                    _selectedSpeakerId = speaker.speakerId;
                    setState(() {
                      if (selectedIndex.contains(index)) {
                        selectedIndex.remove(index);
                        if (_audioPlayer.state == PlayerState.playing) {
                          _audioPlayer.stop();
                        }
                      } else {
                        selectedIndex.clear();
                        selectedIndex.add(index);
                      }
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
                            gradient: selectedIndex.contains(index)
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF9A96F5),
                                      Color(0xFF00E0FF)
                                    ],
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
                              speaker.squareImage,
                            ),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 1,
                              color: selectedIndex.contains(index)
                                  ? const Color(0xFF9340FF)
                                      .withOpacity(0.6) //new
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      right: 5.w,
                                      top: 5.h,
                                      left: 5.w,
                                    ),
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
                                        EdgeInsets.only(right: 5.w, top: 5.h),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (selectedIndexFavorites
                                              .contains(speaker.speakerId)) {
                                            selectedIndexFavorites
                                                .remove(speaker.speakerId);
                                          } else {
                                            selectedIndexFavorites
                                                .add(speaker.speakerId);
                                          }
                                        });
                                      },
                                      child: selectedIndexFavorites
                                              .contains(speaker.speakerId)
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
                                                // color: Colors.white, //// ไม่ได้ใช้
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
                                  ), //new
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
                                            width: 16.w,
                                            height: 16.h,
                                            // color: Colors.white, //// ไม่ได้ใช้
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
                                      speaker.thaiName,
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
        },
      ),
    );
  }

  Column voicewidget(SpeakerMetadataModel speakerMetadata, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: GestureDetector(
            onTap: () async {
              String audioURL = speakerMetadata.audio;
              Future<void> playAudio() async {
                if (audioURL.isNotEmpty) {
                  if (_isAudioPlaying) {
                    await _audioPlayer.stop();
                  }
                  await _audioPlayer.play(UrlSource(audioURL));
                  setState(() {
                    _isAudioPlaying = true;
                  });
                  _audioPlayer.onPlayerComplete.listen((event) {
                    setState(() {
                      _isAudioPlaying = false;
                    });
                  });
                } else {
                  setState(() {
                    _isAudioPlaying = false;
                  });
                }
              }

              await playAudio();
              _selectedSpeakerId = speakerMetadata.speakerId;
              setState(() {
                if (selectedIndex.contains(index)) {
                  selectedIndex.remove(index);
                  if (_audioPlayer.state == PlayerState.playing) {
                    _audioPlayer.stop();
                  }
                } else {
                  selectedIndex.clear();
                  selectedIndex.add(index);
                }
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
                      gradient: selectedIndex.contains(index)
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
                        color: selectedIndex.contains(index)
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
                                              fontStyle: GoogleFonts.prompt()
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
                              padding: EdgeInsets.only(right: 5.w, top: 5.h),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (selectedIndexFavorites
                                        .contains(speakerMetadata.speakerId)) {
                                      selectedIndexFavorites
                                          .remove(speakerMetadata.speakerId);
                                    } else {
                                      selectedIndexFavorites
                                          .add(speakerMetadata.speakerId);
                                    }
                                  });
                                },
                                child: selectedIndexFavorites
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

  Widget _buildFavouriteSpeakerOption(BuildContext context) {
    return SizedBox(
      height: 127.h,
      width: 320.w,
      child: GridView.builder(
        itemCount: embeddedSpeakerMetadata
            .where((item) =>
                selectedIndexFavorites.isEmpty ||
                selectedIndexFavorites.contains(item.speakerId))
            .length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisExtent: 125,
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final data = embeddedSpeakerMetadata
              .where((item) =>
                  selectedIndexFavorites.isEmpty ||
                  selectedIndexFavorites.contains(item.speakerId))
              .toList()[index];

          return voicewidget(data, index);
        },
      ),
    );
  }

  Widget buildVoiceHome(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: GradientButton(
            text: 'สร้างเสียง',
            onPressed: () async {
              if (textController.text.isNotEmpty) {
                setState(() {
                  _audioPlayer.stop();
                });
              }
              if (textController.text.isNotEmpty) {
                //TODO: Generate audio
                //_audioUrl = await Provider.of<MainServerProvider>(context)
                //    .generateAudio(textController.text);
                if (_generatedAudioUrl.isNotEmpty && _generatedAudioUrl != '') {
                  await textSave(_generatedAudioUrl);
                }
              }
              await Future.delayed(const Duration(seconds: 2));
              navigateToMyHomePage();
            },
          ),
        ),
      ],
    );
  }

  void navigateToMyHomePage() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WorkspaceScreen()),
      );
    }
  }

  Future<void> textSave(String audioUrl) async {
    // Define the new WorkSpace object
    TextBoxModel newTextBox = TextBoxModel(
      text: textController.text,
      speaker: int.parse(_selectedSpeakerId!),
      audioId: '',
      speed: '1',
      statusDownload: true,
      url: audioUrl,
      volume: '1',
    );

    // Fetch existing workspaces for the project
    //await auth.getAllWorkspace();
    //if (auth.listProjects.isNotEmpty) {
    //  // Assuming you are working with the first project (adjust index as needed)
    //  ListProject project = auth.listProjects[0];
    //  print('Project ID: ${project.workspaceId}');
    //  print('Existing WorkSpaces: ${project.workSpaces.length}');
    //
    //  // Create a new list from existing workspaces
    //  List<WorkSpace> existingWorkSpaces =
    //      List<WorkSpace>.from(project.workSpaces);
    //  print('Existing WorkSpaces (copied): ${existingWorkSpaces.length}');
    //
    //  // Add the new workspace to the existing workspaces
    //  existingWorkSpaces.add(newTextBox);
    //  print(
    //      'New WorkSpace added. Total WorkSpaces: ${existingWorkSpaces.length}');
    //
    //  // Update the workspaces with the new list
    //  await auth.updateWorkSpaces(project.workspaceId, existingWorkSpaces);
    //} else {
    //  print('No projects found.');
    //}
  }
}
