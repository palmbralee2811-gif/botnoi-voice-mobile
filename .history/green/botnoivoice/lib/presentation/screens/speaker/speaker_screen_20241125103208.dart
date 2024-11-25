import 'package:audioplayers/audioplayers.dart';
import 'package:botnoivoice/data/models/speaker_model.dart';
import 'package:botnoivoice/domain/entities/speaker_entity.dart';
import 'package:botnoivoice/presentation/widgets/filter/favorite.dart';
import 'package:botnoivoice/data/repositories/speaker_repository_impl.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class SpeakerScreen extends StatefulWidget {
  const SpeakerScreen({super.key});

  @override
  State<SpeakerScreen> createState() => _SpeakerScreenState();
}

class _SpeakerScreenState extends State<SpeakerScreen> {
  final Logger logger = Logger(); // Logger for Debugging mode
  bool ishover = false; // ต้องการให้ข้อมูล ishover เก็บไว้ใน cache ของเครื่อง
  String? speakerId;
  String? language; // เลือกภาษา
  String? gender; // เลือกเพศ
  Set<int> selectedIndex = <int>{};
  AudioPlayer audioPlayer = AudioPlayer();
  List<SpeakerEntity>? speakerItem;
  List<String> selectedIndexFavorites = [];
  String selectedLanguage = 'ไทย';
  String selectedLanguageImage = 'assets/images/national_flag/thai.png';
  bool isExpanded = false;

  ///เลือกเพศ
  String selectedGender = 'ช/ญ';
  String selectedGenderImage = 'assets/images/gender/all.svg';

  /// เลือกเพศ
  bool changeIcon = false;

  //เพิ่มสไตล์เสียง
  Set<String> selectedStyles = {};
  String selectedVoiceStyle = ''; // ตัวแปรเก็บเสียงที่ผู้ใช้เลือก
  String selectedStyle = ''; // สไตล์เสียงที่เลือก

  //เพิ่มหมวดหมู่
  Set<String> selectedCategories = {}; // เก็บหมวดหมู่ที่เลือก

  // ข้อมูลตัวเลือกต่าง ๆ สำหรับภาษาไทยและภาษาอังกฤษ
  // สไตล์เสียงภาษาไทย
  List<String> voiceStyle = [
    'เสียงขี้เล่น',
    'เสียงจริงจัง',
    'เสียงชัดเจน',
    'เสียงตื่นเต้น',
    'เสียงทุ้ม',
    'เสียงท้องถิ่น',
    'เสียงนิ่มนวล',
    'เสียงนุ่มนวล',
    'เสียงน่ารัก',
    'เสียงน่าเชื่อถือ',
    'เสียงมั่นใจ',
    'เสียงหวาน',
    'เสียงอบอุ่น',
    'เสียงอีสาน',
    'เสียงเหนือ',
    'เสียงใจเย็น',
    'ใต้'
  ];

  // รายการสไตล์เสียงภาษาอังกฤษ
  List<String> voiceStyleEng = [
    'Playful',
    'Serious',
    'Clear',
    'Excited',
    'Deep',
    'Regional',
    'Soft',
    'Smooth',
    'Cute',
    'Trustworthy',
    'Confident',
    'Sweet',
    'Warm',
    'Northeastern',
    'Northern',
    'Calm',
    'Southern'
  ];

  //หมวดหมู่เสียงภาษาไทย
  List<String> speechStyle = [
    'ฟรี',
    'สไตล์ตัวละคร',
    'สไตล์ท้องถิ่น',
    'สไตล์บรรยาย',
    'สไตล์สปอตโฆษณา',
    'สไตล์สารคดี',
    'สไตล์อนิเมะ',
    'สไตล์อาจารย์',
    'สไตล์อ่านข่าว',
    'สไตล์เล่าเรื่อง',
    'สไตล์เสียงต่างประเทศ',
  ];

  // หมวดหมู่เสียงภาษาอังกฤษ
  List<String> engSpeechStyle = [
    'Storytelling',
    'Narrating',
    'Free',
    'News Reading',
    'Advertising Spot',
    'Character',
    'Documentary',
    'Local',
    'Anime',
    'Foreign Voice'
  ];

  @override
  void initState() {
    super.initState();
    language = 'TH'; //กำหนดภาษาเริ่มต้นเป็นไทย
    gender = ''; // กำหนดให้เริ่มต้นแสดงทุกเพศ
  }

  @override
  // build: ฟังก์ชันหลักที่แสดงหน้าจอทั้งหมด รวมถึง AppBar และ body ที่เรียกใช้ buildFilterNavbar
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: Align(
          alignment: const FractionalOffset(0.4, 0.6),
          child: SvgPicture.asset(
            'assets/images/logo/appbar-icon.svg',
            width: 30.w,
            height: 34.h,
          ),
        ),
      ),
      body: buildFilterNavbar(context),
    );
  }

// buildFilterNavbar: ส่วนหลักของหน้าจอ แบ่งเป็นแถวต่างๆ เช่น แถวสำหรับปุ่มภาษา เพศ Favorite
// และแถวสำหรับปุ่มตัวกรอง (สไตล์และหมวดหมู่) รวมถึงส่วนแสดงลำโพงและปุ่มยืนยัน
// เพิ่มการแสดง AlertDialog เมื่อเลือกเสียง
  Widget buildFilterNavbar(BuildContext context) {
    return Column(
      children: [
        // เนื้อหาหลักของหน้าจอ
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                // แถวแรกสำหรับปุ่มภาษา, เพศ และ Favorite
                Container(
                  height: 50.h,
                  width: 320.w,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.start, // เปลี่ยนจาก spaceBetween
                      children: [
                        buildLanguageButtonTrigger(context), // ปุ่มภาษา
                        SizedBox(
                            width: 10.w), // เพิ่มระยะห่างระหว่างปุ่มภาษาและเพศ
                        buildGenderButtonTrigger(context), // ปุ่มเพศ
                        SizedBox(
                            width: 10
                                .w), // เพิ่มระยะห่างระหว่างปุ่มเพศและ Favorite
                        Expanded(
                          // ใช้ Expanded เพื่อให้ปุ่ม Favorite ยืดหยุ่น
                          child: buildFavoriteButton(), // ปุ่ม Favorite
                        ),
                      ],
                    ),
                  ),
                ),
                // แถวที่สองสำหรับปุ่มสไตล์และหมวดหมู่
                Container(
                  width: 320.w,
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 1, left: 16, right: 20),
                  child: Row(
                    children: [
                      // ปุ่มสำหรับเลือกสไตล์
                      Flexible(
                        flex: 4,
                        child: buildFilterButton(
                          context,
                          title: selectedStyles.isEmpty
                              ? 'สไตล์'
                              : '${selectedStyles.length} สไตล์',
                          items: voiceStyle,
                          selectedItems: selectedStyles,
                          onConfirm: (newSelected) {
                            setState(() {
                              selectedStyles = newSelected;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      // ปุ่มสำหรับเลือกหมวดหมู่
                      Flexible(
                        flex: 4,
                        child: buildFilterButton(
                          context,
                          title: selectedCategories.isEmpty
                              ? 'หมวดหมู่'
                              : '${selectedCategories.length} หมวดหมู่',
                          items: speechStyle,
                          selectedItems: selectedCategories,
                          onConfirm: (newSelected) {
                            setState(() {
                              selectedCategories = newSelected;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // แสดงลำโพง
                Container(
                  color: const Color(0xFFFFFFFF),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ishover
                          ? buildFavoriteFilter(context)
                          : buildMultipleSpeaker(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // ปุ่ม "ตกลง" ที่ด้านล่างสุดของหน้าจอ
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
          child: SizedBox(
            height: 50.h,
            child: GradientTextButton(
              text: 'ตกลง',
              onPressed: () {
                if (audioPlayer.state == PlayerState.playing) {
                  audioPlayer.stop();
                }
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }

// buildLanguageButton: แสดง Modal สำหรับเลือกภาษา พร้อมรายการตัวเลือกของภาษาที่รองรับ
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
                _buildLanguageFilter(
                    'Arabic - อาหรับ',
                    'assets/images/national_flag/arabic.png',
                    'AR',
                    context,
                    setState),
                _buildLanguageFilter(
                    'German - เยอรมัน',
                    'assets/images/national_flag/german.png',
                    'DE',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Spanish - สเปน',
                    'assets/images/national_flag/spanish.png',
                    'ES',
                    context,
                    setState),
                _buildLanguageFilter(
                    'French - ฝรั่งเศส',
                    'assets/images/national_flag/french.png',
                    'FR',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Dutch - ดัตช์',
                    'assets/images/national_flag/dutch.png',
                    'NL',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Korea - เกาหลี',
                    'assets/images/national_flag/korea.png',
                    'KO',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Malaysia - มาเลเซีย',
                    'assets/images/national_flag/malaysia.png',
                    'MS',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Portuguese - โปรตุเกส',
                    'assets/images/national_flag/portuguese.png',
                    'PT-BR',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Russia - รัสเซีย',
                    'assets/images/national_flag/russiaF.png',
                    'RU',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Hindi - ฮินดู',
                    'assets/images/national_flag/hindi.png',
                    'HI',
                    context,
                    setState),
                _buildLanguageFilter(
                    'Italian - อิตาลี',
                    'assets/images/national_flag/italian.png',
                    'IT',
                    context,
                    setState),
              ],
            ),
          ),
        ],
      ),
    );
  }

// buildFavoriteButton: ปุ่ม Favorite (อยู่ในแถวแรกของหน้าจอ) ใช้สำหรับเปิด/ปิดการแสดงผลลำโพงที่ผู้ใช้ Favorite ไว้
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

// buildGenderButton: แสดง Modal สำหรับเลือกเพศ พร้อมรายการตัวเลือกของเพศที่รองรับ
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

// buildBottomNavbarButton: ปุ่ม "ตกลง" (อยู่ที่ด้านล่างของหน้าจอ) ใช้สำหรับยืนยันการกระทำและปิดหน้าจอ
  Widget buildBottomNavbarButton() {
    return SizedBox(
      height: 60.h,
      width: 320.w,
      child: Padding(
        padding:
            EdgeInsets.only(left: 20.w, top: 10.h, right: 20.w, bottom: 10.h),
        child: SizedBox(
          child: GradientTextButton(
            text: 'ตกลง',
            onPressed: () {
              if (audioPlayer.state == PlayerState.playing) {
                audioPlayer.stop();
              }
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

// _buildLanguageFilter: สร้างรายการตัวเลือกภาษาแต่ละตัวใน Modal ภาษา
  Widget _buildLanguageFilter(String text, String imagePath, String lang,
      BuildContext context, StateSetter setState) {
    return InkWell(
      onTap: () {
        setState(() {
          // เซ็ตค่า language ตาม lang ที่ส่งเข้ามา
          language = lang;
          logger.w("Selected Language: $language");

          List<String> parts = text.split(' - ');
          selectedLanguage = parts.length > 1 ? parts[1] : text;
          selectedLanguageImage = imagePath;

          logger.w("Selected Language: $selectedLanguage");

          // ส่งค่า language ไปที่ repository
          Provider.of<SpeakerRepositoryImpl>(context, listen: false)
              .setLanguage(language!.toLowerCase());
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

// _buildGenderFilter: สร้างรายการตัวเลือกเพศแต่ละตัวใน Modal เพศ
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

// buildMultipleSpeaker: แสดงรายการลำโพงทั้งหมด (อยู่ในส่วนเนื้อหาหลักของหน้าจอ) โดยจะใช้ข้อมูลที่กรองจาก _filterSpeakers
  Widget buildMultipleSpeaker(BuildContext context) {
    final filteredItems = _filterSpeakers(); // ดึงรายการที่ผ่านการกรอง

    if (filteredItems.isEmpty) {
      return Center(
        child: Text(
          'ไม่มีผู้พูดที่ตรงกับเงื่อนไข',
          style: GoogleFonts.prompt(fontSize: 16.sp, color: Colors.black),
        ),
      );
    }

    // ใช้ SingleChildScrollView เพื่อให้กริดสามารถเลื่อนได้
    return SingleChildScrollView(
      child: SizedBox(
        height: 420.h, // ใช้ ScreenUtil เพื่อปรับขนาดตามหน้าจอ
        width: 320.w, // ใช้ ScreenUtil เพื่อปรับขนาดตามหน้าจอ
        child: GridView.builder(
          itemCount: filteredItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // จำนวนคอลัมน์ในกริด
            crossAxisSpacing: 0,
            childAspectRatio: 0.8, // ปรับอัตราส่วนของ child แต่ละตัว
          ),
          itemBuilder: (context, index) {
            final data = filteredItems[index];
            return buildSingleSpeaker(data, index);
          },
        ),
      ),
    );
  }

// _filterSpeakers: ฟังก์ชันกรองลำโพงตามเงื่อนไขที่ผู้ใช้เลือก เช่น ภาษา เพศ สไตล์เสียง หรือหมวดหมู่
  List<SpeakerEntity> _filterSpeakers() {
    List<SpeakerEntity> filteredSpeakers = [];

    // กรองลำโพงตามภาษาที่เลือก
    filteredSpeakers = SpeakerModel.speakerItem.where((item) {
      return item.language == language;
    }).toList();

    // เพิ่ม Log เพื่อตรวจสอบว่าได้กรองตามภาษาแล้ว
    logger.w(
        "Filtered by language ($language): ${filteredSpeakers.length} speakers found");

    // หากไม่มีผู้พูดที่ตรงกับภาษาในฟิลด์ language
    if (filteredSpeakers.isEmpty) {
      filteredSpeakers = SpeakerModel.speakerItem.where((item) {
        return item.availableLanguage.contains(language?.toLowerCase()) &&
            item.language != language; // ไม่แสดงผลที่มี language ตรงเป๊ะ
      }).toList();

      logger.w(
          "Filtered by available language: ${filteredSpeakers.length} speakers found");
    }

    // กรองตามเพศ (ถ้ามีการเลือก)
    if (gender != null && gender!.isNotEmpty) {
      filteredSpeakers =
          filteredSpeakers.where((item) => item.gender == gender).toList();

      // เพิ่ม Log เพื่อตรวจสอบการกรองเพศ
      logger.w(
          "Filtered by gender ($gender): ${filteredSpeakers.length} speakers found");
    }

    // กรองตามสไตล์เสียง (ถ้ามีการเลือก)
    if (selectedStyles.isNotEmpty) {
      filteredSpeakers = filteredSpeakers.where((item) {
        return item.voiceStyle.any((style) => selectedStyles.contains(style));
      }).toList();

      // เพิ่ม Log เพื่อตรวจสอบการกรองสไตล์เสียง
      logger.w(
          "Filtered by voice style: ${filteredSpeakers.length} speakers found");
    }

    // กรองตามหมวดหมู่เสียง (speechStyle) (ถ้ามีการเลือก)
    if (selectedCategories.isNotEmpty) {
      filteredSpeakers = filteredSpeakers.where((item) {
        return item.speechStyle
            .any((category) => selectedCategories.contains(category));
      }).toList();

      // เพิ่ม Log เพื่อตรวจสอบการกรองหมวดหมู่
      logger
          .w("Filtered by category: ${filteredSpeakers.length} speakers found");
    }

    // เพิ่ม log เพื่อดูจำนวนลำโพงที่ผ่านการกรองแล้ว
    logger.i("Total speakers after all filters: ${filteredSpeakers.length}");

    return filteredSpeakers;
  }

// buildSingleSpeaker: สร้างการ์ดแสดงลำโพงแต่ละตัว (เรียกใช้ใน buildMultipleSpeaker และ buildFavoriteFilter)
// พร้อมปุ่มสำหรับเล่นเสียงและ Favorite
  Widget buildSingleSpeaker(SpeakerEntity speakerItem, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 7.h),
          child: GestureDetector(
            onTap: () async {
              String audioURL = speakerItem.audio;
              Future<void> playAudio() async {
                if (audioURL.isNotEmpty) {
                  if (audioPlayer.state == PlayerState.playing) {
                    await audioPlayer.stop();
                  }
                  await audioPlayer.play(UrlSource(audioURL));
                }
              }

              await playAudio();

              Provider.of<SpeakerRepositoryImpl>(context, listen: false)
                  .setSpeakerId(speakerItem.speakerId);
              Provider.of<SpeakerRepositoryImpl>(context, listen: false)
                  .setSpeakerName(speakerItem.thaiName);
              Provider.of<SpeakerRepositoryImpl>(context, listen: false)
                  .setSpeakerAudio(speakerItem.audio);
              Provider.of<SpeakerRepositoryImpl>(context, listen: false)
                  .setSpeakerImagePath(speakerItem.squareImage);
              Provider.of<SpeakerRepositoryImpl>(context, listen: false)
                  .setNationalFlagPath(selectedLanguageImage);
              Provider.of<SpeakerRepositoryImpl>(context, listen: false)
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
                      //TODO: Update Speaker Data
                      image: AssetImage(
                        speakerItem.squareImage,
                      ),
                      onError: (exception, stackTrace) => const AssetImage(
                          'assets/images/default-profile-picture.jpg'),
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
                                        .contains(speakerItem.speakerId)) {
                                      selectedIndexFavorites
                                          .remove(speakerItem.speakerId);
                                    } else {
                                      selectedIndexFavorites
                                          .add(speakerItem.speakerId);
                                    }
                                  });
                                },
                                child: selectedIndexFavorites
                                        .contains(speakerItem.speakerId)
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
                              speakerItem.thaiName,
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

// buildFavoriteFilter: แสดงรายการลำโพงที่ Favorite ไว้ (อยู่ในส่วนเนื้อหาหลักของหน้าจอ)
// แสดงผลเมื่อผู้ใช้เปิดโหมด Favorite
  Widget buildFavoriteFilter(BuildContext context) {
    return SizedBox(
      height: 420.h,
      width: 320.w,
      child: GridView.builder(
        itemCount: SpeakerModel.speakerItem
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
          final data = SpeakerModel.speakerItem
              .where((item) =>
                  selectedIndexFavorites.isEmpty ||
                  selectedIndexFavorites.contains(item.speakerId))
              .toList()[index];

          return buildSingleSpeaker(data, index);
        },
      ),
    );
  }

// buildLanguageButtonTrigger: ปุ่มเลือกภาษา (อยู่ในแถวแรกของหน้าจอ) ใช้สำหรับเปิด Modal
// เพื่อให้ผู้ใช้สามารถเลือกภาษาที่ต้องการ
  Widget buildLanguageButtonTrigger(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = true;
        });
        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return SingleChildScrollView(
                  child: Row(
                    children: [
                      buildLanguageButton(context, setState),
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
            SizedBox(width: 6.w),
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
    );
  }

// buildGenderButtonTrigger: ปุ่มเลือกเพศ (อยู่ในแถวแรกของหน้าจอ) ใช้สำหรับเปิด Modal
// เพื่อให้ผู้ใช้สามารถเลือกเพศที่ต้องการกรองลำโพง
  Widget buildGenderButtonTrigger(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          changeIcon = !changeIcon;
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
    );
  }

// buildFilterButton: ปุ่มเลือกตัวกรอง (สไตล์หรือหมวดหมู่) (อยู่ในแถวที่สองของหน้าจอ)
// ใช้สำหรับเปิด Modal ให้ผู้ใช้เลือกสไตล์เสียงหรือหมวดหมู่เสียงที่ต้องการ
  Widget buildFilterButton(
    BuildContext context, {
    required String title,
    required List<String> items,
    required Set<String> selectedItems,
    required ValueChanged<Set<String>> onConfirm,
  }) {
    bool isExpanded = false; // Local state for the dropdown

    return StatefulBuilder(
      builder: (context, setState) {
        void toggleExpanded() {
          setState(() {
            isExpanded = !isExpanded; // Toggle the expanded state
          });
        }

        return InkWell(
          onTap: () {
            toggleExpanded(); // Open or close the dropdown

            // Open the Modal Selection
            showModalSelection(
              context: context,
              title: title,
              items: items,
              selectedItems: selectedItems,
              onConfirm: (newSelected) {
                onConfirm(newSelected); // Update selection
                toggleExpanded(); // Close the dropdown
              },
            ).whenComplete(() {
              // Reset the state when the modal is dismissed
              setState(() {
                isExpanded = false;
              });
            });
          },
          child: Container(
            width: 150.w,
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
                Text(
                  title,
                  style: GoogleFonts.prompt(fontSize: 14.sp),
                ),
                SizedBox(width: 6.w),
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_sharp // ^ when expanded
                      : Icons.keyboard_arrow_down_sharp, // v when collapsed
                  size: 20,
                  color: const Color(0xFF323130),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// showModalSelection: แสดง Modal สำหรับเลือกตัวกรอง (สไตล์หรือหมวดหมู่) โดยมีรายการตัวเลือก
// และปุ่ม "ตกลง" หรือ "ยกเลิก"
  Future<void> showModalSelection({
    required BuildContext context,
    required String title,
    required List<String> items,
    required Set<String> selectedItems,
    required ValueChanged<Set<String>> onConfirm,
  }) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (BuildContext context) {
        Set<String> tempSelectedItems = Set.from(selectedItems);
        return FractionallySizedBox(
          heightFactor: 0.6, // เพิ่มขนาด Modal ให้เหมาะสม
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.prompt(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // ปรับให้เหมาะสมกับขนาดของรายการ
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3, // ลดขนาดของรายการให้เล็กลง
                    ),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = tempSelectedItems.contains(item);
                      return GestureDetector(
                        onTap: () {
                          if (isSelected) {
                            tempSelectedItems.remove(item);
                          } else {
                            tempSelectedItems.add(item);
                          }
                          (context as Element).markNeedsBuild(); // Update UI
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF01BFFB)
                                : Colors.white,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF01BFFB)
                                  : const Color(0xFFE2E3E9),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              item,
                              style: GoogleFonts.prompt(
                                fontSize: 12.sp, // ขนาดฟอนต์ลดลงเพื่อให้เหมาะสม
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(
                              double.infinity, 50.h), // เพิ่มขนาดให้ใหญ่ขึ้น
                        ),
                        onPressed: () {
                          tempSelectedItems.clear(); // Reset selection
                          (context as Element).markNeedsBuild(); // Update UI
                        },
                        child: Text(
                          'รีเซ็ต',
                          style: GoogleFonts.prompt(
                              fontSize: 12.sp, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF01BFFB),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size(
                              double.infinity, 50.h), // เพิ่มขนาดให้ใหญ่ขึ้น
                        ),
                        onPressed: () {
                          onConfirm(tempSelectedItems);
                          Navigator.pop(context); // Close the modal
                        },
                        child: Text(
                          'ตกลง',
                          style: GoogleFonts.prompt(
                              fontSize: 12.sp, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
