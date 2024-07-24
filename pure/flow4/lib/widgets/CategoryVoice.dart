import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flow3/filters/advert.dart';
import 'package:flow3/filters/all.dart';
import 'package:flow3/filters/favorite.dart';
// import 'package:flow3/filters/favorite.dart';
import 'package:flow3/filters/language.dart';
import 'package:flow3/filters/new.dart';
import 'package:flow3/filters/podcast.dart';
import 'package:flow3/filters/recomman.dart';
import 'package:flow3/filters/sex.dart';
import 'package:flow3/filters/voice.dart';
// import 'package:flow3/model/favoritemodel.dart';
import 'package:flow3/widgets/favoriteVoice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flow3/data/data.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
// import 'package:provider/provider.dart';
// import 'package:flow3/widgets/story_viewer.dart';

class CategoryVoice extends StatefulWidget {
  const CategoryVoice({
    super.key,
    // required this.onToggleFavorite,
  });
  // final void Function(Data data) onToggleFavorite;

  @override
  _CategoryVoiceState createState() => _CategoryVoiceState();
}

class _CategoryVoiceState extends State<CategoryVoice> {
  bool ishover = false;
  @override
  Widget build(BuildContext context) {
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      const New(),
                      const Voice(),
                      const Advert(),
                      const Podcast(),
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
                  : VoiceWidget(
                      screenSizeheight: screenSizeheight,
                      screenSizewidth: screenSizewidth,
                      data: data,
                    )
            ],
          ),
        ),
      ],
    );
  }
}

class VoiceWidget extends StatefulWidget {
  const VoiceWidget({
    super.key,
    required this.screenSizeheight,
    required this.screenSizewidth,
    required this.data,
    // required this.onToggleFavorite,
  });

  final double screenSizeheight;
  final double screenSizewidth;
  final List<Data> data;
  // final void Function(Data data) onToggleFavorite;

  @override
  State<VoiceWidget> createState() => _VoiceWidgetState();
}

class _VoiceWidgetState extends State<VoiceWidget> {
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
  Widget build(BuildContext context) {
    return Container(
     
      height: 127.h,
      width: 320.w,
      child: GridView.builder(
        itemCount: widget.data.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisExtent: 125,
        ),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15.w),
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
                        width: 81.w,
                        height: 103.h,
                        decoration: BoxDecoration(
                          border: GradientBoxBorder(
                            width: 3.w,
                            gradient: selectedIndex.contains(index)
                                ? const LinearGradient(
                                    colors: [
                                      Color(0xFF9A96F5),
                                      Color(0xFF00E0FF)
                                    ],
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
                              widget.data[index].image,
                            ),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 10,
                              spreadRadius: 1,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      widget.data[index].name,
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
}
