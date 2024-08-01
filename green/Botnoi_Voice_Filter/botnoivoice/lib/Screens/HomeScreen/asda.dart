// // Widget categoryVoiceHome(BuildContext context) {
// //   double screenSizewidth = MediaQuery.of(context).size.width;
// //   double screenSizeheight = MediaQuery.of(context).size.height;

// //   // var screenSize = MediaQuery.of(context).size;
// //   final data =
// //       AppDataBase.data.where((item) => item.language == language).toList();
// //   // final filterModel = Provider.of<FilterModel>(context);

// //   return Column(
// //     crossAxisAlignment: CrossAxisAlignment.stretch,
// //     children: [
// //       SizedBox(
// //         height: screenSizeheight * 0.05.h,
// //         child: ListView(
// //           scrollDirection: Axis.horizontal,
// //           children: <Widget>[
// //             Container(
// //               color: const Color(0xFFFFFFFF),
// //               width: 600.w,
// //               child: Padding(
// //                 padding: EdgeInsets.only(right: 10.w, left: 10.w),
// //                 child: Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     InkWell(
// //                       onTap: () {
// //                         setState(() {
// //                           isExpanded = true;
// //                         });

// //                         showModalBottomSheet(
// //                           backgroundColor: Colors.white,
// //                           context: context,
// //                           builder: (BuildContext context) {
// //                             return StatefulBuilder(
// //                               builder:
// //                                   (BuildContext context, StateSetter setState) {
// //                                 return SingleChildScrollView(
// //                                   child: Row(
// //                                     children: [
// //                                       Padding(
// //                                         padding: const EdgeInsets.all(20),
// //                                         child: Column(
// //                                           children: [
// //                                             Container(
// //                                               color: Colors.transparent,
// //                                               width: 360,
// //                                               child: Column(
// //                                                 children: [
// //                                                   Row(
// //                                                     mainAxisAlignment:
// //                                                         MainAxisAlignment
// //                                                             .spaceBetween,
// //                                                     children: [
// //                                                       Text(
// //                                                         'ภาษา',
// //                                                         style:
// //                                                             GoogleFonts.prompt(
// //                                                           fontSize: 16.sp,
// //                                                           fontWeight:
// //                                                               FontWeight.w600,
// //                                                         ),
// //                                                       ),
// //                                                       InkWell(
// //                                                         onTap: () {
// //                                                           Navigator.pop(
// //                                                               context);
// //                                                         },
// //                                                         child: Icon(
// //                                                           Icons.close,
// //                                                           size: 24.sp,
// //                                                           color: Colors.black,
// //                                                         ),
// //                                                       ),
// //                                                     ],
// //                                                   ),
// //                                                   SizedBox(
// //                                                     height: 15.h,
// //                                                   ),
// //                                                   _buildLanguageOption(
// //                                                       'Thai(Thailand) - ไทย',
// //                                                       'assets/logo/Ellipse 12.jpg',
// //                                                       'th',
// //                                                       context,
// //                                                       setState),
// //                                                   _buildLanguageOption(
// //                                                       'English (UK) - อังกฤษ',
// //                                                       'assets/logo/Ellipse 13.jpg',
// //                                                       'en',
// //                                                       context,
// //                                                       setState),
// //                                                   _buildLanguageOption(
// //                                                       'Indonesia - อินโดนีเซีย',
// //                                                       'assets/logo/Ellipse 13 (2).jpg',
// //                                                       'indo',
// //                                                       context,
// //                                                       setState),
// //                                                   _buildLanguageOption(
// //                                                       'Japanese - ญี่ปุ่น',
// //                                                       'assets/logo/Ellipse 14.jpg',
// //                                                       'jp',
// //                                                       context,
// //                                                       setState),
// //                                                   _buildLanguageOption(
// //                                                       'Laos - ลาว',
// //                                                       'assets/logo/Ellipse 15.jpg',
// //                                                       'loas',
// //                                                       context,
// //                                                       setState),
// //                                                   _buildLanguageOption(
// //                                                       'Myanmar - เมียนมาร์',
// //                                                       'assets/logo/Ellipse 11.jpg',
// //                                                       'mym',
// //                                                       context,
// //                                                       setState),
// //                                                   _buildLanguageOption(
// //                                                       'Vietnam - เวียดนาม',
// //                                                       'assets/logo/Ellipse 19.jpg',
// //                                                       'vn',
// //                                                       context,
// //                                                       setState),
// //                                                   _buildLanguageOption(
// //                                                       'Chinese (Simplified) - จีน',
// //                                                       'assets/logo/Ellipse 18.jpg',
// //                                                       'ch',
// //                                                       context,
// //                                                       setState),
// //                                                 ],
// //                                               ),
// //                                             ),
// //                                           ],
// //                                         ),
// //                                       )
// //                                     ],
// //                                   ),
// //                                 );
// //                               },
// //                             );
// //                           },
// //                         ).whenComplete(() {
// //                           setState(() {
// //                             isExpanded = false;
// //                           });
// //                         });
// //                       },
// //                       child: Container(
// //                         width: 72.w,
// //                         height: 26.h,
// //                         decoration: BoxDecoration(
// //                           color: Colors.transparent,
// //                           borderRadius: const BorderRadius.all(
// //                             Radius.circular(4),
// //                           ),
// //                           border: Border.all(
// //                             color: const Color(0xFFE2E3E9),
// //                             width: 1,
// //                           ),
// //                         ),
// //                         child: Row(
// //                           mainAxisAlignment: MainAxisAlignment.center,
// //                           children: [
// //                             Image.asset(
// //                               selectedLanguageImage,
// //                               width: 14,
// //                               height: 14,
// //                             ),
// //                             const SizedBox(
// //                               width: 3,
// //                             ),
// //                             Flexible(
// //                               child: FittedBox(
// //                                 fit: BoxFit.scaleDown,
// //                                 child: Text(
// //                                   selectedLanguage,
// //                                   style: GoogleFonts.prompt(fontSize: 12.sp),
// //                                 ),
// //                               ),
// //                             ),
// //                             Icon(
// //                               isExpanded
// //                                   ? Icons.keyboard_arrow_up_sharp
// //                                   : Icons.keyboard_arrow_down_sharp,
// //                               size: 20,
// //                               color: const Color(0xFF323130),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                     ),
// //                     const Sex(),
// //                     const Recommand(),
// //                     InkWell(
// //                       onTap: () {
// //                         setState(() {
// //                           ishover = !ishover;
// //                         });
// //                       },
// //                       child: Favorite(ishover: ishover),
// //                     ),
// //                     const All(),
// //                     const New(),
// //                     const Voice(),
// //                     const Advert(),
// //                     const Podcast(),
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //       Container(
// //         color: const Color(0xFFFFFFFF),
// //         height: 148.h,
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             ishover
// //                 ? FavoriteVoice(
// //                     screenSizeheight: screenSizeheight,
// //                     screenSizewidth: screenSizewidth,
// //                     data: data,
// //                   )
// //                 : voiceWidGetHome(context),
// //           ],
// //         ),
// //       ),
// //     ],
// //   );
// // }

// // Widget _buildLanguageOption(String text, String imagePath, String lang,
// //     BuildContext context, StateSetter setState) {
// //   return InkWell(
// //     onTap: () {
// //       setState(() {
// //         selectedLanguage = text.split(' - ')[1];
// //         selectedLanguageImage = imagePath;
// //         language = lang; // Update the language variable
// //       });
// //       print(
// //           'Selected Language: $selectedLanguage, Code: $language'); // Print to debug console
// //       Navigator.pop(context);
// //     },
// //     child: Container(
// //       padding: EdgeInsets.only(left: 10.w),
// //       height: 42.h,
// //       width: 320.w,
// //       color: const Color(0xFFFFFFFF),
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.start,
// //             children: [
// //               Image.asset(
// //                 imagePath,
// //                 width: 23.w,
// //                 height: 23.h,
// //               ),
// //               SizedBox(
// //                 width: 20.w,
// //               ),
// //               Text(
// //                 text,
// //                 style: GoogleFonts.prompt(
// //                   fontSize: 14.sp,
// //                   fontWeight: selectedLanguage == text.split(' - ')[1]
// //                       ? FontWeight.w600
// //                       : FontWeight.normal,
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ],
// //       ),
// //     ),
// //   );
// // }

// // Widget voiceWidGetHome(BuildContext context) {
// //   // double screenSizewidth = MediaQuery.of(context).size.width; //// Old
// //   return SizedBox(
// //     // height: 140.h,
// //     // width: screenSizewidth * 0.95.w,
// //     height: 127.h,
// //     width: 320.w,
// //     child: GridView.builder(
// //       itemCount:
// //           AppDataBase.data.where((item) => item.language == language).length,
// //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
// //         crossAxisCount: 1,
// //         // mainAxisExtent: 150,
// //         mainAxisExtent: 125,
// //       ),
// //       scrollDirection: Axis.horizontal,
// //       itemBuilder: (context, index) {
// //         final data = AppDataBase.data
// //             .where((item) => item.language == language)
// //             .toList()[index];

// //         return Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: [
// //             Padding(
// //               padding: EdgeInsets.only(left: 15.w),
// //               child: GestureDetector(
// //                 onTap: () async {
// //                   String audioURL = data.audio;
// //                   Future<void> playAudio() async {
// //                     if (audioURL.isNotEmpty) {
// //                       if (isAudioPlaying) {
// //                         // ถ้ามีการเล่นเสียงอยู่ ให้หยุดก่อน
// //                         await audioPlayer.stop();
// //                       }
// //                       await audioPlayer.play(UrlSource(audioURL));
// //                       setState(() {
// //                         isAudioPlaying = true;
// //                       });

// //                       audioPlayer.onPlayerComplete.listen((event) {
// //                         print("#### Play Audio's Complete");
// //                         setState(() {
// //                           isAudioPlaying = false;
// //                         });
// //                       });
// //                     } else {
// //                       setState(() {
// //                         isAudioPlaying = false;
// //                       });
// //                       print("Audio URL is empty, cannot play audio");
// //                     }
// //                   }

// //                   await playAudio();

// //                   speakerId = data.speakerId;
// //                   language = data.language.toLowerCase();
// //                   availableLanguage = data.availableLanguage.toList();
// //                   print("\n### START voiceWidGetHome ###\n");
// //                   print("-> speakerId: $speakerId");
// //                   print("-> language: $language");
// //                   print("-> availableLanguage: $availableLanguage");
// //                   print("\n### END voiceWidGetHome ###\n");

// //                   // ...
// //                 },
// //                 child: Container(
// //                   width: 295.w,
// //                   height: 116.h,
// //                   decoration: BoxDecoration(
// //                     color: const Color(0xFFEFF1FE),
// //                     borderRadius: const BorderRadius.all(
// //                       Radius.circular(8),
// //                     ),
// //                     border: Border.all(
// //                       color: const Color(0xFFE0E0E0),
// //                       width: 1,
// //                     ),
// //                     boxShadow: const [
// //                       BoxShadow(
// //                         color: Color(0xFFE0E0E0),
// //                         offset: Offset(0.0, 1.0),
// //                         blurRadius: 0.0,
// //                         spreadRadius: 0.0,
// //                       ),
// //                     ],
// //                   ),
// //                   child: Row(
// //                     mainAxisAlignment: MainAxisAlignment.start,
// //                     children: [
// //                       Padding(
// //                         padding: EdgeInsets.only(
// //                           top: 15.h,
// //                           left: 15.w,
// //                         ),
// //                         child: Column(
// //                           children: [
// //                             CircleAvatar(
// //                               radius: 20.r,
// //                               backgroundImage: AssetImage(data.avatar),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       Padding(
// //                         padding: EdgeInsets.only(
// //                           top: 10.h,
// //                           left: 15.w,
// //                         ),
// //                         child: Column(
// //                           crossAxisAlignment: CrossAxisAlignment.start,
// //                           children: [
// //                             Text(
// //                               data.name,
// //                               style: GoogleFonts.prompt(
// //                                 fontSize: 14.sp,
// //                                 fontWeight: FontWeight.w600,
// //                                 color: const Color(0xFF1D1D1D),
// //                               ),
// //                             ),
// //                             SizedBox(
// //                               height: 10.h,
// //                             ),
// //                             Container(
// //                               height: 36.h,
// //                               width: 100.w,
// //                               decoration: BoxDecoration(
// //                                 color: const Color(0xFFFFFFFF),
// //                                 borderRadius: const BorderRadius.all(
// //                                   Radius.circular(4),
// //                                 ),
// //                                 border: Border.all(
// //                                   color: const Color(0xFFE0E0E0),
// //                                   width: 1,
// //                                 ),
// //                               ),
// //                               child: Center(
// //                                 child: Text(
// //                                   data.speakerId,
// //                                   style: GoogleFonts.prompt(
// //                                     fontSize: 12.sp,
// //                                     fontWeight: FontWeight.w600,
// //                                     color: const Color(0xFF1D1D1D),
// //                                   ),
// //                                 ),
// //                               ),
// //                             ),
// //                           ],
// //                         ),
// //                       ),
// //                       SizedBox(
// //                         width: 65.w,
// //                         height: 60.h,
// //                         child: Align(
// //                           alignment: Alignment.topCenter,
// //                           child: Padding(
// //                             padding: EdgeInsets.only(top: 13.h),
// //                             child: InkWell(
// //                               onTap: () {
// //                                 setState(() {
// //                                   // _isFavorite = !_isFavorite;
// //                                 });
// //                               },
// //                               child: Icon(
// //                                 Icons.favorite_border,
// //                                 size: 24.sp,
// //                                 color: const Color(0xFF8A8A8A),
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         );
// //       },
// //     ),
// //   );
// // }
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   String selectedLanguage = 'ไทย';
//   String selectedLanguageImage = 'assets/logo/Ellipse 12.jpg';
//   bool isExpanded = false;
//   bool ishover = false;
//   bool isAudioPlaying = false;
//   int selectedIndex = -1;
//   String language = 'th';
//   List<int> selectedIndex2 = [];
//   List<int> selectedIndex = [];

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       categoryVoiceHome(context);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('My App'),
//       ),
//       body: categoryVoiceHome(context),
//     );
//   }

//   Widget categoryVoiceHome(BuildContext context) {
//     double screenSizewidth = MediaQuery.of(context).size.width;
//     double screenSizeheight = MediaQuery.of(context).size.height;

//     final data =
//         AppDataBase.data.where((item) => item.language == language).toList();

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         SizedBox(
//           height: screenSizeheight * 0.05.h,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: <Widget>[
//               Container(
//                 color: const Color(0xFFFFFFFF),
//                 width: 600.w,
//                 child: Padding(
//                   padding: EdgeInsets.only(right: 10.w, left: 10.w),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       InkWell(
//                         onTap: () {
//                           setState(() {
//                             isExpanded = true;
//                           });

//                           showModalBottomSheet(
//                             backgroundColor: Colors.white,
//                             context: context,
//                             builder: (BuildContext context) {
//                               return StatefulBuilder(
//                                 builder: (BuildContext context,
//                                     StateSetter setState) {
//                                   return SingleChildScrollView(
//                                     child: Row(
//                                       children: [
//                                         Padding(
//                                           padding: const EdgeInsets.all(20),
//                                           child: Column(
//                                             children: [
//                                               Container(
//                                                 color: Colors.transparent,
//                                                 width: 360,
//                                                 child: Column(
//                                                   children: [
//                                                     Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .spaceBetween,
//                                                       children: [
//                                                         Text(
//                                                           'ภาษา',
//                                                           style: GoogleFonts
//                                                               .prompt(
//                                                             fontSize: 16.sp,
//                                                             fontWeight:
//                                                                 FontWeight.w600,
//                                                           ),
//                                                         ),
//                                                         InkWell(
//                                                           onTap: () {
//                                                             Navigator.pop(
//                                                                 context);
//                                                           },
//                                                           child: Icon(
//                                                             Icons.close,
//                                                             size: 24.sp,
//                                                             color: Colors.black,
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                                     SizedBox(
//                                                       height: 15.h,
//                                                     ),
//                                                     _buildLanguageOption(
//                                                         'Thai(Thailand) - ไทย',
//                                                         'assets/logo/Ellipse 12.jpg',
//                                                         'th',
//                                                         context,
//                                                         setState),
//                                                     _buildLanguageOption(
//                                                         'English (UK) - อังกฤษ',
//                                                         'assets/logo/Ellipse 13.jpg',
//                                                         'en',
//                                                         context,
//                                                         setState),
//                                                     _buildLanguageOption(
//                                                         'Indonesia - อินโดนีเซีย',
//                                                         'assets/logo/Ellipse 13 (2).jpg',
//                                                         'indo',
//                                                         context,
//                                                         setState),
//                                                     _buildLanguageOption(
//                                                         'Japanese - ญี่ปุ่น',
//                                                         'assets/logo/Ellipse 14.jpg',
//                                                         'jp',
//                                                         context,
//                                                         setState),
//                                                     _buildLanguageOption(
//                                                         'Laos - ลาว',
//                                                         'assets/logo/Ellipse 15.jpg',
//                                                         'loas',
//                                                         context,
//                                                         setState),
//                                                     _buildLanguageOption(
//                                                         'Myanmar - เมียนมาร์',
//                                                         'assets/logo/Ellipse 11.jpg',
//                                                         'mym',
//                                                         context,
//                                                         setState),
//                                                     _buildLanguageOption(
//                                                         'Vietnam - เวียดนาม',
//                                                         'assets/logo/Ellipse 19.jpg',
//                                                         'vn',
//                                                         context,
//                                                         setState),
//                                                     _buildLanguageOption(
//                                                         'Chinese (Simplified) - จีน',
//                                                         'assets/logo/Ellipse 18.jpg',
//                                                         'ch',
//                                                         context,
//                                                         setState),
//                                                   ],
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   );
//                                 },
//                               );
//                             },
//                           ).whenComplete(() {
//                             setState(() {
//                               isExpanded = false;
//                             });
//                           });
//                         },
//                         child: Container(
//                           width: 72.w,
//                           height: 26.h,
//                           decoration: BoxDecoration(
//                             color: Colors.transparent,
//                             borderRadius: const BorderRadius.all(
//                               Radius.circular(4),
//                             ),
//                             border: Border.all(
//                               color: const Color(0xFFE2E3E9),
//                               width: 1,
//                             ),
//                           ),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(
//                                 selectedLanguageImage,
//                                 width: 14,
//                                 height: 14,
//                               ),
//                               const SizedBox(
//                                 width: 3,
//                               ),
//                               Flexible(
//                                 child: FittedBox(
//                                   fit: BoxFit.scaleDown,
//                                   child: Text(
//                                     selectedLanguage,
//                                     style: GoogleFonts.prompt(fontSize: 12.sp),
//                                   ),
//                                 ),
//                               ),
//                               Icon(
//                                 isExpanded
//                                     ? Icons.keyboard_arrow_up_sharp
//                                     : Icons.keyboard_arrow_down_sharp,
//                                 size: 20,
//                                 color: const Color(0xFF323130),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const Sex(),
//                       const Recommand(),
//                       InkWell(
//                         onTap: () {
//                           setState(() {
//                             ishover = !ishover;
//                           });
//                         },
//                         child: Favorite(ishover: ishover),
//                       ),
//                       const All(),
//                       const New(),
//                       const Voice(),
//                       const Advert(),
//                       const Podcast(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           color: const Color(0xFFFFFFFF),
//           height: 148.h,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               ishover
//                   ? FavoriteVoice(
//                       screenSizeheight: screenSizeheight,
//                       screenSizewidth: screenSizewidth,
//                       data: data,
//                     )
//                   : voiceWidGetHome(context),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildLanguageOption(String text, String imagePath, String lang,
//       BuildContext context, StateSetter setState) {
//     return InkWell(
//       onTap: () {
//         setState(() {
//           selectedLanguage = text.split(' - ')[1];
//           selectedLanguageImage = imagePath;
//           language = lang; // Update the language variable
//         });
//         print(
//             'Selected Language: $selectedLanguage, Code: $language'); // Print to debug console
//         Navigator.pop(context);
//       },
//       child: Container(
//         padding: EdgeInsets.only(left: 10.w),
//         height: 42.h,
//         width: 320.w,
//         color: const Color(0xFFFFFFFF),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Image.asset(
//                   imagePath,
//                   width: 23.w,
//                   height: 23.h,
//                 ),
//                 SizedBox(
//                   width: 20.w,
//                 ),
//                 Text(
//                   text,
//                   style: GoogleFonts.prompt(
//                     fontSize: 14.sp,
//                     fontWeight: selectedLanguage == text.split(' - ')[1]
//                         ? FontWeight.w600
//                         : FontWeight.normal,
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget voiceWidGetHome(BuildContext context) {
//     return SizedBox(
//       height: 127.h,
//       width: 320.w,
//       child: GridView.builder(
//         itemCount:
//             AppDataBase.data.where((item) => item.language == language).length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 1,
//           mainAxisExtent: 125,
//         ),
//         scrollDirection: Axis.horizontal,
//         itemBuilder: (context, index) {
//           final data = AppDataBase.data
//               .where((item) => item.language == language)
//               .toList()[index];

//           return Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(left: 15.w),
//                 child: GestureDetector(
//                   onTap: () async {
//                     String audioURL = data.audio;
//                     Future<void> playAudio() async {
//                       if (audioURL.isNotEmpty) {
//                         if (isAudioPlaying) {
//                           await audioPlayer.stop();
//                         }
//                         await audioPlayer.play(UrlSource(audioURL));
//                         setState(() {
//                           isAudioPlaying = true;
//                         });

//                         audioPlayer.onPlayerComplete.listen((event) {
//                           print("#### Play Audio's Complete");
//                           setState(() {
//                             isAudioPlaying = false;
//                           });
//                         });
//                       }
//                     }

//                     await playAudio();

//                     print('Image ${data.image} tapped!');
//                     print('Audio ${data.audio} tapped!');
//                     setState(() {
//                       selectedIndex = index;
//                       if (selectedIndex2.contains(index)) {
//                         selectedIndex2.remove(index);
//                       } else {
//                         selectedIndex2.add(index);
//                       }
//                     });
//                   },
//                   child: MouseRegion(
//                     onEnter: (event) {
//                       setState(() {
//                         selectedIndex = index;
//                       });
//                     },
//                     onExit: (event) {
//                       setState(() {
//                         selectedIndex = -1;
//                       });
//                     },
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 200),
//                       curve: Curves.easeInOut,
//                       height: 90.h,
//                       width: 290.w,
//                       decoration: BoxDecoration(
//                         color: selectedIndex2.contains(index)
//                             ? const Color(0xFFE0EFFC)
//                             : Colors.transparent,
//                         border: selectedIndex == index
//                             ? Border.all(
//                                 color: const Color(0xFF99CCF2),
//                                 width: 1.0,
//                               )
//                             : null,
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(right: 10.w),
//                                 child: Image.asset(
//                                   data.image,
//                                   width: 47.w,
//                                   height: 47.h,
//                                 ),
//                               ),
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     data.name,
//                                     style: GoogleFonts.prompt(
//                                       fontSize: 14.sp,
//                                       fontWeight: FontWeight.w600,
//                                       color: const Color(0xFF999999),
//                                     ),
//                                   ),
//                                   Text(
//                                     data.description,
//                                     style: GoogleFonts.prompt(
//                                       fontSize: 10.sp,
//                                       fontWeight: FontWeight.normal,
//                                       color: const Color(0xFF999999),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

