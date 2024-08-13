import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Database/newdata.dart';
import 'package:botnoivoice/Filters/all.dart';
import 'package:botnoivoice/Filters/favorite.dart';
import 'package:botnoivoice/Filters/recomman.dart';
import 'package:botnoivoice/Function/randomString.dart';
import 'package:botnoivoice/Model/models.dart';
import 'package:botnoivoice/Screens/DrawerAppBarScreen/drawer_appbar_screen.dart';
import 'package:botnoivoice/Screens/GradientScreen/gradient_button.dart';
import 'package:botnoivoice/Screens/GradientScreen/gradient_icon.dart';
import 'package:botnoivoice/Screens/GradientScreen/gradient_text.dart';
import 'package:botnoivoice/Screens/HomeScreen/select_voice_screen.dart';
import 'package:botnoivoice/Screens/HomeScreen/setting_audio_screen.dart';
import 'package:botnoivoice/Screens/WorkspaceScreen/workspace_screen.dart';
import 'package:botnoivoice/Widgets/HomeWidget/category_setting_widget.dart';
import 'package:botnoivoice/Widgets/WorkspaceWidget/workspace_appbar_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  final int maxLength = 1000;
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController textController = TextEditingController();

  // Generate Audio
  String _response = '';
  String _audioUrl = '';
  String? speakerId;
  String? language; // เลือกภาษา   new
  String? gender; ////เลือกเพศ
  String? speechStyle; /////เลือกสไตล์
  String? voiceStyle; /////เลือกหมวดหมู่
  ///new
  List<String>? availableLanguage;
  String? credits;

  // Download File
  String progress = '';
  bool isLoading = false;
  AudioPlayer audioPlayer = AudioPlayer();

  // Player Audio
  bool isAudioPlaying = false;
  List<NewData>? data;

  // Download Audio
  String selectedTypeMedia = 'mp3';

  Set<int> selectedIndex2 = <int>{};
  Set<int> selectedIndex = <int>{};
  List<String> selectedIndexFavorites = []; // เลือกเสียงที่ชอบ

  @override
  void initState() {
    super.initState();
    language = 'TH'; // หรือภาษาที่คุณต้องการให้แสดงเป็นค่าเริ่มต้น   new
    gender = ''; ///////////////////////// กำนดค่าเริ่มต้น  new
    speechStyle = ''; // สไตล์ที่คุณต้องการให้แสดงเป็นค่าเริ่มต้น  new
    voiceStyle = ''; // หมวดหมู่ที่คุณต้องการให้แสดงเป็นค่าเริ่มต้น  new
  }

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

  ///เลือกภาษา
  String selectedLanguage = 'ไทย'; ///// กำหนดค่าเริ่มต้น  new
  String selectedLanguageImage =
      'assets/logo/Ellipse 12.jpg'; ///// กำหนดรูปค่าเริ่มต้น new
  bool isExpanded = false;

  ///เลือกเพศ
  String selectedGender = 'ช/ญ'; ///// กำหนดค่าเริ่มต้น  new
  String selectedGenderImage =
      'assets/logo/Category.jpg'; ///// กำหนดรูปค่าเริ่มต้น  new
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
    final auth = Provider.of<Authentication>(context, listen: false);
    User? user = FirebaseAuth.instance.currentUser;
    String? email = auth.getUserEmail(user);

    double screenSizeheight = MediaQuery.of(context).size.height;
    // double screenSizeheightInputtextOpen = MediaQuery.of(context).size.height;

    int currentIndex = 0;
    final screenHeightOpen = 404.h; //screenSizeheightInputtextOpen;
    final maxLinesopen = (screenHeightOpen / 65).floor();
    final screenHeightClose = 404.h; //screenSizeheightInputtextOpen;
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
      drawer: DrawerAppbarScreen(
          auth: auth, email: email, screenSizeheight: screenSizeheight),
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
        backgroundColor: const Color(0xFFFFFFFF),
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
            height: _inputtext == 1
                ? 196.h //screenSizeheightInputtextClose * 0.30
                : 404.h, //screenSizeheightInputtextOpen * 0.59,
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
                              cursorColor: const Color(0xFF000000),
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
                                if (textController.text.length >
                                    widget.maxLength) {
                                  textController.text = textController.text
                                      .substring(0, widget.maxLength);
                                  textController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: textController.text.length),
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
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                    textStyle: TextStyle(
                                                        fontSize: 10.sp)),
                                                onPressed: () {
                                                  setState(() {
                                                    // _showClearIcon = false; // To update the counter
                                                  });
                                                },
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
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                    textStyle: TextStyle(
                                                        fontSize: 10.sp)),
                                                onPressed: () {
                                                  textController.clear();
                                                  setState(() {
                                                    // _showClearIcon = false; // To update the counter
                                                  });
                                                },
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
                                        text: '${textController.text.length}',
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
                                        ' / ${widget.maxLength}',
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
              color: const Color(0xFFFFFFFF),
              height: _inputtext == 1
                  ? 261.h //screenSizeheight * 0.50
                  : 261.h, //screenSizeheight * 0.26,
              child: Column(children: [
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
                    child: SelectVoiceScreen(
                        screenSizeheight: screenSizeheight,
                        selectedPageIndexVoice: _selectedPageIndexVoice)),
                if (_selectedPageIndexVoice == 1) ...[
                  categoryVoiceHome(context)
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
                  child: SettingAudioScreen(
                      screenSizeheight: screenSizeheight,
                      selectedPageIndexSetting: _selectedPageIndexSetting),
                ),
                if (_selectedPageIndexSetting == 1) ...[
                  const CategorySettingWidget()
                ],
                Expanded(
                  child: buildVoiceHome(context),
                ),
                Container(
                    height: 45.h, //screenSizeheight * 0.052.h,
                    width: 320.w,
                    color: const Color(0xFF27282B),
                    child: InkWell(
                      onTap: () {
                        debugPrint('on tapped Studio !!!');
                      },
                      child: currentIndex == 1
                          ? SvgPicture.asset(
                              'assets/logo/Property 1=studio, Property 2=deault (2).svg')
                          : SvgPicture.asset(
                              'assets/logo/Property 1=studio, Property 2=hover (1).svg'),
                    ))
              ]), // 40% of the screen height
            ),
          ),
        ],
      ),
    );
  }

  bool ishover = false;
  Widget categoryVoiceHome(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 65.h, //screenSizeheight * 0.05.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                color: const Color(0xFFFFFFFF),
                width: 480.w, // ระยะห่างเวลา Filter
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w, left: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        /// เลือกภาษา
                        onTap: () {
                          setState(() {
                            isExpanded = true;
                          });
                          showModalBottomSheet(
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return SingleChildScrollView(
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(20.w),
                                          child: Column(
                                            children: [
                                              Container(
                                                color: Colors.transparent,
                                                width: 280.w,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'ภาษา',
                                                          style: GoogleFonts
                                                              .prompt(
                                                            fontSize: 16.sp,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
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
                                                        setState),
                                                    _buildLanguageOption(
                                                        'Thai(Thailand) - ไทย',
                                                        'assets/logo/Ellipse 12.jpg',
                                                        'TH',
                                                        context,
                                                        setState),
                                                    _buildLanguageOption(
                                                        'English (UK) - อังกฤษ',
                                                        'assets/logo/Ellipse 13.jpg',
                                                        'EN',
                                                        context,
                                                        setState),
                                                    _buildLanguageOption(
                                                        'Indonesia - อินโดนีเซีย',
                                                        'assets/logo/Ellipse 13 (2).jpg',
                                                        'ID',
                                                        context,
                                                        setState),
                                                    _buildLanguageOption(
                                                        'Japanese - ญี่ปุ่น',
                                                        'assets/logo/Ellipse 14.jpg',
                                                        'JA',
                                                        context,
                                                        setState),
                                                    _buildLanguageOption(
                                                        'Laos - ลาว',
                                                        'assets/logo/Ellipse 15.jpg',
                                                        'LO',
                                                        context,
                                                        setState),
                                                    _buildLanguageOption(
                                                        'Myanmar - เมียนมาร์',
                                                        'assets/logo/Ellipse 11.jpg',
                                                        'MY',
                                                        context,
                                                        setState),
                                                    _buildLanguageOption(
                                                        'Vietnam - เวียดนาม',
                                                        'assets/logo/Ellipse 19.jpg',
                                                        'VI',
                                                        context,
                                                        setState),
                                                    _buildLanguageOption(
                                                        'Chinese (Simplified) - จีน',
                                                        'assets/logo/Ellipse 18.jpg',
                                                        'ZH',
                                                        context,
                                                        setState),
                                                    _buildLanguageOption(
                                                        'Cambodia - กัมพูชา',
                                                        'assets/logo/images (1).png',
                                                        'KM',
                                                        context,
                                                        setState),
                                                    _buildLanguageOption(
                                                        'Phillippines - ฟิลิปปินส์',
                                                        'assets/logo/Flag_of_the_Philippines.svg.png',
                                                        'FIL',
                                                        context,
                                                        setState),
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
                          ).whenComplete(() {
                            setState(() {
                              isExpanded = false;
                            });
                          });
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
                                selectedLanguageImage,
                                width: 14.w,
                                height: 14.h,
                              ),
                              SizedBox(width: 3.w),
                              Flexible(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    selectedLanguage,
                                    style: GoogleFonts.prompt(fontSize: 12.sp),
                                  ),
                                ),
                              ),
                              Icon(
                                isExpanded
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
                        ///////// เลือกเพศ
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
                                                _buildGenderOption(
                                                    'ช/ญ',
                                                    'assets/logo/Category.jpg',
                                                    '',
                                                    context,
                                                    setState),
                                                _buildGenderOption(
                                                    'หญิง',
                                                    'assets/logo/Category (1).jpg',
                                                    'ผู้หญิง',
                                                    context,
                                                    setState),
                                                _buildGenderOption(
                                                    'ชาย',
                                                    'assets/logo/Category (2).jpg',
                                                    'ผู้ชาย',
                                                    context,
                                                    setState)
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
                              changeIcon = false;
                            });
                          });
                        },
                        child: Container(
                          width: 62.w,
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 3.w),
                                  if (gender ==
                                      '') //////////////////// text แสดงในปุ่มกด
                                    Text(
                                      'ช/ญ',
                                      style: GoogleFonts.prompt(
                                        fontSize: 12.sp,
                                      ),
                                    ),
                                  if (gender.toString() !=
                                      '') // ตรวจสอบว่า selectedGender ไม่เป็นค่าว่าง
                                    Text(
                                      selectedGender,
                                      style: GoogleFonts.prompt(
                                        fontSize: 12.sp,
                                      ),
                                    ), //////////////////// text แสดงในปุ่มกด
                                  changeIcon
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

                      /// ปุ่มแนะนำ
                      const Recommand(),

                      /// ปุ่มหัวใจ
                      InkWell(
                        onTap: () {
                          setState(() {
                            ishover = !ishover;
                          });
                        },
                        child: Favorite(
                          ishover: ishover,
                        ),
                      ),

                      /// ปุ่มทั้งหมด
                      const All(),

                      /// ปุ่มสไตล์
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
                                                          voiceStyle =
                                                              selectStyle1
                                                                  ? 'เสียงน่ารัก'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        print(
                                                            'Selected voice: น่ารัก, voice: $voiceStyle');
                                                      },
                                                      child: filterStyle(
                                                          'น่ารัก',
                                                          selectStyle1),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle2 =
                                                              !selectStyle2;
                                                          voiceStyle =
                                                              selectStyle2
                                                                  ? 'เสียงมั่นใจ'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        print(
                                                            'Selected voice: มั่นใจ, voice: $voiceStyle');
                                                      },
                                                      child: filterStyle(
                                                          'มั่นใจ',
                                                          selectStyle2),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle3 =
                                                              !selectStyle3;
                                                          voiceStyle = selectStyle3
                                                              ? 'เสียงน่าเชื่อถือ'
                                                              : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        print(
                                                            'Selected voice: น่าเชื่อถือ, voice: $voiceStyle');
                                                      },
                                                      child: filterStyle(
                                                          'น่าเชื่อถือ',
                                                          selectStyle3),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle4 =
                                                              !selectStyle4;
                                                          voiceStyle = selectStyle4
                                                              ? 'เสียงตื่นเต้น'
                                                              : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        print(
                                                            'Selected voice: ตื่นเต้น, voice: $voiceStyle');
                                                      },
                                                      child: filterStyle(
                                                          'ตื่นเต้น',
                                                          selectStyle4),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle5 =
                                                              !selectStyle5;
                                                          voiceStyle =
                                                              selectStyle5
                                                                  ? 'เสียงจริงจัง'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        print(
                                                            'Selected voice: จริงจัง, voice: $voiceStyle');
                                                      },
                                                      child: filterStyle(
                                                          'จริงจัง',
                                                          selectStyle5),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle6 =
                                                              !selectStyle6;
                                                          voiceStyle =
                                                              selectStyle6
                                                                  ? 'เสียงหวาน'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        print(
                                                            'Selected voice: หวาน, voice: $voiceStyle');
                                                      },
                                                      child: filterStyle(
                                                          'หวาน', selectStyle6),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle7 =
                                                              !selectStyle7;
                                                          voiceStyle =
                                                              selectStyle7
                                                                  ? 'เสียงอบอุ่น'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        print(
                                                            'Selected voice: อบอุ่น, voice: $voiceStyle');
                                                      },
                                                      child: filterStyle(
                                                          'อบอุ่น',
                                                          selectStyle7),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle8 =
                                                              !selectStyle8;
                                                          voiceStyle =
                                                              selectStyle8
                                                                  ? 'เสียงขี้เล่น'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        print(
                                                            'Selected voice: ขี้เล่น, voice: $voiceStyle');
                                                      },
                                                      child: filterStyle(
                                                          'ขี้เล่น',
                                                          selectStyle8),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle9 =
                                                              !selectStyle9;
                                                          voiceStyle =
                                                              selectStyle9
                                                                  ? 'เสียงทุ้ม'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        print(
                                                            'Selected voice: ทุ้ม, voice: $voiceStyle');
                                                      },
                                                      child: filterStyle(
                                                          'ทุ้ม', selectStyle9),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle10 =
                                                              !selectStyle10;
                                                          voiceStyle =
                                                              selectStyle10
                                                                  ? 'เสียงนุ่มนวล'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        print(
                                                            'Selected voice: นุ่มนวล, voice: $voiceStyle');
                                                      },
                                                      child: filterStyle(
                                                          'นุ่มนวล',
                                                          selectStyle10),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle11 =
                                                              !selectStyle11;
                                                          voiceStyle =
                                                              selectStyle11
                                                                  ? 'เสียงท้องถิ่น'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        print(
                                                            'Selected voice: ท้องถิ่น, voice: $voiceStyle');
                                                      },
                                                      child: filterStyle(
                                                          'ท้องถิ่น',
                                                          selectStyle11),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle12 =
                                                              !selectStyle12;
                                                          voiceStyle =
                                                              selectStyle12
                                                                  ? 'เสียงใจเย็น'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        print(
                                                            'Selected voice: ใจเย็น, voice: $voiceStyle');
                                                      },
                                                      child: filterStyle(
                                                          'ใจเย็น',
                                                          selectStyle12),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle13 =
                                                              !selectStyle13;
                                                          voiceStyle =
                                                              selectStyle13
                                                                  ? 'เสียงนิ่มนวล'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        print(
                                                            'Selected voice: นิ่มนวล, voice: $voiceStyle');
                                                      },
                                                      child: filterStyle(
                                                          'นิ่มนวล',
                                                          selectStyle13),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle14 =
                                                              !selectStyle14;
                                                          voiceStyle =
                                                              selectStyle14
                                                                  ? 'เสียงชัดเจน'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        print(
                                                            'Selected voice: ชัดเจน, voice: $voiceStyle');
                                                      },
                                                      child: filterStyle(
                                                          'ชัดเจน',
                                                          selectStyle14),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle15 =
                                                              !selectStyle15;
                                                          voiceStyle =
                                                              selectStyle15
                                                                  ? 'เสียงเหนือ'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        print(
                                                            'Selected voice: เหนือ, voice: $voiceStyle');
                                                      },
                                                      child: filterStyle(
                                                          'เหนือ',
                                                          selectStyle15),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectStyle16 =
                                                              !selectStyle16;
                                                          voiceStyle =
                                                              selectStyle16
                                                                  ? 'เสียงอีสาน'
                                                                  : '';
                                                          Navigator.pop(
                                                              context);
                                                        });
                                                        print(
                                                            'Selected voice: อีสาน, voice: $voiceStyle');
                                                      },
                                                      child: filterStyle(
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.r)),
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
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'สไตล์',
                                        style:
                                            GoogleFonts.prompt(fontSize: 12.sp),
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    selectStyle
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
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory1 =
                                                              !selectCategory1;
                                                          speechStyle = selectCategory1
                                                              ? 'สไตล์เล่าเรื่อง'
                                                                  'สไตล์อ่านข่าว'
                                                              : '';
                                                        });
                                                        Navigator.pop(context);
                                                        print(
                                                            'Selected category: เล่าเรื่อง, category: $speechStyle');
                                                      },
                                                      child: filterStyle(
                                                          'เล่าเรื่อง',
                                                          selectCategory1),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory2 =
                                                              !selectCategory2;
                                                          speechStyle = selectCategory2
                                                              ? 'สไตล์อ่านข่าว'
                                                                  'สไตล์เล่าเรื่อง'
                                                              : '';
                                                        });
                                                        Navigator.pop(context);
                                                        print(
                                                            'Selected category: อ่านข่าว, category: $speechStyle');
                                                      },
                                                      child: filterStyle(
                                                          'อ่านข่าว',
                                                          selectCategory2),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory3 =
                                                              !selectCategory3;
                                                          speechStyle = selectCategory3
                                                              ? 'สไตล์เล่าเรื่อง'
                                                                  'สไตล์ตัวละคร'
                                                              : '';
                                                        });
                                                        Navigator.pop(context);
                                                        print(
                                                            'Selected category: ตัวละคร, category: $speechStyle');
                                                      },
                                                      child: filterStyle(
                                                          'ตัวละคร',
                                                          selectCategory3),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory4 =
                                                              !selectCategory4;
                                                          speechStyle =
                                                              selectCategory4
                                                                  ? 'สไตล์บรรยาย'
                                                                      'สไตล์ตัวละคร'
                                                                  : '';
                                                        });
                                                        Navigator.pop(context);
                                                        print(
                                                            'Selected category: บรรยาย, category: $speechStyle');
                                                      },
                                                      child: filterStyle(
                                                          'บรรยาย',
                                                          selectCategory4),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory5 =
                                                              !selectCategory5;
                                                          speechStyle = selectCategory5
                                                              ? 'สไตล์อ่านข่าว'
                                                                  'สไตล์สปอตโฆษณา'
                                                              : '';
                                                        });
                                                        Navigator.pop(context);
                                                        print(
                                                            'Selected category: สปอตโฆษณา, category: $speechStyle');
                                                      },
                                                      child: filterStyle(
                                                          'สปอตโฆษณา',
                                                          selectCategory5),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory6 =
                                                              !selectCategory6;
                                                          speechStyle =
                                                              selectCategory6
                                                                  ? 'สไตล์สารคดี'
                                                                      'สไตล์บรรยาย'
                                                                  : '';
                                                        });
                                                        Navigator.pop(context);
                                                        print(
                                                            'Selected category: สารคดี, category: $speechStyle');
                                                      },
                                                      child: filterStyle(
                                                          'สารคดี',
                                                          selectCategory6),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory7 =
                                                              !selectCategory7;
                                                          speechStyle =
                                                              selectCategory7
                                                                  ? 'สไตล์ตัวละคร'
                                                                      'สไตล์อนิเมะ'
                                                                  : '';
                                                        });
                                                        Navigator.pop(context);
                                                        print(
                                                            'Selected category: อนิเมะ, category: $speechStyle');
                                                      },
                                                      child: filterStyle(
                                                          'อนิเมะ',
                                                          selectCategory7),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory8 =
                                                              !selectCategory8;
                                                          speechStyle =
                                                              selectCategory8
                                                                  ? 'สไตล์บรรยาย'
                                                                      'สไตล์อาจารย์'
                                                                  : '';
                                                        });
                                                        Navigator.pop(context);
                                                        print(
                                                            'Selected category: อาจารย์, category: $speechStyle');
                                                      },
                                                      child: filterStyle(
                                                          'อาจารย์',
                                                          selectCategory8),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory9 =
                                                              !selectCategory9;
                                                          speechStyle = selectCategory9
                                                              ? 'สไตล์เล่าเรื่อง'
                                                                  'สไตล์ท้องถิ่น'
                                                              : '';
                                                        });
                                                        Navigator.pop(context);
                                                        print(
                                                            'Selected category: ท้องถิ่น, category: $speechStyle');
                                                      },
                                                      child: filterStyle(
                                                          'ท้องถิ่น',
                                                          selectCategory9),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        setModalState(() {
                                                          selectCategory10 =
                                                              !selectCategory10;
                                                          speechStyle =
                                                              selectCategory10
                                                                  ? 'สไตล์อ่านข่าว'
                                                                      'สไตล์เสียงต่างประเทศ'
                                                                  : '';
                                                        });
                                                        Navigator.pop(context);
                                                        print(
                                                            'Selected category: เสียงต่างประเทศ, category: $speechStyle'); // Print to debug console
                                                      },
                                                      child: filterStyle(
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
                            borderRadius:
                                BorderRadius.all(Radius.circular(4.r)),
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
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        'หมวดหมู่',
                                        style:
                                            GoogleFonts.prompt(fontSize: 12.sp),
                                      ),
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
          //////////////พื้นหลัง widget voice
          // color: Colors.amber,
          color: const Color(0xFFFFFFFF),
          height: 148.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ishover
                  ? voiceWidgetFavorite(
                      context, ///// เลือกเสียงที่ชอบ
                    )
                  : voiceWidGetHome(context), ///// หน้าเลือกเสียงหลัก
            ],
          ),
        ),
      ],
    );
  }

  Widget filterStyle(String text, bool isSelected) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 8.w, vertical: 4.h), // ปรับ padding ให้เล็กลง
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
                )
              : null,
          borderRadius: BorderRadius.all(Radius.circular(4.r)),
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
              color: isSelected
                  ? const Color(0xFFFFFFFF)
                  : const Color(0xFF323130),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String text, String imagePath, String lang,
      BuildContext context, StateSetter setState) {
    return InkWell(
      onTap: () {
        setState(() {
          if (text == 'ทั้งหมด') {
            language = ''; // กำหนดค่าเป็นว่างเพื่อให้แสดงทุกเพศ
          } else {
            List<String> parts = text.split(' - ');
            if (parts.length > 1) {
              selectedLanguage = parts[1];
            } else {
              selectedLanguage = text; // กรณีที่ไม่มีตัวแบ่งให้ใช้ค่าเดิม
            }
            selectedLanguageImage = imagePath;
            language = lang; // Update the language variable
          }
        });
        print(
            'Selected Language: $selectedLanguage, language: $language'); // Print to debug console
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.only(left: 10.w),
        height: 42.h,
        width: 320.w,
        color: const Color(0xFFFFFFFF),
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
                    fontWeight: selectedLanguage ==
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
      String text,
      String imagePath,
      String gen, ///// เลือกเพศ
      BuildContext context,
      StateSetter setState) {
    return InkWell(
      onTap: () {
        setState(() {
          if (text == 'ช/ญ') {
            gender = ''; // กำหนดค่าเป็นว่างเพื่อให้แสดงทุกเพศ
          } else {
            selectedGender = text;
            selectedGenderImage = imagePath;
            gender = gen;
          }
        });

        print(
            'Selected Gender: $selectedGender Gender: $gender'); // Print to debug console
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.only(left: 10.w),
        height: 42.h,
        width: 320.w,
        color: const Color(0xFFFFFFFF),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.asset(
              imagePath,
              width: 23.w,
              height: 23.h,
            ),
            SizedBox(width: 20.w),
            Text(
              text,
              style: GoogleFonts.prompt(
                fontSize: 14.sp,
                fontWeight: selectedGender == text
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget voiceWidGetHome(BuildContext context) {
    return SizedBox(
      height: 127.h,
      width: 320.w,
      child: GridView.builder(
        itemCount: NewAppDataBase.data
            .where((item) =>
                (gender == '' || item.gender == gender) &&
                (language == '' || item.language == language) &&
                (voiceStyle == '' || item.voiceStyle == voiceStyle) &&
                (speechStyle == '' || item.speechStyle == speechStyle))
            .length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisExtent: 125,
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final data = NewAppDataBase.data
              .where((item) =>
                  (gender == '' || item.gender == gender) &&
                  (language == '' || item.language == language) &&
                  (voiceStyle == '' || item.voiceStyle == voiceStyle) &&
                  (speechStyle == '' || item.speechStyle == speechStyle))
              .toList()[index];
          return voicewidget(data, index);
        },
      ),
    );
  }

  Column voicewidget(NewData data, int index) {
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
                    await audioPlayer
                        .stop(); // ถ้ามีการเล่นเสียงอยู่ ให้หยุดก่อน
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
              speakerId = data.speakerId;
              print("-> speakerId: $speakerId");
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
                        data.squareImage,
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10.r,
                        spreadRadius: 1.r,
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
                                  right: 5.w, top: 5.h, left: 5.w),
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
                                  debugPrint(
                                      '// 1874 -> speakerId ' '$speakerId');

                                  setState(() {
                                    if (selectedIndexFavorites
                                        .contains(data.speakerId)) {
                                      selectedIndexFavorites
                                          .remove(data.speakerId);
                                    } else {
                                      selectedIndexFavorites
                                          .add(data.speakerId);
                                      print(
                                          "selectedIndexFavorites: $selectedIndexFavorites");
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
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'assets/logo/Vector (1).svg',
                                    width: 16.w,
                                    height: 16.h,
                                  ),
                            SizedBox(width: 3.w),
                            Expanded(
                                child: Text(
                              data.thaiName,
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

  Widget voiceWidgetFavorite(BuildContext context) {
    return SizedBox(
      height: 127.h,
      width: 320.w,
      child: GridView.builder(
        itemCount: NewAppDataBase.data
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
          final data = NewAppDataBase.data
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
          padding: EdgeInsets.only(left: 20.w, top: 10.h, right: 20.w, bottom: 10.h),
          child: GradientButton(
            text: 'สร้างเสียง',
            onPressed: () async {
              debugPrint('START DO สร้างเสียง');
              if (textController.text.isNotEmpty) {
                setState(() {
                  audioPlayer.stop();
                  isLoading = true;
                });
              }
              if (textController.text.isNotEmpty) {
                _audioUrl = await generateAudio(textController.text);
                print('printing audiourl $_audioUrl');
                var tempText = textController.text;
                print('printing audiourl $tempText');
                if (_audioUrl.isNotEmpty && _audioUrl != '') {
                  print("In the loops $tempText");
                  await textSave(textController.text, _audioUrl);
                }
              }
              print('END DO สร้างเสียง');
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

  Future<String> generateAudio(String text) async {
    setState(() {
      isLoading = true;
      _audioUrl = '';
    });

    final auth = Provider.of<Authentication>(context, listen: false);

    String url = "https://api-voice.botnoi.ai/openapi/v1/generate_audio";
    Map<String, dynamic> payload = {
      "text": text,
      "speaker": speakerId,
      "volume": 1,
      "speed": 1,
      "type_media": selectedTypeMedia,
      "save_file": true,
    };

    Map<String, String> headers = {
      'Botnoi-Token': '${auth.credentialsToken}',
      'Content-Type': 'application/json'
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          _audioUrl = jsonData['audio_url'];
          print("generateAudio -> _audioUrl: $_audioUrl");

          isLoading = false;
        });
      } else if (response.statusCode == 403) {
        print("generateAudio -> response:${response.statusCode}");
        setState(() {
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        print("generateAudio -> response:${response.statusCode}");
        print("not enough credits");
      } else {
        setState(() {
          isLoading = false;
          auth.signOut();
        });
      }
    } catch (e) {
      setState(() {
        print("generateAudio -> response:$e");
        isLoading = false;
      });
    }
    return _audioUrl;
  }

  Future<void> textSave(String text, String audioUrl) async {
    final auth = Provider.of<Authentication>(context, listen: false);
    print('Printing auth when generating ${auth.credentialsToken}');

    // Define the new WorkSpace object
    WorkSpace newWorkSpace = WorkSpace(
      text: textController.text,
      speaker: int.parse(speakerId!),
      audioId: '',
      speed: '1',
      statusDownload: true,
      url: audioUrl,
      volume: '1',
    );

    // Fetch existing workspaces for the project
    await auth.getAllWorkspace();
    if (auth.listProjects.isNotEmpty) {
      // Assuming you are working with the first project (adjust index as needed)
      ListProject project = auth.listProjects[0];
      print('Project ID: ${project.workspaceId}');
      print('Existing WorkSpaces: ${project.workSpaces.length}');

      // Create a new list from existing workspaces
      List<WorkSpace> existingWorkSpaces =
          List<WorkSpace>.from(project.workSpaces);
      print('Existing WorkSpaces (copied): ${existingWorkSpaces.length}');

      // Add the new workspace to the existing workspaces
      existingWorkSpaces.add(newWorkSpace);
      print(
          'New WorkSpace added. Total WorkSpaces: ${existingWorkSpaces.length}');

      // Update the workspaces with the new list
      await auth.updateWorkSpaces(project.workspaceId, existingWorkSpaces);
    } else {
      print('No projects found.');
    }

    if (mounted) {
      setState(() {
        print('New workspace added.');
      });
    }
  }

  Future<void> downloadFile() async {
    if (Platform.isAndroid) {
      await _androidDownloadFunction();
    } else if (Platform.isIOS) {
      await _iOSDownloadFunction();
    }
  }

  Future<void> _iOSDownloadFunction() async {
    try {
      String url = _audioUrl;

      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String filename = "BotnoiVoice${randomString(6)}.$selectedTypeMedia";
        var tempDir = await getTemporaryDirectory();
        var path = '${tempDir.path}/$filename';
        var file = File(path);
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          progress = 'Download complete';
        });
        print("Printing Path: ");
        print(tempDir);
        print(path);
        print(file);

        // OpenFile.open(path);

        /*
          WARNING!!! น้องภัทร ช่วย ทดสอบ OpenAppFile บน iOS ให้ด้วยนะ
        */
        OpenAppFile.open(path);
      } else {
        setState(() {
          progress = 'Failed to download file';
        });
      }
    } catch (e) {
      setState(() {
        progress = 'Error: $e';
      });
    }
  }

  Future<void> _androidDownloadFunction() async {
    try {
      var filename = "BotnoiVoice${randomString(6)}.$selectedTypeMedia";

      // Get the download directory
      List<Directory>? directories =
          await getExternalStorageDirectories(type: StorageDirectory.downloads);
      if (directories == null || directories.isEmpty) {
        throw Exception('No external storage directories found');
      }

      // Create the full path by appending the filename to the directory path
      String directoryPath = directories.first.path;
      String filePath = "$directoryPath/$filename";

      // Create the file object
      var file = File(filePath);

      // Download the file from the URL
      String url = _audioUrl;
      var res = await http.get(Uri.parse(url));

      // Check if the request was successful
      if (res.statusCode == 200) {
        // Write the downloaded bytes to the file
        await file.writeAsBytes(res.bodyBytes);
        print('Download successful: $filename');

        setState(() {
          progress = 'Download complete';
        });

        print("Printing Path: ");
        print(filename);
        print(filePath);
        print(file);
        OpenAppFile.open(filePath);
      } else {
        print('Failed to download file: ${res.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
}
