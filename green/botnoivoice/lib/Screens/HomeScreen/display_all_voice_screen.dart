import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/Database/newdata.dart';
import 'package:botnoivoice/Filters/advert.dart';
import 'package:botnoivoice/Filters/all.dart';
import 'package:botnoivoice/Filters/commandie.dart';
import 'package:botnoivoice/Filters/discreetly.dart';
import 'package:botnoivoice/Filters/favorite.dart';
import 'package:botnoivoice/Filters/fresh.dart';
import 'package:botnoivoice/Filters/new.dart';
import 'package:botnoivoice/Filters/podcast.dart';
import 'package:botnoivoice/Filters/recomman.dart';
import 'package:botnoivoice/Filters/sad.dart';
import 'package:botnoivoice/Filters/voice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class DisplayAllVoiceScreen extends StatefulWidget {
  const DisplayAllVoiceScreen({super.key});

  @override
  State<DisplayAllVoiceScreen> createState() => _DisplayAllVoiceScreenState();
}

class _DisplayAllVoiceScreenState extends State<DisplayAllVoiceScreen> {
  bool ishover = false;
  // int selectedIndex = -1;
  int selectedIndex2 = -1;
  String? speakerId;
  String? language; // เลือกภาษา   new
  String? gender; ////เลือกเพศ
  String? speechStyle; /////เลือกสไตล์
  String? voiceStyle; /////เลือกหมวดหมู่

  List<String>? availableLanguage;
  String? credits;
  Set<int> selectedIndex = <int>{};

  // Download File
  String progress = '';
  bool isLoading = false;
  AudioPlayer audioPlayer = AudioPlayer();

  // Player Audio
  bool isAudioPlaying = false;
  List<NewData>? data;

  // Download Audio
  String selectedTypeMedia = 'mp3';
  // final List<String> _typeMedia = ['wav', 'mp3', 'm4a'];

  List<String> selectedIndexFavorites = []; /////เลือกเสียงที่ชอบ  new

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
  void initState() {
    super.initState();
    // Initialize language and other variables
    language = ''; // หรือภาษาที่คุณต้องการให้แสดงเป็นค่าเริ่มต้น   new
    gender = ''; ///////////////////////// กำนดค่าเริ่มต้น  new
    speechStyle = ''; // สไตล์ที่คุณต้องการให้แสดงเป็นค่าเริ่มต้น  new
    voiceStyle = ''; // หมวดหมู่ที่คุณต้องการให้แสดงเป็นค่าเริ่มต้น  new
    /// กำหนดค่าเป็นว่างเพื่อให้แสดงทุกเพศ
    // Initialize other variables here...
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: Padding(
          padding: EdgeInsets.only(left: 89.w),
          child:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
            Image.asset(
              'assets/logo/Frame (1).png',
              width: 30.w,
              height: 34.h,
            ),
            Icon(
              Icons.search_rounded,
              size: 24.sp,
              color: const Color(0xFF323130),
            )
          ]),
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 50.h,
            width: 320.w,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(left: 10.w, right: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    // เลือกภาษา
                    onTap: () {
                      setState(() {
                        isExpanded = true;
                      });

                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder:
                                (BuildContext context, StateSetter setState) {
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
                  /////////////////////////////gender
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
                  const Recommand(),

                  InkWell(
                    onTap: () {
                      setState(() {
                        ishover = !ishover;
                      });
                    },
                    child: Favorite(ishover: ishover),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 63.w,
                      height: 26.h,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
                        ),
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
                              ishover
                                  ? Text(
                                      'ดูทั้งหมด',
                                      style: GoogleFonts.prompt(
                                        fontSize: 12.sp,
                                        color: const Color(0xFFFFFFFF),
                                      ),
                                    )
                                  : Text(
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
            ),
          ),
          Container(
            height: 76.h,
            width: 320.w,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(right: 13.w, left: 13.w, top: 8.w),
              child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 13.0,
                  runSpacing: 13.0,
                  children: [
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
                                                alignment: WrapAlignment.start,
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
                                                        Navigator.pop(context);
                                                      });
                                                      print(
                                                          'Selected voice: น่ารัก, voice: $voiceStyle');
                                                    },
                                                    child: filterStyle(
                                                        'น่ารัก', selectStyle1),
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
                                                        Navigator.pop(context);
                                                      });
                                                      print(
                                                          'Selected voice: มั่นใจ, voice: $voiceStyle');
                                                    },
                                                    child: filterStyle(
                                                        'มั่นใจ', selectStyle2),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      setModalState(() {
                                                        selectStyle3 =
                                                            !selectStyle3;
                                                        voiceStyle = selectStyle3
                                                            ? 'เสียงน่าเชื่อถือ'
                                                            : '';
                                                        Navigator.pop(context);
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
                                                        Navigator.pop(context);
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
                                                        Navigator.pop(context);
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
                                                        Navigator.pop(context);
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
                                                        Navigator.pop(context);
                                                      });
                                                      print(
                                                          'Selected voice: อบอุ่น, voice: $voiceStyle');
                                                    },
                                                    child: filterStyle(
                                                        'อบอุ่น', selectStyle7),
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
                                                        Navigator.pop(context);
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
                                                        Navigator.pop(context);
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
                                                        Navigator.pop(context);
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
                                                        Navigator.pop(context);
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
                                                        Navigator.pop(context);
                                                      });
                                                      print(
                                                          'Selected voice: ใจเย็น, voice: $voiceStyle');
                                                    },
                                                    child: filterStyle('ใจเย็น',
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
                                                        Navigator.pop(context);
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
                                                        Navigator.pop(context);
                                                      });
                                                      print(
                                                          'Selected voice: ชัดเจน, voice: $voiceStyle');
                                                    },
                                                    child: filterStyle('ชัดเจน',
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
                                                        Navigator.pop(context);
                                                      });
                                                      print(
                                                          'Selected voice: เหนือ, voice: $voiceStyle');
                                                    },
                                                    child: filterStyle(
                                                        'เหนือ', selectStyle15),
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
                                                        Navigator.pop(context);
                                                      });
                                                      print(
                                                          'Selected voice: อีสาน, voice: $voiceStyle');
                                                    },
                                                    child: filterStyle(
                                                        'อีสาน', selectStyle16),
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
                                  height: 200.h,
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
                                                alignment: WrapAlignment.start,
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
                                                    child: filterStyle('บรรยาย',
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
                                                    child: filterStyle('สารคดี',
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
                                                    child: filterStyle('อนิเมะ',
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
                    const New(),
                    const Voice(),
                    const Advert(),
                    const Podcast(),
                    const Commandie(),
                    const Fresh(),
                    const Discreetly(),
                    const Sad(),
                  ]),
            ),
          ),
          Container(
            //////////////พื้นหลัง widget voice
            // color: Colors.amber,
            color: const Color(0xFFFFFFFF),
            height: 420.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ishover
                    ? voiceWidgetFavorite(
                        context, /// เลือกเสียงที่ชอบ
                      )
                    : voiceWidGetHome(context), /// หน้าเลือกเสียงหลัก
              ],
            ),
          ),
          const Spacer(),
          Container(
            height: 56.h,
            width: 320.w,
            decoration: const BoxDecoration(
                // color: Colors.amber,
                ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: 20.w, top: 10.h, right: 20.w, bottom: 10.h),
              child: SizedBox(
                child: GradientButton(
                  text: 'ตกลง',
                  onPressed: () {
                    debugPrint('ตกลง');
                  },
                ),
              ),
            ),
          )
        ],
      ),
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
    return SizedBox(
      height: 420.h,
      width: 320.w,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            height: 420.h,
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
                crossAxisCount: 3,
                crossAxisSpacing: 0,
                childAspectRatio: 0.8,
              ),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                // final data = AppDataBase.data[index];   /////////////////////////////old.
                final data = NewAppDataBase.data
                    .where((item) =>
                        (gender == '' || item.gender == gender) &&
                        (language == '' || item.language == language) &&
                        (voiceStyle == '' || item.voiceStyle == voiceStyle) &&
                        (speechStyle == '' || item.speechStyle == speechStyle))
                    .toList()[index]; ////new
                print(data.language);
                return voicewidget(data, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Column voicewidget(NewData data, int index) {
    ////method voicewidget    new
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 7.h),
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
                  // width: 100.w,
                  // height: 113.h,
                  width: 100.w,
                  height: 113.h,
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
      height: 420.h,
      width: 320.w,
      child: GridView.builder(
        itemCount: NewAppDataBase.data
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
}
