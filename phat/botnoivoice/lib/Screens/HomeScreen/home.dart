import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Database/data.dart';
import 'package:botnoivoice/Function/randomString.dart';
import 'package:botnoivoice/Screens/HomeScreen/gradient_icon_home.dart';
import 'package:botnoivoice/Screens/HomeScreen/gradient_text_home.dart';
import 'package:botnoivoice/Screens/LoginScreen/login.dart';
import 'package:botnoivoice/Screens/my_home_page.dart';
import 'package:botnoivoice/Widgets/favoritevoice.dart';
import 'package:botnoivoice/widgets/custom_app_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:open_app_file/open_app_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'drawer_appbar.dart';
import 'gradient_button_home.dart';
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
  String? language;
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
    // final auth = Provider.of<Authentication>(context, listen: false);
    // print("Printing initial state ${auth.credentialsToken}"); 
    fetchedCredits();
    super.initState();
  }
  Future<void> fetchedCredits() async{
    final auth = Provider.of<Authentication>(context, listen: false);
    credits = auth.getProfileWithToken(auth.jwtToken).toString();

    print('(Credit) JWT token isss : ${auth.jwtToken}');
  }

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
      drawer: DrawerAppbar(
        auth: auth,
        email: email,
        screenSizeheight: screenSizeheight,
      ),
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
        title: CustomAppBar(context),
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
                              cursorColor: const Color(0xFF000000),
                              style: GoogleFonts.prompt(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF323130)),
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
                                      _showClearIcon ==
                                              textController.text.isNotEmpty
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
                                                      // _showClearIcon =
                                                      //     false; // To update the counter
                                                    });
                                                  },
                                                  child: Icon(
                                                    Icons.close_sharp,
                                                    size: 20.sp,
                                                    color: Colors.transparent,
                                                  )),
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
                                                    // _showClearIcon =
                                                    //     false; // To update the counter
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
                // InkWell(
                //   onTap: () {
                //     if (_selectedPageIndexSetting == 0) {
                //       _selectPageSetting(1);
                //     } else if (_selectedPageIndexSetting == 1) {
                //       _selectPageSetting(2);
                //     } else if (_selectedPageIndexSetting == 2) {
                //       _selectPageSetting(1);
                //     }
                //   },
                //   child: Setting(
                //       screenSizeheight: screenSizeheight,
                //       selectedPageIndexSetting: _selectedPageIndexSetting),
                // ),
                // if (_selectedPageIndexSetting == 1) ...[
                //   const CategorySetting()
                // ],
                Expanded(
                  child: InkWell(onTap: () {}, child: buildVoiceHome(context)),
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

  // Widget appBar(BuildContext context) {
  //   final auth = Provider.of<Authentication>(context);
  //   credits = auth.credits;
  //   print('credits iss ${credits}');
  //   return SafeArea(
  //     child: Column(
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Padding(
  //               padding: EdgeInsets.only(left: 88.w, top: 5.h),
  //               child: CircleAvatar(
  //                 backgroundColor: Colors.white,
  //                 child: Image.asset(
  //                   'assets/logo/Aboutus_icon.png',
  //                   width: 25.w,
  //                   height: 25.h,
  //                   fit: BoxFit.cover,
  //                 ),
  //               ),
  //             ),
  //             Padding(
  //               padding: EdgeInsets.only(right: 5.w),
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     children: [
  //                       Container(
  //                         decoration: BoxDecoration(
  //                           boxShadow: const [
  //                             BoxShadow(
  //                               color: Color.fromARGB(255, 224, 221, 221),
  //                               blurRadius: 3.0,
  //                             ),
  //                           ],
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(50),
  //                         ),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             SizedBox(width: 5.w),
  //                             SizedBox(
  //                               height: 25.h,
  //                               width: 20.h,
  //                               child: Padding(
  //                                 padding: const EdgeInsets.all(2),
  //                                 child: Column(
  //                                   mainAxisAlignment: MainAxisAlignment.center,
  //                                   children: [
  //                                     Image.asset(
  //                                       'assets/logo/point.png',
  //                                       width: 20.w,
  //                                       height: 20.h,
  //                                     ),
  //                                   ],
  //                                 ),
  //                               ),
  //                             ),
  //                             Column(
  //                               children: [
  //                                 Text(
  //                                   ' ${credits ?? " N/A"}',
  //                                   style: GoogleFonts.prompt(
  //                                     fontSize: 12.sp,
  //                                     fontWeight: FontWeight.w600,
  //                                     color: const Color(0xFF323130),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             SizedBox(width: 5.w),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  bool ishover = false;
  Widget categoryVoiceHome(BuildContext context) {
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;

    // var screenSize = MediaQuery.of(context).size;
    final data = AppDataBase.data;
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
                width: 600.w,
                child: Padding(
                  padding: EdgeInsets.only(right: 10.w, left: 10.w),

                  // Remove const when Open Language !!!!!!!

                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // const Language(),
                      // const Sex(),
                      // const Recommand(),
                      // InkWell(
                      //   onTap: () {
                      //     setState(() {
                      //       ishover = !ishover;
                      //     });
                      //   },
                      //   child: Favorite(ishover: ishover),
                      // ),
                      // const All(),
                      // const New(),
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
          // color: Colors.amber,
          color: const Color(0xFFFFFFFF),
          height: 148.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ishover
                  ? FavoriteVoice(
                      screenSizeheight: screenSizeheight,
                      screenSizewidth: screenSizewidth,
                      data: data,
                    )
                  : voiceWidGetHome(context)
            ],
          ),
        ),
      ],
    );
  }

  Widget voiceWidGetHome(BuildContext context) {
    double screenSizewidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: 140.h,
      width: screenSizewidth * 0.95.w,
      child: GridView.builder(
        itemCount: AppDataBase.data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisExtent: 150,
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final data = AppDataBase.data[index];

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
                        if (audioPlayer.state == PlayerState.playing) {
                          audioPlayer.pause();
                        }
                      } else {
                        // Clear the previously selected index before adding the new one
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
                                ? const LinearGradient(colors: [
                                    Color(0xFF9A96F5),
                                    Color(0xFF00E0FF)
                                  ])
                                : const LinearGradient(colors: [
                                    Colors.transparent,
                                    Colors.transparent
                                  ]),
                          ),
                          borderRadius: BorderRadius.circular(8.r),
                          image: DecorationImage(
                            image: NetworkImage(
                              AppDataBase.data[index].squareImage,
                            ),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: selectedIndex.contains(index)
                                  ? Colors.blue.withOpacity(0.5)
                                  : Colors.transparent,
                              offset: const Offset(0, 2),
                            ),
                          ],
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
                                        if (selectedIndex2.contains(index)) {
                                          selectedIndex2.remove(index);
                                        } else {
                                          // widget.onToggleFavorite(widget.data[index]);
                                          selectedIndex2.add(index);
                                        }
                                      });
                                    },
                                    child: selectedIndex2.contains(index)
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
                                              color: Colors.white,
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
                                  width: 15.w,
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
                                          width: 16.h,
                                          height: 16.w,
                                          color: Colors.white,
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
                                  child: AutoSizeText(
                                    AppDataBase.data[index].thaiName,
                                    style: GoogleFonts.prompt(
                                      fontSize: 10.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    softWrap: true,
                                    overflow: TextOverflow.visible,
                                    maxLines: 2,
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
            ],
          );
        },
      ),
    );
  }

  Widget buildVoiceHome(BuildContext context) {
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;

    return Container(
      height: screenSizeheight * 0.093.h,
      width: screenSizewidth * 0.78.w,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // const Spacer(),
              InkWell(
                onTap: () {
                  /////////////////////////////////////////////////////////////////////////////////////
                },
                child: Container(
                  height: 55.h,
                  width: screenSizewidth * 0.7.w,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                    ),
                  ),
                  child:
                      // Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         "สร้างเสียง",
                      //         style: GoogleFonts.prompt(
                      //           fontSize: 16.sp,
                      //           fontWeight: FontWeight.bold,
                      //           color: const Color(0xFFFFFFFF),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      GradientButtonHome(
                    text: 'สร้างเสียง',
                    onPressed: () async {

                      print('สร้างเสียง');

                      // await generateAudio(textController.text).then((_) {
                      //   print('response $_response');
                      //   downloadFile();
                      //   print('progress -> downloadFile(): $progress \n');
                      // });

                      setState(() {
                        if (textController.text.isNotEmpty) {
                          audioPlayer.stop();
                        }
                      });
                      if (!isLoading) {
                        if (textController.text.isNotEmpty) {
                          await generateAudio(textController.text).then((_) {
                            print('response $_response');
                            downloadFile();
                            print('progress -> downloadFile(): $progress \n');
                            setState(() {
                              final auth = Provider.of<Authentication>(context, listen: false);
                              credits = auth.getProfileWithToken(auth.jwtToken).toString();
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const MyHomePage()),
                            );
                          });
                        }
                      }
                      print("\n### END generateAudio -> Line 410 ### \n");
                    },
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Future<void> generateAudio(String text) async {
    setState(() {
      isLoading = true;
      _response = '';
      _audioUrl = '';
    });
    
    final auth = Provider.of<Authentication>(context, listen: false);
    print('Printting auth when generating ${auth.credentialsToken}');
    /* 
    // ดึงข้อมูล point มาเก็บไว้ในตัวแปร แล้วทำการหักคะแนน ตาม จำนวนตัวอักษร ที่ผู้ใช้งาน สร้างเสียง

    String credits = auth.credits; 
    int creditsInt = int.parse(credits); 

    creditsInt = creditsInt - textController.text.length; 
    credits = creditsInt.toString(); 
    print("update credits: $credits");
    */
  
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
      }else if(response.statusCode==404){
        _response =
              "Not enough credits: ${response.statusCode}";
        print("not enough credits");
      } 
      else if (response.statusCode==403){
        setState(() {
          _response =
              "Something went wrong: ${response.statusCode}";
          isLoading = false;
        });
      }
      else{
        setState(() {
            _response =
                "Failed to retrieve data. Status Code: ${response.statusCode}";
            isLoading = false;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
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
}
