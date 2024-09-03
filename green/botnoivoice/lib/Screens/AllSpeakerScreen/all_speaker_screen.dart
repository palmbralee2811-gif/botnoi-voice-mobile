import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/Database/speaker_data.dart';
import 'package:botnoivoice/Database/speaker_model.dart';
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
  bool ishover = false; // ต้องการให้ข้อมูล ishover เก็บไว้ใน cache ของเครื่อง
  String? speakerId;
  String? language; // เลือกภาษา
  String? gender; // เลือกเพศ

  Set<int> selectedIndex = <int>{};
  AudioPlayer audioPlayer = AudioPlayer();

  List<SpeakerModel>? speakerData;

  List<String> selectedIndexFavorites = [];

  String selectedLanguage = 'ไทย';
  String selectedLanguageImage = 'assets/images/national_flag/thai.png';
  bool isExpanded = false;

  ///เลือกเพศ
  String selectedGender = 'ช/ญ';
  String selectedGenderImage = 'assets/images/gender/all.svg';

  /// เลือกเพศ
  bool changeIcon = false;

  @override
  void initState() {
    super.initState();
    language = 'TH';
    gender = '';
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
          height: 100.h,
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
                    width: 100.w,
                    height: 35.h,
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
                          width: 28.w,
                          height: 28.h,
                        ),
                        SizedBox(
                          width: 6.w,
                        ),
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              selectedLanguage,
                              style: GoogleFonts.prompt(fontSize: 16.sp),
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
                    width: 100.w,
                    height: 35.h,
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
                            SizedBox(width: 3.w),
                            SvgPicture.asset(
                              selectedGenderImage,
                              width: 28.w,
                              height: 28.h,
                            ),
                            SizedBox(width: 6.w),
                            if (gender == '')
                              Text(
                                'ช/ญ',
                                style: GoogleFonts.prompt(
                                  fontSize: 16.sp,
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
        SizedBox(
          height: 10.h,
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
                // _buildLanguageFilter(
                //     'All - ทั้งหมด',
                //     'assets/images/national_flag/all.png',
                //     '',
                //     context,
                //     setState),
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

  Widget buildBottomNavbarButton() {
    return SizedBox(
      height: 60.h,
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
          if (text == 'ไทย') {
            language = 'TH';
          } else {
            List<String> parts = text.split(' - ');
            if (parts.length > 1) {
              selectedLanguage = parts[1];
            } else {
              selectedLanguage = text;
            }
            selectedLanguageImage = imagePath;
            language = lang;
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
            selectedGender = 'ช/ญ';
            selectedGenderImage = 'assets/images/gender/all.svg';
            gender = ''; // กำหนดค่าเป็นว่างเพื่อให้แสดงทุกเพศ
            debugPrint("selectedGenderImage: $selectedGenderImage");
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
              itemCount: SpeakerModelData.speakerData //NewAppDataBase.data
                  .where((item) =>
                      item.language == language &&
                      (gender == '' || item.gender == gender))
                  .length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 0,
                childAspectRatio: 0.8,
              ),
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                final data = SpeakerModelData.speakerData //NewAppDataBase.data
                    .where((item) =>
                        item.language == language &&
                        (gender == '' || item.gender == gender))
                    .toList()[index];
                return buildSingleSpeaker(data, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSingleSpeaker(
      SpeakerModel speakerData /*NewData data*/, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 7.h),
          child: GestureDetector(
            onTap: () async {
              String audioURL = speakerData.audio;
              Future<void> playAudio() async {
                if (audioURL.isNotEmpty) {
                  if (audioPlayer.state == PlayerState.playing) {
                    await audioPlayer.stop();
                  }
                  await audioPlayer.play(UrlSource(audioURL));
                }
              }

              await playAudio();

              Provider.of<SpeakerProvider>(context, listen: false)
                  .setSpeakerId(speakerData.speakerId);
              Provider.of<SpeakerProvider>(context, listen: false)
                  .setSpeakerName(speakerData.thaiName);
              Provider.of<SpeakerProvider>(context, listen: false)
                  .setSpeakerAudio(speakerData.audio);
              Provider.of<SpeakerProvider>(context, listen: false)
                  .setSpeakerImagePath(speakerData.squareImage);
              Provider.of<SpeakerProvider>(context, listen: false)
                  .setNationalFlagPath(selectedLanguageImage);
              Provider.of<SpeakerProvider>(context, listen: false)
                  .setNationalFlagName(selectedLanguage);

              setState(() {
                if (selectedIndex.contains(index)) {
                  if (audioPlayer.state == PlayerState.playing) {
                    audioPlayer.stop();
                  }
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
                      //TODO: เก็บรูปภาพที่โหลดจาก URL ไว้ใน Cache ของแอปพลิเคชัน
                      image: NetworkImage(
                        speakerData.squareImage,
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
                                        .contains(speakerData.speakerId)) {
                                      selectedIndexFavorites
                                          .remove(speakerData.speakerId);
                                    } else {
                                      selectedIndexFavorites
                                          .add(speakerData.speakerId);
                                    }
                                  });
                                },
                                child: selectedIndexFavorites
                                        .contains(speakerData.speakerId)
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
                              speakerData.thaiName,
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
        itemCount: SpeakerModelData.speakerData //NewAppDataBase.data
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
          final data = SpeakerModelData.speakerData //NewAppDataBase.data
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
