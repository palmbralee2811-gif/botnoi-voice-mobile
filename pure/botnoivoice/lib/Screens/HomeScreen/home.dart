import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Database/data.dart';
import 'package:botnoivoice/Database/newdata.dart';
// import 'package:botnoivoice/Filters/advert.dart';   ยังไม่ได้ใช้
import 'package:botnoivoice/Filters/all.dart';
import 'package:botnoivoice/Filters/favorite.dart';
// import 'package:botnoivoice/Filters/new.dart';  ยังไม่ได้ใช้
// import 'package:botnoivoice/Filters/podcast.dart';  ยังไม่ได้ใช้
import 'package:botnoivoice/Filters/recomman.dart';
// import 'package:botnoivoice/Filters/voice.dart';   ยังไม่ได้ใช้
import 'package:botnoivoice/Function/randomString.dart';
import 'package:botnoivoice/Screens/HomeScreen/gradient_icon_home.dart';
import 'package:botnoivoice/Screens/HomeScreen/gradientbuttom.dart';
import 'package:botnoivoice/Screens/HomeScreen/setting.dart';
import 'package:botnoivoice/Widgets/CategorySetting.dart';
// import 'package:botnoivoice/Widgets/favoritevoice.dart';     /////ไม่ได้ใช้   old
// import 'package:botnoivoice/filters/languagedrawer.dart';
// import 'package:botnoivoice/widgets/CategorySetting.dart';
// import 'package:botnoivoice/widgets/CategorySetting.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'drawer_app_bar.dart';
// import 'gradient_icon_home.dart';
import 'gradient_text_home.dart';
import 'selectvoice.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  final int maxLength = 1000;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController textController = TextEditingController();

  // Generate Audio
  String _response = '';
  String _audioUrl = '';
  String? speakerId;
  String? language; // เลือกภาษา   new
  String? gender; ////เลือกเพศ
  String? speechStyle; /////เลือกสไตล์
  String? voiceStyle; /////เลือกหมวดหมู่

  /// เลือกเพศ  new

  ///new
  List<String>? availableLanguage;
  String? credits;

  // Download File
  String progress = '';
  bool isLoading = false;
  AudioPlayer audioPlayer = AudioPlayer();

  // Player Audio
  bool isAudioPlaying = false;
  List<Data>? data;

  // Download Audio
  String selectedTypeMedia = 'mp3';
  // final List<String> _typeMedia = ['wav', 'mp3', 'm4a'];

  Set<int> selectedIndex2 = <int>{};
  Set<int> selectedIndex = <int>{};
  List<String> selectedIndexFavorites = []; /////เลือกเสียงที่ชอบ  new

  // final List<Data> _favoriteVoice = [];

  // void _toggleVoiceFavorite(Data data) {
  //   final isExist = _favoriteVoice.contains(data);

  //   if (isExist) {
  //     _favoriteVoice.remove(data);
  //   } else {
  //     _favoriteVoice.add(data);
  //   }
  // }
  @override
  void initState() {
    super.initState();
    // Initialize language and other variables
    language = 'TH'; // หรือภาษาที่คุณต้องการให้แสดงเป็นค่าเริ่มต้น   new
    gender = ''; ///////////////////////// กำนดค่าเริ่มต้น  new

    speechStyle = ''; // สไตล์ที่คุณต้องการให้แสดงเป็นค่าเริ่มต้น  new

    voiceStyle = ''; // หมวดหมู่ที่คุณต้องการให้แสดงเป็นค่าเริ่มต้น  new

    /// กำหนดค่าเป็นว่างเพื่อให้แสดงทุกเพศ

    // Initialize other variables here...
  } ////////new/////

  // @override
  // void initState() {
  //   super.initState();
  // }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  int _selectedPageIndexVoice = 0;
  int _selectedPageIndexSetting = 0;
  int _inputtext = 0;
  // int _button = 0;

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

    // แสดง email ผู้ใช้งาน ปัจจุบัน
    User? user = FirebaseAuth.instance.currentUser;
    String? email = auth.getUserEmail(user);

    // final user = FirebaseAuth.instance.currentUser;
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;

    double screenSizeheightInputtextOpen = MediaQuery.of(context).size.height;
    double screenSizeheightInputtextClose = MediaQuery.of(context).size.height;
    int currentIndex = 0;
    final screenHeightOpen = screenSizeheightInputtextOpen;
    final maxLinesopen = (screenHeightOpen / 65).floor();
    final screenHeightClose = screenSizeheightInputtextOpen;
    final maxLinesclose = (screenHeightClose / 180).floor();
    bool _showClearIcon = false;

    if (_selectedPageIndexVoice == 1) {
      _inputtext = 1;
      // _button = 1;
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
      drawer: DrawerAppBar(
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
        // backgroundColor: Colors.black,
        title: appBar(context, auth.credits ?? 'N/A'),
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
                  // Expanded(
                  //   child: Container(
                  //     width: 288.w,
                  //     decoration: BoxDecoration(
                  //       boxShadow: const [
                  //         BoxShadow(
                  //           color: Colors.grey,
                  //           blurRadius: 5.0,
                  //         ),
                  //       ],
                  //       color: Colors.white,
                  //       borderRadius: BorderRadius.circular(14.r),
                  //     ),
                  //     child: Padding(
                  //       padding:
                  //           EdgeInsets.only(left: 25.w, right: 10.w, top: 20.w),
                  //       child: Column(
                  //         children: [
                  //           TextField(
                  //             cursorColor: const Color(0xFF000000),
                  //             style: GoogleFonts.prompt(
                  //                 fontSize: 14.sp,
                  //                 color: const Color(0xFF323130)),
                  //             minLines: _inputtext == 1
                  //                 ? maxLinesclose
                  //                 : maxLinesopen,
                  //             maxLines: _inputtext == 1
                  //                 ? maxLinesclose
                  //                 : maxLinesopen,
                  //             keyboardType: TextInputType.multiline,
                  //             controller: textController,
                  //             onChanged: (text) {
                  //               if (textController.text.length >
                  //                   widget.maxLength) {
                  //                 textController.text = textController.text
                  //                     .substring(0, widget.maxLength);
                  //                 textController.selection =
                  //                     TextSelection.fromPosition(
                  //                   TextPosition(
                  //                       offset: textController.text.length),
                  //                 );
                  //               }
                  //               setState(() {
                  //                 _showClearIcon =
                  //                     textController.text.isNotEmpty;
                  //               });
                  //             },
                  //             decoration: InputDecoration(
                  //               border: InputBorder.none,
                  //               hintText:
                  //                   'พิมพ์ข้อความให้ตรงกับภาษาที่เลือก . . .',
                  //               hintStyle: TextStyle(
                  //                 color: const Color(0xFFA19F9D),
                  //                 fontStyle: GoogleFonts.prompt(fontSize: 14.sp)
                  //                     .fontStyle,
                  //               ),
                  //               hintMaxLines: 1,
                  //             ),
                  //           ),
                  //           Padding(
                  //             padding: EdgeInsets.only(right: 25.w),
                  //             child: Row(
                  //               mainAxisAlignment:
                  //                   MainAxisAlignment.spaceBetween,
                  //               children: [
                  //                 Column(
                  //                   mainAxisSize: MainAxisSize.min,
                  //                   children: [
                  //                     _showClearIcon ==
                  //                             textController.text.isNotEmpty
                  //                         ? Padding(
                  //                             padding:
                  //                                 EdgeInsets.only(right: 1.w),
                  //                             child: TextButton(
                  //                                 style: TextButton.styleFrom(
                  //                                   textStyle: TextStyle(
                  //                                       fontSize: 10.sp),
                  //                                 ),
                  //                                 onPressed: () {
                  //                                   setState(() {
                  //                                     // _showClearIcon =
                  //                                     //     false; // To update the counter
                  //                                   });
                  //                                 },
                  //                                 child: Icon(
                  //                                   Icons.close_sharp,
                  //                                   size: 20.sp,
                  //                                   color: Colors.transparent,
                  //                                 )),
                  //                           )
                  //                         : Padding(
                  //                             padding:
                  //                                 EdgeInsets.only(right: 1.w),
                  //                             child: TextButton(
                  //                               style: TextButton.styleFrom(
                  //                                 textStyle: TextStyle(
                  //                                     fontSize: 10.sp),
                  //                               ),
                  //                               onPressed: () {
                  //                                 textController.clear();
                  //                                 setState(() {
                  //                                   // _showClearIcon =
                  //                                   //     false; // To update the counter
                  //                                 });
                  //                               },
                  //                               child: GradientIconHome(
                  //                                 icon: Icons.close_sharp,
                  //                                 size: 20.sp,
                  //                                 gradient:
                  //                                     const LinearGradient(
                  //                                   colors: [
                  //                                     Color(0xFF9340FF),
                  //                                     Color(0xFF34BDFA)
                  //                                   ],
                  //                                   begin: Alignment.topLeft,
                  //                                   end: Alignment.bottomRight,
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                           )
                  //                   ],
                  //                 ),
                  //                 Row(
                  //                   children: [
                  //                     GradientTextHome(
                  //                       text: '${textController.text.length}',
                  //                       style: GoogleFonts.prompt(
                  //                         fontSize: 14.sp,
                  //                         color: const Color(0xFFA19F9D),
                  //                       ),
                  //                       gradient: const LinearGradient(
                  //                         colors: [
                  //                           Color(0xFF9340FF),
                  //                           Color(0xFF34BDFA)
                  //                         ],
                  //                       ),
                  //                     ),
                  //                     Text(
                  //                       ' / ${widget.maxLength}',
                  //                       style: GoogleFonts.prompt(
                  //                         fontSize: 14.sp,
                  //                         color: const Color(0xFFA19F9D),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),

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
                                  _showClearIcon =
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
                                      _showClearIcon
                                          ? Padding(
                                              padding:
                                                  EdgeInsets.only(right: 1.w),
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  textStyle: TextStyle(
                                                      fontSize: 10.sp),
                                                ),
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
                                                      fontSize: 10.sp),
                                                ),
                                                onPressed: () {
                                                  textController.clear();
                                                  setState(() {
                                                    // _showClearIcon = false; // To update the counter
                                                  });
                                                },
                                                child: GradientIconHome(
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
                                      GradientTextHome(
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
                  ? screenSizeheight * 0.50
                  : screenSizeheight * 0.26,
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
                    child: Selectvoice(
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
                  child: Setting(
                      screenSizeheight: screenSizeheight,
                      selectedPageIndexSetting: _selectedPageIndexSetting),
                ),
                if (_selectedPageIndexSetting == 1) ...[
                  const CategorySetting()
                ],
                Expanded(
                  child:
                      // InkWell(
                      //   onTap: () async {
                      //     // await generateAudio(textController.text).then((_) {
                      //     //   print('response $_response');
                      //     //   downloadFile();
                      //     //   print('progress -> downloadFile(): $progress \n');
                      //     // });

                      //     setState(() {
                      //       if (textController.text.isNotEmpty) {
                      //         audioPlayer.stop();
                      //       }
                      //     });
                      //     if (!isLoading) {
                      //       if (textController.text.isNotEmpty) {
                      //         generateAudio(textController.text).then((_) {
                      //           print('response $_response');
                      //           downloadFile();
                      //           print('progress -> downloadFile(): $progress \n');

                      //           setState(() {
                      //             // อัพเดตค่า credits หลังจากการทำงานเสร็จสิ้น
                      //             final auth = Provider.of<Authentication>(context,
                      //                 listen: false);
                      //             int creditsInt = int.parse(auth.credits ?? '0');
                      //             creditsInt -= textController.text.length;
                      //             auth.credits = creditsInt.toString();
                      //           });
                      //         });

                      //         setState(() {
                      //           isLoading = false;
                      //         });

                      //         ///เรียกใช้ฟังก์ชัน appBar และเปลี่ยนค่าใน credits ที่แสดงผล
                      //         appBar(
                      //             context, textController.text.length.toString());
                      //         ////////////////////////////////////////////////
                      //       }
                      //     }

                      //     print("\n### END generateAudio -> Line 410 ### \n");
                      //   },
                      //   child: buildVoiceHome(context),
                      // ),
                      buildVoiceHome(context),
                ),
                Container(
                    height: screenSizeheight * 0.052.h,
                    width: 320.w,
                    color: const Color(0xFF27282B),
                    child: InkWell(
                      onTap: () {},
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

  Widget appBar(BuildContext context, String text) {
    // Widget appBar(BuildContext context) {
    /////รับค่า text มาใช้คำนวณ
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: ClipOval(
                  child: Image.asset(
                    'assets/logo/App_Icon.png',
                    width: 35.w,
                    height: 35.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 224, 221, 221),
                                blurRadius: 3.0,
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(width: 5.w),
                              SizedBox(
                                height: 25.h,
                                width: 20.h,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/logo/point.png',
                                        width: 20.w,
                                        height: 20.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  // Text(
                                  //   ' ${credits ?? " N/A"}',
                                  //   style: GoogleFonts.prompt(
                                  //     fontSize: 12.sp,
                                  //     fontWeight: FontWeight.w600,
                                  //     color: const Color(0xFF323130),
                                  //   ),
                                  // ),
                                  ////อันเก่าเปลี่ยนเป็น Consumer
                                  Consumer<Authentication>(
                                      builder: (context, auth, child) {
                                    int creditsInt =
                                        int.parse(auth.credits ?? '0');
                                    creditsInt -= text.length;
                                    // creditsInt -= textController.text.length;
                                    String updatedCredits =
                                        creditsInt.toString();
                                    print('updatecredits: $updatedCredits');
                                    return Text(
                                      updatedCredits,
                                      style: GoogleFonts.prompt(
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF323130),
                                      ),
                                    );
                                  }),
                                  ////////////////////////////////
                                ],
                              ),
                              SizedBox(width: 5.w),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  bool ishover = false;
  Widget categoryVoiceHome(BuildContext context) {
    // double screenSizewidth = MediaQuery.of(context).size.width;   ///// ไม่ได้ใช้
    double screenSizeheight = MediaQuery.of(context).size.height;

    // var screenSize = MediaQuery.of(context).size;
    // final data =
    //     AppDataBase.data.where((item) => item.language == language).toList();   //// ไม่ได้ใช้

    ///ใช้ใน favorite

    // final filterModel = Provider.of<FilterModel>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: screenSizeheight * 0.05.h,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
                color: const Color(0xFFFFFFFF),
                // width: 800.w,
                width: 450.w,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w, left: 10.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        ////////เลือกภาษา
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
                                                        'indo',
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
                                                        'India - อินเดีย',
                                                        'assets/logo/png-transparent-flag-of-india-national-flag-india-flag-orange-india.png',
                                                        'ID',
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
                                selectedLanguageImage,
                                width: 14,
                                height: 14,
                              ),
                              const SizedBox(
                                width: 3,
                              ),
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
                                size: 20,
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
                      //////////////////////////////////////////////////////////ปุ่มแนะนำ
                      const Recommand(),
                      ////////////////////////////////////////////////////////ปุ่มหัวใจ
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
                      ////////////////////////////////////////////////////////ปุ่มทั้งหมด
                      const All(),
                      ////////////////////////////////////////////////////////ปุ่มสไตล์
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
    // double screenSizewidth = MediaQuery.of(context).size.width; //// Old
    return SizedBox(
      // height: 140.h,
      // width: screenSizewidth * 0.95.w,
      height: 127.h,
      width: 320.w,
      child: GridView.builder(
        // itemCount: AppDataBase.data.length, //old
        itemCount: NewAppDataBase.data
            .where((item) =>
                (gender == '' || item.gender == gender) &&
                (language == '' || item.language == language) &&
                (voiceStyle == '' || item.voiceStyle == voiceStyle) &&
                (speechStyle == '' || item.speechStyle == speechStyle))
            .length, //new

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          // mainAxisExtent: 150,
          mainAxisExtent: 125,
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // final data = AppDataBase.data[index];   /////////////////////////////old.
          final data = NewAppDataBase.data
              .where((item) =>
                  (gender == '' || item.gender == gender) &&
                  (language == '' || item.language == language) &&
                  (voiceStyle == '' || item.voiceStyle == voiceStyle) &&
                  (speechStyle == '' || item.speechStyle == speechStyle))
              .toList()[index]; ////new

          return voicewidget(data, index);
        },
      ),
    );
  }

  Column voicewidget(NewData data, int index) {
    ////method voicewidget    new
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
                    // ถ้ามีการเล่นเสียงอยู่ ให้หยุดก่อน
                    await audioPlayer.stop();
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
              language = data.language.toLowerCase();
              availableLanguage = data.availableLanguage.toList();
              print("\n### START voiceWidGetHome ###\n");
              print("-> speakerId: $speakerId");
              print("-> language: $language");
              print("-> availableLanguage: $availableLanguage");
              print("\n### END voiceWidGetHome ###\n");

              setState(() {
                if (selectedIndex.contains(index)) {
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
                  // width: 100.w,
                  // height: 113.h,
                  width: 81.w,
                  height: 103.h,
                  decoration: BoxDecoration(
                    border: GradientBoxBorder(
                      width: 3.w,
                      gradient: selectedIndex.contains(index)
                          // ? const LinearGradient(colors: [
                          //     Color(0xFF9A96F5),
                          //     Color(0xFF00E0FF)
                          //   ])
                          // : const LinearGradient(colors: [
                          //     Colors.transparent,
                          //     Colors.transparent
                          //   ]),
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
                        // AppDataBase.data[index].squareImage, //old
                        data.squareImage, //new
                      ),
                      fit: BoxFit.cover,
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10, // new
                        spreadRadius: 1, // new
                        color: selectedIndex.contains(index)
                            // ? Colors.blue.withOpacity(0.5) //old
                            ? const Color(0xFF9340FF).withOpacity(0.6) //new
                            : Colors.transparent,
                        // offset: const Offset(0, 2), //old
                        offset: const Offset(0, 4), //new
                      ),
                    ],
                  ),
                  child: Container(
                    //////new
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
                    ), ////refector container
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
                                  print('/////////' '$speakerId');

                                  setState(() {
                                    if (selectedIndexFavorites
                                        .contains(data.speakerId)) {
                                      ///////new
                                      selectedIndexFavorites
                                          .remove(data.speakerId); ///////new
                                    } else {
                                      // widget.onToggleFavorite(widget.data[index]);
                                      selectedIndexFavorites
                                          .add(data.speakerId); ///////new
                                      print(
                                          "selectedIndexFavorites: $selectedIndexFavorites");
                                    }
                                  });
                                },
                                child: selectedIndexFavorites
                                        .contains(data.speakerId) ///////new

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

                        const Spacer(), // Add Spacer to push the content below to the bottom
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
                            // Text(
                            //   softWrap: true,
                            //   overflow: TextOverflow.ellipsis,
                            //   maxLines: null,
                            //   AppDataBase.data[index].thaiName,
                            //   style: GoogleFonts.prompt(
                            //     fontSize: 10.sp,
                            //     color: Colors.white,
                            //     fontWeight: FontWeight.w500,
                            //   ),
                            // ), /////old
                            Expanded(
                                child: Text(
                              // AppDataBase.data[index].thaiName, //old
                              data.thaiName,
                              style: GoogleFonts.prompt(
                                fontSize: 10.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
                            )), ////////new
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Text(
                //   softWrap: true,
                //   overflow: TextOverflow.ellipsis,
                //   maxLines: null,
                //   widget.data[index].name,
                //   style: GoogleFonts.prompt(
                //     fontSize: 12.sp,
                //     color: Colors.black,
                //     fontWeight: FontWeight.bold,
                //   ),
                // ),
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
    // double screenSizewidth = MediaQuery.of(context).size.width;
    // double screenSizeheight = MediaQuery.of(context).size.height;

    return
        // Container(
        //   height: screenSizeheight * 0.093.h,
        //   width: screenSizewidth * 0.78.w,
        //   decoration: const BoxDecoration(
        //     color: Colors.white,
        //   ),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           // const Spacer(),
        //           InkWell(
        //             // onTap: () {},
        //             child: Container(
        //               height: 55.h,
        //               width: screenSizewidth * 0.7.w,
        //               decoration: BoxDecoration(
        //                 boxShadow: const [
        //                   BoxShadow(
        //                     color: Colors.black12,
        //                     blurRadius: 6.0,
        //                   ),
        //                 ],
        //                 borderRadius: BorderRadius.circular(10.r),
        //                 gradient: const LinearGradient(
        //                   colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
        //                 ),
        //               ),
        //               child: Row(
        //                 mainAxisAlignment: MainAxisAlignment.center,
        //                 children: [
        //                   Text(
        //                     "สร้างเสียง",
        //                     style: GoogleFonts.prompt(
        //                       fontSize: 16.sp,
        //                       fontWeight: FontWeight.bold,
        //                       color: const Color(0xFFFFFFFF),
        //                     ),
        //                   ),
        //                 ],
        //               ),
        //             ),
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // );
        Column(
      children: [
        const Spacer(),
        Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: GradientButton(
            text: 'สร้างเสียง',
            onPressed: () {
              setState(() {
                if (textController.text.isNotEmpty) {
                  audioPlayer.stop();
                }
              });
              if (!isLoading) {
                if (textController.text.isNotEmpty) {
                  generateAudio(textController.text).then((_) {
                    print('response $_response');
                    downloadFile();
                    print('progress -> downloadFile(): $progress \n');

                    setState(() {
                      // อัพเดตค่า credits หลังจากการทำงานเสร็จสิ้น
                      final auth =
                          Provider.of<Authentication>(context, listen: false);
                      int creditsInt = int.parse(auth.credits ?? '0');
                      creditsInt -= textController.text.length;
                      auth.credits = creditsInt.toString();
                    });
                  });

                  setState(() {
                    isLoading = false;
                  });

                  ///เรียกใช้ฟังก์ชัน appBar และเปลี่ยนค่าใน credits ที่แสดงผล
                  appBar(context, textController.text.length.toString());

                  ////////////////////////////////////////////////
                }
              }

              print("\n### END generateAudio -> Line 410 ### \n");
            },
          ),
        ),
      ],
    );
  }

  Future<void> generateAudio(String text) async {
    setState(() {
      isLoading = true;
      _response = '';
      _audioUrl = '';
    });

    final auth = Provider.of<Authentication>(context, listen: false);
    // final credits = Consumer<Authentication>(builder: (context, auth, child) {
    //   String? credits = auth.credits;
    //   int creditsInt = int.parse(credits!);
    //   creditsInt = creditsInt - textController.text.length;
    //   credits = creditsInt.toString();
    //   print('updatecredits: ${auth.credits}');
    //   return Text('data: ${auth.credits}');
    // });

    // ดึงข้อมูล point มาเก็บไว้ในตัวแปร แล้วทำการหักคะแนน ตาม จำนวนตัวอักษร ที่ผู้ใช้งาน สร้างเสียง

    // String credits = auth.credits;
    // int creditsInt = int.parse(credits);

    // creditsInt = creditsInt - textController.text.length;
    // credits = creditsInt.toString();
    // print("update credits: $credits");

    print({credits.toString()});
    print(
        '\n ## generateAudio ## \n credentialsToken: ${auth.credentialsToken} \n text: $text \n speaker: $speakerId');
    print(' language: $language \n availableLanguage: $availableLanguage \n');

    String url = "https://api-voice.botnoi.ai/openapi/v1/generate_audio";
    Map<String, dynamic> payload = {
      "text": text,
      "speaker": speakerId,
      "volume": 1,
      "speed": 1,
      "type_media": selectedTypeMedia,
      "save_file": true,
      // "language": language,
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
          _response = "Request successful!";
          print("generateAudio -> _audioUrl: $_audioUrl");
          isLoading = false;
        });
      } else {
        setState(() {
          _response =
              "Failed to retrieve data. Status Code: ${response.statusCode}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _response = "Failed to connect to the server. Error: $e";
        isLoading = false;
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

  /*
  Future<void> _androidDownloadFunction() async {
    try {
      var filename = "BotnoiVoice${randomString(6)}.$selectedTypeMedia";

      // working on EMULATOR ONLY!
      var path = "/storage/emulated/0/Download/$filename";

      var file = File(path);
      String url = _audioUrl;
      var res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        await file.writeAsBytes(res.bodyBytes);
        print('Download successful: $filename');

        setState(() {
          progress = 'Download complete';
        });

        print("Printing Path: ");
        print(filename);
        print(path);
        print(file);
        OpenAppFile.open(path);
        
      } else {
        print('Failed to download file: ${res.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }
  */

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

  Future<void> categorylanguage() async {}
}
