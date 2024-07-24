import 'package:botnoivoice/Database/data.dart';
import 'package:botnoivoice/Filters/advert.dart';
import 'package:botnoivoice/Filters/all.dart';
import 'package:botnoivoice/Filters/commandie.dart';
import 'package:botnoivoice/Filters/discreetly.dart';
import 'package:botnoivoice/Filters/favorite.dart';
import 'package:botnoivoice/Filters/fresh.dart';
import 'package:botnoivoice/Filters/language.dart';
import 'package:botnoivoice/Filters/new.dart';
import 'package:botnoivoice/Filters/podcast.dart';
import 'package:botnoivoice/Filters/recomman.dart';
import 'package:botnoivoice/Filters/sad.dart';
import 'package:botnoivoice/Filters/sex.dart';
import 'package:botnoivoice/Filters/voice.dart';
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
  bool ishover = false;
  int selectedIndex = -1;
  int selectedIndex2 = -1;

  @override
  Widget build(BuildContext context) {
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;
    final data = AppDataBase.data;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: Padding(
          padding: EdgeInsets.only(left: 89.w),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            // Icon(
            //   Icons.arrow_back_ios_new,
            //   size: 24.sp,
            //   color: const Color(0xFF323130),
            // ),
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
                  const All(),
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
                    // New(),
                    // Voice(),
                    // Advert(),
                    // Podcast(),
                    // Commandie(),
                    // Fresh(),
                    // Discreetly(),
                    // Sad(),
                  ]),
            ),
          ),
          Column(
            children: [
              Container(
                color: Colors.white,
                height: 412.h,
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
                                      selectedIndex = index;
                                    });
                                    //////////
                                  },
                                  child: Expanded(
                                    child: Container(
                                      width: 90.w,
                                      height: 113.h,
                                      decoration: BoxDecoration(
                                        border: GradientBoxBorder(
                                          width: 3.w,
                                          gradient: selectedIndex == index
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
                                          image: NetworkImage(data[index].squareImage),
                                          fit: BoxFit.cover,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: selectedIndex == index
                                                ? Colors.blue.withOpacity(0.5)
                                                : Colors.transparent,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 25.w,
                                                          top: 4.w),
                                                      child:
                                                          selectedIndex == index
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
                                                                    color: Colors
                                                                        .white,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            8.r),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                        'เลือก',
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.white,
                                                                          fontStyle:
                                                                              GoogleFonts.prompt(
                                                                            fontSize:
                                                                                10.sp,
                                                                            fontWeight:
                                                                                FontWeight.bold,
                                                                          ).fontStyle,
                                                                        )),
                                                                  ),
                                                                )
                                                              : const Icon(
                                                                  Icons.check,
                                                                  color: Colors
                                                                      .transparent,
                                                                ),
                                                    ),
                                                    GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            selectedIndex2 =
                                                                index;
                                                          });
                                                        },
                                                        child: selectedIndex2 ==
                                                                index
                                                            ? ShaderMask(
                                                                shaderCallback:
                                                                    (Rect
                                                                        bounds) {
                                                                  return const LinearGradient(
                                                                    colors: [
                                                                      Color(
                                                                          0xFF9A96F5),
                                                                      Color(
                                                                          0xFF00E0FF),
                                                                    ],
                                                                  ).createShader(
                                                                      bounds);
                                                                },
                                                                child:
                                                                    SvgPicture
                                                                        .asset(
                                                                  'assets/logo/heart (1).svg',
                                                                  width: 16.w,
                                                                  height: 16.h,
                                                                  color: Colors
                                                                      .white, // Optional: Default color of the SVG
                                                                ),
                                                              )
                                                            : SvgPicture.asset(
                                                                'assets/logo/heart.svg',
                                                                width: 16.sp,
                                                                height: 16.sp,
                                                              ))
                                                  ]),
                                              const Spacer(),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    selectedIndex == index
                                                        ? ShaderMask(
                                                            shaderCallback:
                                                                (Rect bounds) {
                                                              return const LinearGradient(
                                                                colors: [
                                                                  Color(
                                                                      0xFF9A96F5),
                                                                  Color(
                                                                      0xFF00E0FF),
                                                                ],
                                                              ).createShader(
                                                                  bounds);
                                                            },
                                                            child: SvgPicture
                                                                .asset(
                                                              'assets/logo/Vector.svg',
                                                              width:
                                                                  screenSizeheight *
                                                                      0.01.h,
                                                              height:
                                                                  screenSizeheight *
                                                                      0.017.h,
                                                              color: Colors
                                                                  .white, // Optional: Default color of the SVG
                                                            ),
                                                          )
                                                        : SvgPicture.asset(
                                                            'assets/logo/Vector (1).svg',
                                                            width:
                                                                screenSizeheight *
                                                                    0.005.h,
                                                            height:
                                                                screenSizeheight *
                                                                    0.017.h,
                                                          ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Text(
                                                      softWrap: true,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: null,
                                                      data[index].thaiName,
                                                      style: GoogleFonts.prompt(
                                                        fontSize: 10.sp,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ])
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
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
                                  "ตกลง",
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
