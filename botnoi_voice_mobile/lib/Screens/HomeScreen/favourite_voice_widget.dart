// import 'package:botnoivoice/widgets/CategoryVoice.dart';
import 'package:botnoi_voice_mobile/MainServer/ObjectModels/speaker_metadata_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class FavoriteVoiceWidget extends StatefulWidget {
  const FavoriteVoiceWidget({
    super.key,
    required this.screenSizeheight,
    required this.screenSizewidth,
    required this.speakerMetadata,
  });
  final double screenSizeheight;
  final double screenSizewidth;
  final List<SpeakerMetadataModel> speakerMetadata;
  @override
  State<FavoriteVoiceWidget> createState() => _FavoriteVoiceWidgetState();
}

class _FavoriteVoiceWidgetState extends State<FavoriteVoiceWidget> {
  Set<int> selectedIndex2 = <int>{};
  Set<int> selectedIndex = <int>{};
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Choice Voice'),
        if (speakerMetadata.isNotEmpty)
          SizedBox(
            height: widget.screenSizeheight * 0.165.h,
            width: widget.screenSizewidth * 0.95.w,
            child: GridView.builder(
              itemCount: widget.speakerMetadata.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisExtent: 120,
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
                              selectedIndex.add(index);
                            }
                          });
                        },
                        child: Container(
                          width: widget.screenSizewidth * 0.9.w,
                          height: widget.screenSizeheight * 0.145.h,
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
                              image: AssetImage(
                                  widget.speakerMetadata[index].squareImage),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                            right: 20.w, top: 4.w),
                                        child: selectedIndex.contains(index)
                                            ? Container(
                                                width: 31.w,
                                                height: 17.h,
                                                decoration: BoxDecoration(
                                                  gradient:
                                                      const LinearGradient(
                                                    colors: [
                                                      Color(0xFF9A96F5),
                                                      Color(0xFF00E0FF)
                                                    ],
                                                  ),
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    'เลือก',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontStyle:
                                                          GoogleFonts.prompt()
                                                              .fontStyle,
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : const Icon(
                                                Icons.check,
                                                color: Colors.transparent,
                                              ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (selectedIndex2
                                                .contains(index)) {
                                              selectedIndex2.remove(index);
                                            } else {
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
                                                  width: 16.w,
                                                  height: 16.h,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : SvgPicture.asset(
                                                'assets/logo/heart.svg',
                                                width: 16,
                                                height: 16,
                                              ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: widget.screenSizeheight * 0.07.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
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
                                                width: widget.screenSizeheight *
                                                    0.03.h,
                                                height:
                                                    widget.screenSizeheight *
                                                        0.02.w,
                                                color: Colors.white,
                                              ),
                                            )
                                          : SvgPicture.asset(
                                              'assets/logo/Vector (1).svg',
                                              width: widget.screenSizeheight *
                                                  0.01.h,
                                              height: widget.screenSizeheight *
                                                  0.02.w,
                                            ),
                                      SizedBox(
                                        width: 3.w,
                                      ),
                                      Text(
                                        softWrap: true,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: null,
                                        widget.speakerMetadata[index].thaiName,
                                        style: GoogleFonts.prompt(
                                          fontSize: 10.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
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
    );
  }
}
