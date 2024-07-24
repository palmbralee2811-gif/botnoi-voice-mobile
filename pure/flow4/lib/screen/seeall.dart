import 'package:auto_size_text/auto_size_text.dart';
import 'package:flow3/data/data.dart';
import 'package:flow3/filters/advert.dart';
import 'package:flow3/filters/commandie.dart';
import 'package:flow3/filters/discreetly.dart';
import 'package:flow3/filters/favorite.dart';
import 'package:flow3/filters/fresh.dart';
import 'package:flow3/filters/language.dart';
import 'package:flow3/filters/new.dart';
import 'package:flow3/filters/podcast.dart';
import 'package:flow3/filters/recomman.dart';
import 'package:flow3/filters/sad.dart';
import 'package:flow3/filters/sex.dart';
import 'package:flow3/filters/voice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class SeeAll extends StatefulWidget {
  const SeeAll({super.key});

  @override
  State<SeeAll> createState() => _SeeAllState();
}

class _SeeAllState extends State<SeeAll> {
  final data = AppDataBase.data;
  Set<int> selectedIndex2 = <int>{};
  Set<int> selectedIndex = <int>{};
  bool ishover = false;
  // int selectedIndex = -1;
  // int selectedIndex2 = -1;

  @override
  Widget build(BuildContext context) {
    double screenSizewidth = MediaQuery.of(context).size.width;
    // double screenSizeheight = MediaQuery.of(context).size.height;
    final data = AppDataBase.data;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        leading: Builder(
          builder: (context) {
            return IconButton(
              padding: EdgeInsets.only(left: 15.w),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 24.sp,
                color: const Color(0xFF323130),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        title: Padding(
          padding: EdgeInsets.only(left: 86.w),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
           
            ClipOval(
              child: Image.asset(
                'assets/logo/App_Icon.png',
                width: 35.w,
                height: 35.h,
                fit: BoxFit.cover,
              ),
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
                  const Language(),
                  const Sex(),
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
                  )
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
              child: const Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 13.0,
                  runSpacing: 13.0,
                  children: [
                    New(),
                    Voice(),
                    Advert(),
                    Podcast(),
                    Commandie(),
                    Fresh(),
                    Discreetly(),
                    Sad(),
                  ]),
            ),
          ),
          Column(
            children: [
              Container(
                color: Colors.white,
                height: 400.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 400.h,
                      width: 320.w,
                      child: GridView.builder(
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 0,
                          childAspectRatio: 0.8,
                        ),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 5.w, right: 5.w, top: 7.h),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      if (selectedIndex.contains(index)) {
                                        selectedIndex.remove(index);
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
                                            gradient: selectedIndex
                                                    .contains(index)
                                                ? const LinearGradient(colors: [
                                                    Color(0xFF9A96F5),
                                                    Color(0xFF00E0FF)
                                                  ])
                                                : const LinearGradient(colors: [
                                                    Colors.transparent,
                                                    Colors.transparent
                                                  ]),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          image: DecorationImage(
                                            image:
                                                NetworkImage(data[index].image),
                                            fit: BoxFit.cover,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: selectedIndex
                                                      .contains(index)
                                                  ? Colors.blue.withOpacity(0.5)
                                                  : Colors.transparent,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 5.w,
                                                      top: 5.w,
                                                      left: 5.w),
                                                  child: selectedIndex
                                                          .contains(index)
                                                      ? Container(
                                                          width: 31.w,
                                                          height: 17.h,
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient:
                                                                const LinearGradient(
                                                              colors: [
                                                                Color(
                                                                    0xFF9A96F5),
                                                                Color(
                                                                    0xFF00E0FF)
                                                              ],
                                                            ),
                                                            color: Colors.white,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.r),
                                                          ),
                                                          child: Center(
                                                            child: Text('เลือก',
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontStyle: GoogleFonts
                                                                          .prompt()
                                                                      .fontStyle,
                                                                  fontSize:
                                                                      10.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                )),
                                                          ),
                                                        )
                                                      : const Icon(
                                                          Icons.check,
                                                          color: Colors
                                                              .transparent,
                                                        ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 5.w, top: 5.w),
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        if (selectedIndex2
                                                            .contains(index)) {
                                                          selectedIndex2
                                                              .remove(index);
                                                        } else {
                                                          selectedIndex2
                                                              .add(index);
                                                        }
                                                      });
                                                    },
                                                    child: selectedIndex2
                                                            .contains(index)
                                                        ? ShaderMask(
                                                            shaderCallback:
                                                                (Rect bounds) {
                                                              return const LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                      0xFF9A96F5),
                                                                  Color(
                                                                      0xFF00E0FF)
                                                                ],
                                                              ).createShader(
                                                                  bounds);
                                                            },
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/logo/heart (1).svg',
                                                              width: 20.w,
                                                              height: 20.h,
                                                              color:
                                                                  Colors.white,
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 12.w,
                                                ),
                                                selectedIndex.contains(index)
                                                    ? ShaderMask(
                                                        shaderCallback:
                                                            (Rect bounds) {
                                                          return const LinearGradient(
                                                            colors: [
                                                              Color(0xFF9A96F5),
                                                              Color(0xFF00E0FF)
                                                            ],
                                                          ).createShader(
                                                              bounds);
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
                                                SizedBox(width: 3.w),
                                                Expanded(
                                                  child: AutoSizeText(
                                                    data[index].name,
                                                    style: GoogleFonts.prompt(
                                                      fontSize: 10.sp,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    softWrap: true,
                                                    overflow:
                                                        TextOverflow.visible,
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
                    ),
                  ],
                ),
              ),
              Container(
                height: 64.h,
                width: screenSizewidth * 0.78.w,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(bottom: 20.w, left: 20.w, right: 20.w),
                  child: SizedBox(
                    child: GradientButton(
                      text: 'ส่งข้อเสนอแนะ',
                      onPressed: () {
                        print('ส่งข้อเสนอแนะ');
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  GradientButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Text(text,
            style: GoogleFonts.prompt(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
