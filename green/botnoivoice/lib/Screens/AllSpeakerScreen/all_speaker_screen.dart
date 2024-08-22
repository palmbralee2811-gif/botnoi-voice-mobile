import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/Database/newdata.dart';
import 'package:botnoivoice/Filters/favorite.dart';
import 'package:botnoivoice/Screens/AllSpeakerScreen/speaker_provider.dart';
import 'package:botnoivoice/Screens/GradientScreen/gradient_button.dart';
import 'package:botnoivoice/Screens/HomeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:provider/provider.dart';

class AllSpeakerScreen extends StatefulWidget {
  const AllSpeakerScreen({super.key});

  @override
  State<AllSpeakerScreen> createState() => _AllSpeakerScreenState();
}

class _AllSpeakerScreenState extends State<AllSpeakerScreen> {
  bool ishover = false;
  String? speakerId;
  String? language; // เลือกภาษา
  String? gender; // เลือกเพศ
  String? speechStyle; // เลือกสไตล์
  String? voiceStyle; // เลือกหมวดหมู่

  Set<int> selectedIndex = <int>{};
  AudioPlayer audioPlayer = AudioPlayer();
  List<NewData>? data;
  List<String> selectedIndexFavorites = [];

  String selectedLanguage = 'ไทย';
  String selectedLanguageImage = 'assets/images/national_flag/thai.png';
  bool isExpanded = false;

  ///เลือกเพศ
  String selectedGender = 'ช/ญ';
  String selectedGenderImage = 'assets/images/gender/all.svg';

  /// เลือกเพศ
  bool changeIcon = false;
  // เลือกสไตล์
  bool isSelectedVoiceStyle = false;
  bool isSelectedVoiceStyle1 = false;
  bool isSelectedVoiceStyle2 = false;
  bool isSelectedVoiceStyle3 = false;
  bool isSelectedVoiceStyle4 = false;
  bool isSelectedVoiceStyle5 = false;
  bool isSelectedVoiceStyle6 = false;
  bool isSelectedVoiceStyle7 = false;
  bool isSelectedVoiceStyle8 = false;
  bool isSelectedVoiceStyle9 = false;
  bool isSelectedVoiceStyle10 = false;
  bool isSelectedVoiceStyle11 = false;
  bool isSelectedVoiceStyle12 = false;
  bool isSelectedVoiceStyle13 = false;
  bool isSelectedVoiceStyle14 = false;
  bool isSelectedVoiceStyle15 = false;
  bool isSelectedVoiceStyle16 = false;
  // เลือกหมวดหมู่
  bool isSelectedSpeechStyle = false;
  bool isSelectedSpeechStyle1 = false;
  bool isSelectedSpeechStyle2 = false;
  bool isSelectedSpeechStyle3 = false;
  bool isSelectedSpeechStyle4 = false;
  bool isSelectedSpeechStyle5 = false;
  bool isSelectedSpeechStyle6 = false;
  bool isSelectedSpeechStyle7 = false;
  bool isSelectedSpeechStyle8 = false;
  bool isSelectedSpeechStyle9 = false;
  bool isSelectedSpeechStyle10 = false;

  @override
  void initState() {
    super.initState();
    language = '';
    gender = '';
    speechStyle = '';
    voiceStyle = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: Padding(
          padding: EdgeInsets.only(left: 89.w),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            SvgPicture.asset(
              'assets/images/logo/appbar-icon.svg',
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
      body: buildFilterNavbar(context),
    );
  }

  Widget buildFilterNavbar(BuildContext context) {
    return Column(
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
                                  buildLanguageButton(context, setState)
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
                          width: 14.w,
                          height: 14.h,
                        ),
                        SizedBox(
                          width: 3.w,
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
                                    buildGenderButton(context),
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
                            if (gender == '')
                              Text(
                                'ช/ญ',
                                style: GoogleFonts.prompt(
                                  fontSize: 12.sp,
                                ),
                              ),
                            if (gender.toString() != '')
                              Text(
                                selectedGender,
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
                buildFavoriteButton(),
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
                  buildVoiceStyleButton(context),
                  buildSpeechStyleButton(context),
                ]),
          ),
        ),
        Container(
          color: const Color(0xFFFFFFFF),
          height: 420.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ishover
                  ? buildFavoriteFilter(
                      context,
                    )
                  : buildMultipleSpeaker(context),
            ],
          ),
        ),
        buildBottomNavbarButton()
      ],
    );
  }

  Widget buildLanguageButton(BuildContext context, StateSetter setState) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            width: 280.w,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                _buildLanguageFilter(
                    'All - ทั้งหมด',
                    'assets/images/national_flag/all.png',
                    '',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Thai (Thailand) - ไทย',
                    'assets/images/national_flag/thai.png',
                    'TH',
                    context,
                    setState),
                _buildLanguageFilter(
                    'English (UK) - อังกฤษ',
                    'assets/images/national_flag/english.png',
                    'EN',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Indonesia - อินโดนีเซีย',
                    'assets/images/national_flag/indonesia.png',
                    'ID',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Japanese - ญี่ปุ่น',
                    'assets/images/national_flag/japanese.png',
                    'JA',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Laos - ลาว',
                    'assets/images/national_flag/laos.png',
                    'LO',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Burmese - เมียนมาร์',
                    'assets/images/national_flag/burmese.png',
                    'MY',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Vietnamese - เวียดนาม',
                    'assets/images/national_flag/vietnamese.png',
                    'VI',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Chinese (Simplified) - จีน',
                    'assets/images/national_flag/chinese.png',
                    'ZH',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Cambodia - กัมพูชา',
                    'assets/images/national_flag/cambodia.png',
                    'KM',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Filipino - ฟิลิปปินส์',
                    'assets/images/national_flag/filipino.png',
                    'FIL',
                    context,
                    setState),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFavoriteButton() {
    return InkWell(
      onTap: () {
        setState(() {
          ishover = !ishover;
        });
      },
      child: Favorite(ishover: ishover),
    );
  }

  Widget buildGenderButton(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: 280.w,
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
          _buildGenderFilter(
              'ช/ญ', 'assets/images/gender/all.svg', '', context, setState),
          _buildGenderFilter('หญิง', 'assets/images/gender/woman.svg',
              'ผู้หญิง', context, setState),
          _buildGenderFilter('ชาย', 'assets/images/gender/man.svg', 'ผู้ชาย',
              context, setState)
        ],
      ),
    );
  }

  Widget buildVoiceStyleButton(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelectedVoiceStyle = !isSelectedVoiceStyle;
        });
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
                                    'สไตล์',
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
                              Wrap(
                                alignment: WrapAlignment.start,
                                spacing: 13.0,
                                runSpacing: 13.0,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedVoiceStyle1 =
                                            !isSelectedVoiceStyle1;
                                        voiceStyle = isSelectedVoiceStyle1
                                            ? 'เสียงน่ารัก'
                                            : '';
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: buildSpeechStyleFilter(
                                        'น่ารัก', isSelectedVoiceStyle1),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedVoiceStyle2 =
                                            !isSelectedVoiceStyle2;
                                        voiceStyle = isSelectedVoiceStyle2
                                            ? 'เสียงมั่นใจ'
                                            : '';
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: buildSpeechStyleFilter(
                                        'มั่นใจ', isSelectedVoiceStyle2),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedVoiceStyle3 =
                                            !isSelectedVoiceStyle3;
                                        voiceStyle = isSelectedVoiceStyle3
                                            ? 'เสียงน่าเชื่อถือ'
                                            : '';
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: buildSpeechStyleFilter(
                                        'น่าเชื่อถือ', isSelectedVoiceStyle3),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedVoiceStyle4 =
                                            !isSelectedVoiceStyle4;
                                        voiceStyle = isSelectedVoiceStyle4
                                            ? 'เสียงตื่นเต้น'
                                            : '';
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: buildSpeechStyleFilter(
                                        'ตื่นเต้น', isSelectedVoiceStyle4),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedVoiceStyle5 =
                                            !isSelectedVoiceStyle5;
                                        voiceStyle = isSelectedVoiceStyle5
                                            ? 'เสียงจริงจัง'
                                            : '';
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: buildSpeechStyleFilter(
                                        'จริงจัง', isSelectedVoiceStyle5),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedVoiceStyle6 =
                                            !isSelectedVoiceStyle6;
                                        voiceStyle = isSelectedVoiceStyle6
                                            ? 'เสียงหวาน'
                                            : '';
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: buildSpeechStyleFilter(
                                        'หวาน', isSelectedVoiceStyle6),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedVoiceStyle7 =
                                            !isSelectedVoiceStyle7;
                                        voiceStyle = isSelectedVoiceStyle7
                                            ? 'เสียงอบอุ่น'
                                            : '';
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: buildSpeechStyleFilter(
                                        'อบอุ่น', isSelectedVoiceStyle7),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedVoiceStyle8 =
                                            !isSelectedVoiceStyle8;
                                        voiceStyle = isSelectedVoiceStyle8
                                            ? 'เสียงขี้เล่น'
                                            : '';
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: buildSpeechStyleFilter(
                                        'ขี้เล่น', isSelectedVoiceStyle8),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedVoiceStyle9 =
                                            !isSelectedVoiceStyle9;
                                        voiceStyle = isSelectedVoiceStyle9
                                            ? 'เสียงทุ้ม'
                                            : '';
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: buildSpeechStyleFilter(
                                        'ทุ้ม', isSelectedVoiceStyle9),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedVoiceStyle10 =
                                            !isSelectedVoiceStyle10;
                                        voiceStyle = isSelectedVoiceStyle10
                                            ? 'เสียงนุ่มนวล'
                                            : '';
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: buildSpeechStyleFilter(
                                        'นุ่มนวล', isSelectedVoiceStyle10),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedVoiceStyle11 =
                                            !isSelectedVoiceStyle11;
                                        voiceStyle = isSelectedVoiceStyle11
                                            ? 'เสียงท้องถิ่น'
                                            : '';
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: buildSpeechStyleFilter(
                                        'ท้องถิ่น', isSelectedVoiceStyle11),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedVoiceStyle12 =
                                            !isSelectedVoiceStyle12;
                                        voiceStyle = isSelectedVoiceStyle12
                                            ? 'เสียงใจเย็น'
                                            : '';
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: buildSpeechStyleFilter(
                                        'ใจเย็น', isSelectedVoiceStyle12),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedVoiceStyle13 =
                                            !isSelectedVoiceStyle13;
                                        voiceStyle = isSelectedVoiceStyle13
                                            ? 'เสียงนิ่มนวล'
                                            : '';
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: buildSpeechStyleFilter(
                                        'นิ่มนวล', isSelectedVoiceStyle13),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedVoiceStyle14 =
                                            !isSelectedVoiceStyle14;
                                        voiceStyle = isSelectedVoiceStyle14
                                            ? 'เสียงชัดเจน'
                                            : '';
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: buildSpeechStyleFilter(
                                        'ชัดเจน', isSelectedVoiceStyle14),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedVoiceStyle15 =
                                            !isSelectedVoiceStyle15;
                                        voiceStyle = isSelectedVoiceStyle15
                                            ? 'เสียงเหนือ'
                                            : '';
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: buildSpeechStyleFilter(
                                        'เหนือ', isSelectedVoiceStyle15),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedVoiceStyle16 =
                                            !isSelectedVoiceStyle16;
                                        voiceStyle = isSelectedVoiceStyle16
                                            ? 'เสียงอีสาน'
                                            : '';
                                        Navigator.pop(context);
                                      });
                                    },
                                    child: buildSpeechStyleFilter(
                                        'อีสาน', isSelectedVoiceStyle16),
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
            isSelectedVoiceStyle = false;
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
                      style: GoogleFonts.prompt(fontSize: 12.sp),
                    ),
                  ),
                ),
                Icon(
                  isSelectedVoiceStyle
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
    );
  }

  Widget buildSpeechStyleButton(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelectedSpeechStyle = !isSelectedSpeechStyle;
        });
        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setModalState) {
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
                                    MainAxisAlignment.spaceBetween,
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
                                        isSelectedSpeechStyle1 =
                                            !isSelectedSpeechStyle1;
                                        speechStyle = isSelectedSpeechStyle1
                                            ? 'สไตล์เล่าเรื่อง'
                                                'สไตล์อ่านข่าว'
                                            : '';
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: buildSpeechStyleFilter(
                                        'เล่าเรื่อง', isSelectedSpeechStyle1),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedSpeechStyle2 =
                                            !isSelectedSpeechStyle2;
                                        speechStyle = isSelectedSpeechStyle2
                                            ? 'สไตล์อ่านข่าว'
                                                'สไตล์เล่าเรื่อง'
                                            : '';
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: buildSpeechStyleFilter(
                                        'อ่านข่าว', isSelectedSpeechStyle2),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedSpeechStyle3 =
                                            !isSelectedSpeechStyle3;
                                        speechStyle = isSelectedSpeechStyle3
                                            ? 'สไตล์เล่าเรื่อง'
                                                'สไตล์ตัวละคร'
                                            : '';
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: buildSpeechStyleFilter(
                                        'ตัวละคร', isSelectedSpeechStyle3),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedSpeechStyle4 =
                                            !isSelectedSpeechStyle4;
                                        speechStyle = isSelectedSpeechStyle4
                                            ? 'สไตล์บรรยาย'
                                                'สไตล์ตัวละคร'
                                            : '';
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: buildSpeechStyleFilter(
                                        'บรรยาย', isSelectedSpeechStyle4),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedSpeechStyle5 =
                                            !isSelectedSpeechStyle5;
                                        speechStyle = isSelectedSpeechStyle5
                                            ? 'สไตล์อ่านข่าว'
                                                'สไตล์สปอตโฆษณา'
                                            : '';
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: buildSpeechStyleFilter(
                                        'สปอตโฆษณา', isSelectedSpeechStyle5),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedSpeechStyle6 =
                                            !isSelectedSpeechStyle6;
                                        speechStyle = isSelectedSpeechStyle6
                                            ? 'สไตล์สารคดี'
                                                'สไตล์บรรยาย'
                                            : '';
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: buildSpeechStyleFilter(
                                        'สารคดี', isSelectedSpeechStyle6),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedSpeechStyle7 =
                                            !isSelectedSpeechStyle7;
                                        speechStyle = isSelectedSpeechStyle7
                                            ? 'สไตล์ตัวละคร'
                                                'สไตล์อนิเมะ'
                                            : '';
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: buildSpeechStyleFilter(
                                        'อนิเมะ', isSelectedSpeechStyle7),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedSpeechStyle8 =
                                            !isSelectedSpeechStyle8;
                                        speechStyle = isSelectedSpeechStyle8
                                            ? 'สไตล์บรรยาย'
                                                'สไตล์อาจารย์'
                                            : '';
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: buildSpeechStyleFilter(
                                        'อาจารย์', isSelectedSpeechStyle8),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedSpeechStyle9 =
                                            !isSelectedSpeechStyle9;
                                        speechStyle = isSelectedSpeechStyle9
                                            ? 'สไตล์เล่าเรื่อง'
                                                'สไตล์ท้องถิ่น'
                                            : '';
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: buildSpeechStyleFilter(
                                        'ท้องถิ่น', isSelectedSpeechStyle9),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setModalState(() {
                                        isSelectedSpeechStyle10 =
                                            !isSelectedSpeechStyle10;
                                        speechStyle = isSelectedSpeechStyle10
                                            ? 'สไตล์อ่านข่าว'
                                                'สไตล์เสียงต่างประเทศ'
                                            : '';
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: buildSpeechStyleFilter(
                                        'เสียงต่างประเทศ',
                                        isSelectedSpeechStyle10),
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
            isSelectedSpeechStyle = false;
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
                      style: GoogleFonts.prompt(fontSize: 12.sp),
                    ),
                  ),
                ),
                Icon(
                  isSelectedSpeechStyle
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
    );
  }

  Widget buildBottomNavbarButton() {
    return SizedBox(
      height: 56.h,
      width: 320.w,
      child: Padding(
        padding:
            EdgeInsets.only(left: 20.w, top: 10.h, right: 20.w, bottom: 10.h),
        child: SizedBox(
          child: GradientButton(
            text: 'ตกลง',
            onPressed: () {
              if (audioPlayer.state == PlayerState.playing) {
                audioPlayer.stop();
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildSpeechStyleFilter(String text, bool isSelected) {
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

  Widget _buildLanguageFilter(String text, String imagePath, String lang,
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

  Widget _buildGenderFilter(
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
            SvgPicture.asset(
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

  Widget buildMultipleSpeaker(BuildContext context) {
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
                final data = NewAppDataBase.data
                    .where((item) =>
                        (gender == '' || item.gender == gender) &&
                        (language == '' || item.language == language) &&
                        (voiceStyle == '' || item.voiceStyle == voiceStyle) &&
                        (speechStyle == '' || item.speechStyle == speechStyle))
                    .toList()[index];
                return buildSingleSpeaker(data, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSingleSpeaker(NewData data, int index) {
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
                  if (audioPlayer.state == PlayerState.playing) {
                    await audioPlayer.stop();
                  }
                  await audioPlayer.play(UrlSource(audioURL));
                }
              }
              await playAudio();
              speakerId = data.speakerId;
              Provider.of<SpeakerProvider>(context, listen: false)
                  .setSpeakerId(speakerId!);

              //TODO: speaker image path

              //TODO: speaker image name

              //TODO: national flag icon path

              //TODO: national flag name

              //TODO: setter & getter value to the all_speaker_screen.dart
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
                  width: 100.w,
                  height: 113.h,
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
                              begin: const Alignment(1, 1),
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
                                          'assets/images/icon/heart-on.svg',
                                          width: 20.w,
                                          height: 20.h,
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        'assets/images/icon/heart-off.svg',
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
                                      'assets/images/icon/play-on.svg',
                                      width: 16.h,
                                      height: 16.w,
                                    ),
                                  )
                                : SvgPicture.asset(
                                    'assets/images/icon/play-off.svg',
                                    width: 16.h,
                                    height: 16.w,
                                  ),
                            SizedBox(
                              width: 3.w,
                            ),
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

  Widget buildFavoriteFilter(BuildContext context) {
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

          return buildSingleSpeaker(data, index);
        },
      ),
    );
  }
}
