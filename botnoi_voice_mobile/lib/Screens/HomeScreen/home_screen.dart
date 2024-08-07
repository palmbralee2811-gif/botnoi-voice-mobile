import 'package:audioplayers/audioplayers.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_gender_metadata.dart';
import 'package:botnoi_voice_mobile/MainServer/EmbeddedData/embedded_speaker_metadata.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/gender_metadata_model.dart';
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
  final TextEditingController textController = TextEditingController();

  // Generate Audio
  String _audioUrl = '';
  String? _selectedSpeakerId;

  String _selectedLanguage = "TH";
  String _selectedLanguageImage =
      'assets/logo/Ellipse 12.jpg'; ///// กำหนดรูปค่าเริ่มต้น new

  String _selectedGender = "";
  String _selectedSpeechStyle = "";
  String _selectedVoiceStyle = "";

  // Download File
  String downloadProgress = '';
  bool isDownloading = false;

  // Audio Player
  final AudioPlayer audioPlayer = AudioPlayer();
  bool isAudioPlaying = false;

  Set<int> selectedIndex2 = {};
  Set<int> selectedIndex = {};
  List<String> selectedIndexFavorites = []; // เลือกเสียงที่ชอบ

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  int _selectedPageIndexVoice = 0;
  int _selectedPageIndexSetting = 0;
  int _inputtext = 0;

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

  bool _isFavouriteSelected = false;

  //เลือกภาษา

  bool changeIcon = false; /////////////เลือกเพศ

  bool selectStyle = false; /////////////เลือกสไตล์
  bool selectStyle1 = false; /////////////เลือกสไตล์
  bool selectStyle2 = false; /////////////เลือกสไตล์
  bool selectStyle3 = false; /////////////เลือกสไตล์
  bool selectStyle4 = false; /////////////เลือกสไตล์
  bool selectStyle5 = false; /////////////เลือกสไตล์
  bool selectStyle6 = false; /////////////เลือกสไตล์
  bool selectStyle7 = false; /////////////เลือกสไตล์
  bool selectStyle8 = false; /////////////เลือกสไตล์
  bool selectStyle9 = false; /////////////เลือกสไตล์
  bool selectStyle10 = false; /////////////เลือกสไตล์
  bool selectStyle11 = false; /////////////เลือกสไตล์
  bool selectStyle12 = false; /////////////เลือกสไตล์
  bool selectStyle13 = false; /////////////เลือกสไตล์
  bool selectStyle14 = false; /////////////เลือกสไตล์
  bool selectStyle15 = false; /////////////เลือกสไตล์
  bool selectStyle16 = false; /////////////เลือกสไตล์

  bool selectCategory = false; /////////////เลือกหมวดหมู่
  bool selectCategory1 = false; /////////////เลือกหมวดหมู่
  bool selectCategory2 = false; /////////////เลือกหมวดหมู่
  bool selectCategory3 = false; /////////////เลือกหมวดหมู่
  bool selectCategory4 = false; /////////////เลือกหมวดหมู่
  bool selectCategory5 = false; /////////////เลือกหมวดหมู่
  bool selectCategory6 = false; /////////////เลือกหมวดหมู่
  bool selectCategory7 = false; /////////////เลือกหมวดหมู่
  bool selectCategory8 = false; /////////////เลือกหมวดหมู่
  bool selectCategory9 = false; /////////////เลือกหมวดหมู่
  bool selectCategory10 = false; /////////////เลือกหมวดหมู่

  @override
  Widget build(BuildContext context) {
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;
    double screenSizeheightInputtextOpen = MediaQuery.of(context).size.height;
    double screenSizeheightInputtextClose = MediaQuery.of(context).size.height;
    int currentIndex = 0;
    final screenHeightOpen = screenSizeheightInputtextOpen;
    final maxLinesopen = (screenHeightOpen / 65).floor();
    final screenHeightClose = screenSizeheightInputtextOpen;
    final maxLinesclose = (screenHeightClose / 180).floor();
    bool showClearIcon = false;

    if (_selectedPageIndexVoice == 1) {
      _inputtext = 1;
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
      _inputtext = 0;
    }
    if (_selectedPageIndexSetting == 1) {
      _inputtext = 1;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: DrawerAppbar(screenSizeheight: screenSizeheight),
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
            width: screenSizewidth,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            height: _inputtext == 1
                ? screenSizeheightInputtextClose * 0.30
                : screenSizeheightInputtextOpen * 0.59,
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
                            EdgeInsets.only(left: 25.w, right: 10.w, top: 20.w),
                        child: Column(
                          children: [
                            TextField(
                              cursorColor: Colors.white,
                              style: GoogleFonts.prompt(
                                fontSize: 14.sp,
                                color: const Color(0xFF323130),
                              ),
                              minLines: _inputtext == 1
                                  ? maxLinesclose
                                  : maxLinesopen,
                              maxLines: _inputtext == 1
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
              height: _inputtext == 1
                  ? screenSizeheight * 0.50
                  : screenSizeheight * 0.26,
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
                      height: screenSizeheight * 0.05.h,
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
                      height: screenSizeheight * 0.05.h,
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
                    height: screenSizeheight * 0.052.h,
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
    //TODO: remove this variable
    double screenSizeheight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: screenSizeheight * 0.05.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              Container(
                color: Colors.white,
                width: 450.w,
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
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4),
                            ),
                            border: Border.all(
                              color: const Color(0xFFE2E3E9),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                _selectedLanguageImage,
                                width: 14,
                                height: 14,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
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
                                size: 20,
                                color: const Color(0xFF323130),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            changeIcon = !changeIcon;
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
                                            width: 360,
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
                                                ...genderMetadata.map(
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
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4),
                            ),
                            border: Border.all(
                              color: const Color(0xFFE2E3E9),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(width: 3),
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
                                  changeIcon
                                      ? const Icon(
                                          Icons.keyboard_arrow_up_sharp,
                                          size: 20,
                                          color: Color(0xFF323130),
                                        )
                                      : const Icon(
                                          Icons.keyboard_arrow_down_sharp,
                                          size: 20,
                                          color: Color(0xFF323130),
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
                            selectStyle = !selectStyle;
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
                                            width: 360,
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
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle1 =
                                                              !selectStyle1;
                                                          _selectedVoiceStyle =
                                                              selectStyle1
                                                                  ? 'เสียงน่ารัก'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: _buildGenereFilter(
                                                          'น่ารัก',
                                                          selectStyle1),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle2 =
                                                              !selectStyle2;
                                                          _selectedVoiceStyle =
                                                              selectStyle2
                                                                  ? 'เสียงมั่นใจ'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: _buildGenereFilter(
                                                          'มั่นใจ',
                                                          selectStyle2),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle3 =
                                                              !selectStyle3;
                                                          _selectedVoiceStyle =
                                                              selectStyle3
                                                                  ? 'เสียงน่าเชื่อถือ'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: _buildGenereFilter(
                                                          'น่าเชื่อถือ',
                                                          selectStyle3),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle4 =
                                                              !selectStyle4;
                                                          _selectedVoiceStyle =
                                                              selectStyle4
                                                                  ? 'เสียงตื่นเต้น'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: _buildGenereFilter(
                                                          'ตื่นเต้น',
                                                          selectStyle4),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle5 =
                                                              !selectStyle5;
                                                          _selectedVoiceStyle =
                                                              selectStyle5
                                                                  ? 'เสียงจริงจัง'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: _buildGenereFilter(
                                                          'จริงจัง',
                                                          selectStyle5),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle6 =
                                                              !selectStyle6;
                                                          _selectedVoiceStyle =
                                                              selectStyle6
                                                                  ? 'เสียงหวาน'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: _buildGenereFilter(
                                                          'หวาน', selectStyle6),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle7 =
                                                              !selectStyle7;
                                                          _selectedVoiceStyle =
                                                              selectStyle7
                                                                  ? 'เสียงอบอุ่น'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: _buildGenereFilter(
                                                          'อบอุ่น',
                                                          selectStyle7),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle8 =
                                                              !selectStyle8;
                                                          _selectedVoiceStyle =
                                                              selectStyle8
                                                                  ? 'เสียงขี้เล่น'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: _buildGenereFilter(
                                                          'ขี้เล่น',
                                                          selectStyle8),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle9 =
                                                              !selectStyle9;
                                                          _selectedVoiceStyle =
                                                              selectStyle9
                                                                  ? 'เสียงทุ้ม'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: _buildGenereFilter(
                                                          'ทุ้ม', selectStyle9),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle10 =
                                                              !selectStyle10;
                                                          _selectedVoiceStyle =
                                                              selectStyle10
                                                                  ? 'เสียงนุ่มนวล'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: _buildGenereFilter(
                                                          'นุ่มนวล',
                                                          selectStyle10),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle11 =
                                                              !selectStyle11;
                                                          _selectedVoiceStyle =
                                                              selectStyle11
                                                                  ? 'เสียงท้องถิ่น'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: _buildGenereFilter(
                                                          'ท้องถิ่น',
                                                          selectStyle11),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle12 =
                                                              !selectStyle12;
                                                          _selectedVoiceStyle =
                                                              selectStyle12
                                                                  ? 'เสียงใจเย็น'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: _buildGenereFilter(
                                                          'ใจเย็น',
                                                          selectStyle12),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle13 =
                                                              !selectStyle13;
                                                          _selectedVoiceStyle =
                                                              selectStyle13
                                                                  ? 'เสียงนิ่มนวล'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: _buildGenereFilter(
                                                          'นิ่มนวล',
                                                          selectStyle13),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle14 =
                                                              !selectStyle14;
                                                          _selectedVoiceStyle =
                                                              selectStyle14
                                                                  ? 'เสียงชัดเจน'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: _buildGenereFilter(
                                                          'ชัดเจน',
                                                          selectStyle14),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle15 =
                                                              !selectStyle15;
                                                          _selectedVoiceStyle =
                                                              selectStyle15
                                                                  ? 'เสียงเหนือ'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: _buildGenereFilter(
                                                          'เหนือ',
                                                          selectStyle15),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle16 =
                                                              !selectStyle16;
                                                          _selectedVoiceStyle =
                                                              selectStyle16
                                                                  ? 'เสียงอีสาน'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                      },
                                                      child: _buildGenereFilter(
                                                          'อีสาน',
                                                          selectStyle16),
                                                    ),
                                                  ],
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
                          ).whenComplete(() {
                            setState(() {
                              selectStyle = false;
                            });
                          });
                        },
                        child: Container(
                          width: 62.w,
                          height: 26.h,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4),
                            ),
                            border: Border.all(
                              color: const Color(0xFFE2E3E9),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 3,
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
                                    selectStyle
                                        ? Icons.keyboard_arrow_up_sharp
                                        : Icons.keyboard_arrow_down_sharp,
                                    size: 20,
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
                            selectCategory = !selectCategory;
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
                                      padding: const EdgeInsets.all(25),
                                      child: Column(
                                        children: [
                                          Container(
                                            color: Colors.transparent,
                                            width: 360,
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
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory1 =
                                                              !selectCategory1;
                                                          _selectedSpeechStyle =
                                                              selectCategory1
                                                                  ? 'สไตล์เล่าเรื่อง'
                                                                      'สไตล์อ่านข่าว'
                                                                  : '';
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: _buildGenereFilter(
                                                          'เล่าเรื่อง',
                                                          selectCategory1),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory2 =
                                                              !selectCategory2;
                                                          _selectedSpeechStyle =
                                                              selectCategory2
                                                                  ? 'สไตล์อ่านข่าว'
                                                                      'สไตล์เล่าเรื่อง'
                                                                  : '';
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: _buildGenereFilter(
                                                          'อ่านข่าว',
                                                          selectCategory2),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory3 =
                                                              !selectCategory3;
                                                          _selectedSpeechStyle =
                                                              selectCategory3
                                                                  ? 'สไตล์เล่าเรื่อง'
                                                                      'สไตล์ตัวละคร'
                                                                  : '';
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: _buildGenereFilter(
                                                          'ตัวละคร',
                                                          selectCategory3),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory4 =
                                                              !selectCategory4;
                                                          _selectedSpeechStyle =
                                                              selectCategory4
                                                                  ? 'สไตล์บรรยาย'
                                                                      'สไตล์ตัวละคร'
                                                                  : '';
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: _buildGenereFilter(
                                                          'บรรยาย',
                                                          selectCategory4),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory5 =
                                                              !selectCategory5;
                                                          _selectedSpeechStyle =
                                                              selectCategory5
                                                                  ? 'สไตล์อ่านข่าว'
                                                                      'สไตล์สปอตโฆษณา'
                                                                  : '';
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: _buildGenereFilter(
                                                          'สปอตโฆษณา',
                                                          selectCategory5),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory6 =
                                                              !selectCategory6;
                                                          _selectedSpeechStyle =
                                                              selectCategory6
                                                                  ? 'สไตล์สารคดี'
                                                                      'สไตล์บรรยาย'
                                                                  : '';
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: _buildGenereFilter(
                                                          'สารคดี',
                                                          selectCategory6),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory7 =
                                                              !selectCategory7;
                                                          _selectedSpeechStyle =
                                                              selectCategory7
                                                                  ? 'สไตล์ตัวละคร'
                                                                      'สไตล์อนิเมะ'
                                                                  : '';
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: _buildGenereFilter(
                                                          'อนิเมะ',
                                                          selectCategory7),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory8 =
                                                              !selectCategory8;
                                                          _selectedSpeechStyle =
                                                              selectCategory8
                                                                  ? 'สไตล์บรรยาย'
                                                                      'สไตล์อาจารย์'
                                                                  : '';
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: _buildGenereFilter(
                                                          'อาจารย์',
                                                          selectCategory8),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory9 =
                                                              !selectCategory9;
                                                          _selectedSpeechStyle =
                                                              selectCategory9
                                                                  ? 'สไตล์เล่าเรื่อง'
                                                                      'สไตล์ท้องถิ่น'
                                                                  : '';
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: _buildGenereFilter(
                                                          'ท้องถิ่น',
                                                          selectCategory9),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory10 =
                                                              !selectCategory10;
                                                          _selectedSpeechStyle =
                                                              selectCategory10
                                                                  ? 'สไตล์อ่านข่าว'
                                                                      'สไตล์เสียงต่างประเทศ'
                                                                  : '';
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                      child: _buildGenereFilter(
                                                          'เสียงต่างประเทศ',
                                                          selectCategory10),
                                                    ),
                                                  ],
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
                          ).whenComplete(() {
                            setState(() {
                              selectCategory = false;
                            });
                          });
                        },
                        child: Container(
                          width: 62.w,
                          height: 26.h,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(4),
                            ),
                            border: Border.all(
                              color: const Color(0xFFE2E3E9),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 3,
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
                                    size: 20,
                                    color: const Color(0xFF323130),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // const New(), ////ยังไม่ใช้
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
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        Container(
                          color: Colors.transparent,
                          width: 360,
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
                              _buildLanguageOption(
                                'All(AllLanguages) - ทั้งหมด',
                                'assets/logo/13766953.png',
                                '',
                                context,
                                setModalState,
                              ),
                              _buildLanguageOption(
                                'Thai(Thailand) - ไทย',
                                'assets/logo/Ellipse 12.jpg',
                                'TH',
                                context,
                                setModalState,
                              ),
                              _buildLanguageOption(
                                'English (UK) - อังกฤษ',
                                'assets/logo/Ellipse 13.jpg',
                                'EN',
                                context,
                                setModalState,
                              ),
                              _buildLanguageOption(
                                'Indonesia - อินโดนีเซีย',
                                'assets/logo/Ellipse 13 (2).jpg',
                                'ID',
                                context,
                                setModalState,
                              ),
                              _buildLanguageOption(
                                'Japanese - ญี่ปุ่น',
                                'assets/logo/Ellipse 14.jpg',
                                'JA',
                                context,
                                setModalState,
                              ),
                              _buildLanguageOption(
                                'Laos - ลาว',
                                'assets/logo/Ellipse 15.jpg',
                                'LO',
                                context,
                                setModalState,
                              ),
                              _buildLanguageOption(
                                'Myanmar - เมียนมาร์',
                                'assets/logo/Ellipse 11.jpg',
                                'MY',
                                context,
                                setModalState,
                              ),
                              _buildLanguageOption(
                                'Vietnam - เวียดนาม',
                                'assets/logo/Ellipse 19.jpg',
                                'VI',
                                context,
                                setModalState,
                              ),
                              _buildLanguageOption(
                                'Chinese (Simplified) - จีน',
                                'assets/logo/Ellipse 18.jpg',
                                'ZH',
                                context,
                                setModalState,
                              ),
                              _buildLanguageOption(
                                'Cambodia - กัมพูชา',
                                'assets/logo/images (1).png',
                                'KM',
                                context,
                                setModalState,
                              ),
                              _buildLanguageOption(
                                'Phillippines - ฟิลิปปินส์',
                                'assets/logo/Flag_of_the_Philippines.svg.png',
                                'FIL',
                                context,
                                setModalState,
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

  Widget _buildGenereFilter(String text, bool isSelected) {
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
          borderRadius: const BorderRadius.all(
            Radius.circular(4),
          ),
          border: Border.all(
            color: const Color(0xFFE2E3E9),
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            text,
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
    String text,
    String imagePath,
    String langCode,
    BuildContext context,
    StateSetter setModalState,
  ) {
    return InkWell(
      onTap: () {
        setModalState(() {
          if (text == 'ทั้งหมด') {
            _selectedLanguage = '';
          } else {
            List<String> parts = text.split(' - ');
            if (parts.length > 1) {
              _selectedLanguage = parts[1];
            } else {
              _selectedLanguage = text;
            }
            _selectedLanguageImage = imagePath;
            _selectedLanguage = langCode;
          }
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
                  imagePath,
                  width: 23.w,
                  height: 23.h,
                ),
                SizedBox(
                  width: 20.w,
                ),
                Text(
                  text,
                  style: GoogleFonts.prompt(
                    fontSize: 14.sp,
                    fontWeight: _selectedLanguage ==
                            (text.split(' - ').length > 1
                                ? text.split(' - ')[1]
                                : text)
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
        itemCount: speakerMetadata
            .where((item) =>
                (_selectedGender == '' || item.gender == _selectedGender) &&
                (_selectedLanguage == '' ||
                    item.language == _selectedLanguage) &&
                (_selectedVoiceStyle == '' ||
                    item.voiceStyle == _selectedVoiceStyle) &&
                (_selectedSpeechStyle == '' ||
                    item.speechStyle.contains(_selectedSpeechStyle)))
            .length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisExtent: 125,
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final data = speakerMetadata
              .where((item) =>
                  (_selectedGender == '' || item.gender == _selectedGender) &&
                  (_selectedLanguage == '' ||
                      item.language == _selectedLanguage) &&
                  (_selectedVoiceStyle == '' ||
                      item.voiceStyle == _selectedVoiceStyle) &&
                  (_selectedSpeechStyle == '' ||
                      item.speechStyle.contains(_selectedSpeechStyle)))
              .toList()[index]; ////new
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.w),
                child: GestureDetector(
                  onTap: () async {
                    String audioURL = data.audio;
                    Future<void> playAudio() async {
                      if (audioURL.isNotEmpty) {
                        if (isAudioPlaying) {
                          await audioPlayer.stop();
                        }
                        await audioPlayer.play(UrlSource(audioURL));
                        setState(() {
                          isAudioPlaying = true;
                        });
                        audioPlayer.onPlayerComplete.listen((event) {
                          setState(() {
                            isAudioPlaying = false;
                          });
                        });
                      } else {
                        setState(() {
                          isAudioPlaying = false;
                        });
                      }
                    }

                    await playAudio();
                    _selectedSpeakerId = data.speakerId;
                    setState(() {
                      if (selectedIndex.contains(index)) {
                        selectedIndex.remove(index);
                        if (audioPlayer.state == PlayerState.playing) {
                          audioPlayer.stop();
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
                              data.squareImage,
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
                                      top: 5.w,
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
                                        EdgeInsets.only(right: 5.w, top: 5.w),
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (selectedIndexFavorites
                                              .contains(data.speakerId)) {
                                            selectedIndexFavorites
                                                .remove(data.speakerId);
                                          } else {
                                            selectedIndexFavorites
                                                .add(data.speakerId);
                                          }
                                        });
                                      },
                                      child: selectedIndexFavorites
                                              .contains(data.speakerId)
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
                                            width: 16.h,
                                            height: 16.w,
                                            // color: Colors.white, //// ไม่ได้ใช้
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
                                  Expanded(
                                    child: Text(
                                      // AppDataBase.data[index].thaiName, //old
                                      data.thaiName,
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
                  if (isAudioPlaying) {
                    await audioPlayer.stop();
                  }
                  await audioPlayer.play(UrlSource(audioURL));
                  setState(() {
                    isAudioPlaying = true;
                  });
                  audioPlayer.onPlayerComplete.listen((event) {
                    setState(() {
                      isAudioPlaying = false;
                    });
                  });
                } else {
                  setState(() {
                    isAudioPlaying = false;
                  });
                }
              }

              await playAudio();
              _selectedSpeakerId = speakerMetadata.speakerId;
              setState(() {
                if (selectedIndex.contains(index)) {
                  selectedIndex.remove(index);
                  if (audioPlayer.state == PlayerState.playing) {
                    audioPlayer.stop();
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
                                top: 5.w,
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
                              padding: EdgeInsets.only(right: 5.w, top: 5.w),
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
                                      width: 16.h,
                                      height: 16.w,
                                      // color: Colors.white, //// ไม่ได้ใช้
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
                            Expanded(
                              child: Text(
                                // AppDataBase.data[index].thaiName, //old
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
        itemCount: speakerMetadata
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
          final data = speakerMetadata
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
                  audioPlayer.stop();
                  isDownloading = true;
                });
              }
              if (textController.text.isNotEmpty) {
                //TODO: Generate audio
                //_audioUrl = await Provider.of<MainServerProvider>(context)
                //    .generateAudio(textController.text);
                if (_audioUrl.isNotEmpty && _audioUrl != '') {
                  await textSave(_audioUrl);
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
