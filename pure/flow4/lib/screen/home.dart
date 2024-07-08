// import 'dart:ffi';

import 'package:flow3/widgets/CategorySetting.dart';
import 'package:flow3/widgets/CategoryVoice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  final int maxLength = 1000;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
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
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;

    double screenSizeheightInputtextOpen = MediaQuery.of(context).size.height;
    double screenSizeheightInputtextClose = MediaQuery.of(context).size.height;
    // int currentIndex = 0;
    final screenHeightOpen = screenSizeheightInputtextOpen;
    final maxLinesopen = (screenHeightOpen / 58).floor();
    final screenHeightClose = screenSizeheightInputtextOpen;
    final maxLinesclose = (screenHeightClose / 150).floor();
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
      drawer: Drawer(
        elevation: 16,
        backgroundColor: Colors.white,
        shadowColor: Colors.black,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 20.0.r,
                        child: SvgPicture.asset(
                          'assets/logo/logo.svg',
                          width: 40.0.w,
                          height: 40.0.h,
                        ),
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                            textStyle: TextStyle(fontSize: 10.sp),
                          ),
                          onPressed: () {
                            // To update the counter
                          },
                          child: Icon(
                            Icons.menu,
                            color: const Color(0xFF323130),
                            size: 32.sp,
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Nonnssssssss',
                        style: GoogleFonts.prompt(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF323130),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('UID:sdsdasdadassssssssssss',
                          style: GoogleFonts.prompt(
                            fontSize: 14.sp,
                            color: const Color(0xFF323130),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: GradientIcon(
                icon: Icons.account_circle_outlined,
                size: 24.sp,
                gradient: const LinearGradient(
                  colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              title: GradientText(
                text: 'ข้อมูลส่วนตัว',
                style: GoogleFonts.prompt(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFA19F9D),
                ),
                gradient: const LinearGradient(
                  colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.credit_card_rounded,
                size: 24.sp,
                color: const Color(0xFF323130),
              ),
              title: Text(
                'แพ็คเกจ',
                style: GoogleFonts.prompt(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF323130),
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.question_mark_outlined,
                size: 24.sp,
                color: const Color(0xFF323130),
              ),
              title: Text(
                'FAQ',
                style: GoogleFonts.prompt(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF323130),
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.email_outlined,
                size: 24.sp,
                color: const Color(0xFF323130),
              ),
              title: Text(
                'ข้อเสนอแนะ',
                style: GoogleFonts.prompt(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF323130),
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(
                Icons.credit_card_sharp,
                size: 24.sp,
                color: const Color(0xFF323130),
              ),
              title: Text(
                'เกี่ยวกับเรา',
                style: GoogleFonts.prompt(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF323130),
                ),
              ),
              onTap: () {},
            ),
            Expanded(
                child: Opacity(
              opacity: 0.5, // 50% opacity
              child: Container(
                width: 200.w,
                height: 250.h,
                color: Colors.transparent,
              ),
            )),
            SizedBox(
              width: 62.w,
              height: 30.h,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/logo/Ellipse 12.jpg',
                        width: 24.w,
                        height: 24.w,
                      ),
                      SizedBox(
                        width: 6.w,
                      ),
                      Text(
                        'ไทย',
                        style: GoogleFonts.prompt(
                            fontSize: 20.sp, fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                        width: 80.w,
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_sharp,
                        size: 24.sp,
                        color: const Color(0xFF323130),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Appbar(),
      ),
      body: Column(
        children: <Widget>[
          // SafeArea(
          // child:
          // Column(
          //   children: [
          //     Container(
          //       color: Colors.white,
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           SizedBox(
          //             width: 55.w,
          //           ),
          //           Image.asset(
          //             'assets/logo/Frame.png',
          //             width: 30.w,
          //             height: 34.h,
          //           ),
          //           Column(
          //             children: [
          //               Row(
          //                 children: [
          //                   Container(
          //                     width: 54.w,
          //                     decoration: BoxDecoration(
          //                       boxShadow: const [
          //                         BoxShadow(
          //                           color: Color.fromARGB(255, 224, 221, 221),
          //                           blurRadius: 3.0,
          //                         ),
          //                       ],
          //                       color: Colors.white,
          //                       borderRadius: BorderRadius.circular(50.r),
          //                     ),
          //                     child: Row(
          //                       mainAxisAlignment: MainAxisAlignment.center,
          //                       children: [
          //                         SizedBox(
          //                           height: 25.h,
          //                           width: 20.h,
          //                           child: Padding(
          //                             padding: const EdgeInsets.all(2),
          //                             child: Column(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.center,
          //                               children: [
          //                                 Image.asset(
          //                                   'assets/logo/point.png',
          //                                   width: 20.w,
          //                                   height: 20.h,
          //                                 ),
          //                               ],
          //                             ),
          //                           ),
          //                         ),
          //                         Column(
          //                           children: [
          //                             Text(
          //                               '100',
          //                               style: GoogleFonts.prompt(
          //                                 fontSize: 12.sp,
          //                                 fontWeight: FontWeight.bold,
          //                                 color: const Color(0xFF323130),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ],
          //                     ),
          //                   ),
          //                 ],
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          // ),
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
                      width: screenSizewidth * 0.70.w,
                      // height: _inputtext == 1
                      //     ? screenSizeheightInputtextClose * 0.19.h
                      //     : screenSizeheightInputtextOpen * 0.20.h,
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
                              style: const TextStyle(color: Colors.black),
                              minLines: _inputtext == 1
                                  ? maxLinesclose
                                  : maxLinesopen,
                              maxLines: _inputtext == 1
                                  ? maxLinesclose
                                  : maxLinesopen,
                              keyboardType: TextInputType.multiline,
                              controller: _textController,
                              onChanged: (text) {
                                if (_textController.text.length >
                                    widget.maxLength) {
                                  _textController.text = _textController.text
                                      .substring(0, widget.maxLength);
                                  _textController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: _textController.text.length),
                                  );
                                }
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    'พิมพ์ข้อความให้ตรงกับภาษาที่เลือก . . .',
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontStyle:
                                        GoogleFonts.prompt(fontSize: 14.sp)
                                            .fontStyle),
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
                                      Padding(
                                        padding: EdgeInsets.only(right: 1.w),
                                        child: TextButton(
                                            style: TextButton.styleFrom(
                                              textStyle:
                                                  TextStyle(fontSize: 10.sp),
                                            ),
                                            onPressed: () {
                                              _textController.clear();
                                              setState(
                                                  () {}); // To update the counter
                                            },
                                            child: GradientIcon(
                                              icon: Icons.close_sharp,
                                              size: 20.sp,
                                              gradient: const LinearGradient(
                                                colors: [
                                                  Color(0xFF9340FF),
                                                  Color(0xFF34BDFA)
                                                ],
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      GradientText(
                                        text: '${_textController.text.length}',
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
            ), // 60% of the screen height
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
                if (_selectedPageIndexVoice == 1) ...[const CategoryVoice()],
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
                  child: InkWell(
                      onTap: () {
                        /////////////////
                      },
                      child: const BuildVoice()),
                ),
                // Container(
                //     height: screenSizeheight * 0.052.h,
                //     width: screenSizewidth * 0.78.w,
                //     color: const Color(0xFF27282B),
                //     child: InkWell(
                //       onTap: () {},
                //       child: currentIndex == 1
                //           ? SvgPicture.asset(
                //               'assets/logo/Property 1=studio, Property 2=deault (2).svg')
                //           : SvgPicture.asset(
                //               'assets/logo/Property 1=studio, Property 2=hover (1).svg'),
                //     ))
              ]), // 40% of the screen height
            ),
          ),
        ],
      ),
    );
  }
}

class Selectvoice extends StatelessWidget {
  const Selectvoice({
    super.key,
    required this.screenSizeheight,
    required int selectedPageIndexVoice,
  }) : _selectedPageIndexVoice = selectedPageIndexVoice;

  final double screenSizeheight;
  final int _selectedPageIndexVoice;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: screenSizeheight * 0.05.h,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: const Color(0xFFE2E3E9),
              width: 1.w,
            )),
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
                      )),
          ],
        ));
  }
}

class Setting extends StatelessWidget {
  const Setting({
    super.key,
    required this.screenSizeheight,
    required int selectedPageIndexSetting,
  }) : _selectedPageIndexSetting = selectedPageIndexSetting;

  final double screenSizeheight;
  final int _selectedPageIndexSetting;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: screenSizeheight * 0.05.h,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: const Color(0xFFE2E3E9),
              width: 1.w,
            )),
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
                      )),
          ],
        ));
  }
}

class Appbar extends StatelessWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 90.w),
                child: Image.asset(
                  'assets/logo/Frame.png',
                  width: 30.w,
                  height: 34.h,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 54.w,
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
                                Text(
                                  '100',
                                  style: GoogleFonts.prompt(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF323130),
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
            ],
          ),
        ],
      ),
    );
  }
}

class BuildVoice extends StatefulWidget {
  const BuildVoice({super.key});

  @override
  State<BuildVoice> createState() => _BuildVoiceState();
}

class _BuildVoiceState extends State<BuildVoice> {
  @override
  Widget build(BuildContext context) {
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
                        color: Color.fromARGB(255, 224, 221, 221),
                        blurRadius: 6.0,
                      ),
                    ],
                    borderRadius: BorderRadius.circular(10.r),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "สร้างเสียง",
                        style: GoogleFonts.prompt(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFFFFFFF),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  final String text;

  final TextStyle style;
  final Gradient gradient;

  GradientText({
    required this.text,
    required this.style,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient
            .createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height));
      },
      child: Text(
        text,
        style: style.copyWith(color: Colors.white), // text color จะไม่ถูกใช้
      ),
    );
  }
}

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  GradientIcon({
    required this.icon,
    required this.size,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(Rect.fromLTWH(0, 0, size, size));
      },
      child: Icon(
        icon,
        size: size,
        color: Colors.white, // icon color จะไม่ถูกใช้
      ),
    );
  }
}
