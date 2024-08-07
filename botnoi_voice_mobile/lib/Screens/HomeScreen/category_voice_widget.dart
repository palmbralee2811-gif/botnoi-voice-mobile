import 'package:botnoi_voice_mobile/MainServer/ObjectModels/speaker_metadata_model.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/Filters/favourite_genre_filter.dart';
import 'package:botnoi_voice_mobile/Screens/HomeScreen/favourite_voice_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class CategoryVoiceWidget extends StatefulWidget {
  const CategoryVoiceWidget({
    super.key,
  });

  @override
  State<CategoryVoiceWidget> createState() => _CategoryVoiceWidgetState();
}

class _CategoryVoiceWidgetState extends State<CategoryVoiceWidget> {
  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;

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
                      // const Language(),
                      // const Sex(),
                      // const Recommand(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _isSelected = !_isSelected;
                          });
                        },
                        child: FavouriteGenreFilter(isSelected: _isSelected),
                      ),
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
              _isSelected
                  ? FavoriteVoiceWidget(
                      screenSizeheight: screenSizeheight,
                      screenSizewidth: screenSizewidth,
                      speakerMetadata: speakerMetadata,
                    )
                  : VoiceWidget(
                      screenSizeheight: screenSizeheight,
                      screenSizewidth: screenSizewidth,
                      speakerMetadata: speakerMetadata,
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
    required this.speakerMetadata,
    // required this.onToggleFavorite,
  });

  final double screenSizeheight;
  final double screenSizewidth;
  final List<SpeakerMetadataModel> speakerMetadata;
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
    return SizedBox(
      height: 140.h,
      width: widget.screenSizewidth * 0.95.w,
      child: GridView.builder(
        itemCount: widget.speakerMetadata.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          mainAxisExtent: 150,
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
                              widget.speakerMetadata[index].squareImage,
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
                                      right: 5.w, top: 5.h, left: 5.w),
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
                                      EdgeInsets.only(right: 5.w, top: 5.h),
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
                                          width: 16.w,
                                          height: 16.h,
                                          color: Colors.white,
                                        ),
                                      )
                                    : SvgPicture.asset(
                                        'assets/logo/Vector (1).svg',
                                        width: 16.w,
                                        height: 16.h,
                                      ),
                                SizedBox(
                                  width: 3.w,
                                ),
                                Expanded(
                                  child: Text(
                                    widget.speakerMetadata[index].engName,
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
}
