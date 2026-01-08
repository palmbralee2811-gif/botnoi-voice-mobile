// import 'package:audioplayers/audioplayers.dart';
// import 'package:botnoivoice/screen/main/home/model/appbar_bottom_model.dart';
// import 'package:botnoivoice/screen/main/home_speaker_data_management.dart';
// import 'package:botnoivoice/service/token/user_token_notifier.dart';
// import 'package:botnoivoice/shared/dialog/payment/payment_dialog.dart';
// import 'package:botnoivoice/shared/style/style.dart';
// import 'package:botnoivoice/shared/widget/gradient/gradient_icon.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;

// class HomeHeader extends ConsumerStatefulWidget {
//   const HomeHeader({super.key});

//   @override
//   ConsumerState<HomeHeader> createState() => _HomeHeaderState();
// }

// class _HomeHeaderState extends ConsumerState<HomeHeader> {
//   final NumberFormat _numberFormat = NumberFormat('#,###');
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   bool _isPlaying = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadRemainingCredits();
//     });

//     _audioPlayer.onPlayerComplete.listen((event) {
//       if (mounted) setState(() => _isPlaying = false);
//     });
//   }

//   Future<void> _loadRemainingCredits() async {
//     await loadAllTokensIfLoggedIn(ref);
//   }

//   String _formatCredits(dynamic rawCredits) {
//     if (rawCredits == null) return 'N/A';
//     num? creditValue = rawCredits is num
//         ? rawCredits
//         : num.tryParse(rawCredits.toString());

//     return creditValue != null
//         ? _numberFormat.format(creditValue)
//         : rawCredits.toString();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final userTokenState = ref.watch(currentUserTokenStateProvider);
//     final speakerProvider = ref.watch(homeSpeakerDataProvider);
//     final displayCredits = _formatCredits(userTokenState.remainingCredits);

//     // --- Responsive Logic for Tablet Landscape ---
//     // ตรวจสอบว่าเป็น Tablet หรือไม่
//     bool isTablet = MediaQuery.of(context).size.shortestSide > 550;
//     bool isLandscape =
//         MediaQuery.of(context).orientation == Orientation.landscape;

//     // ถ้าเป็น Tablet แนวนอน ให้ลดขนาดลง 30-40% เพื่อความสวยงามและไม่ล้นจอ
//     double scaleFactor = (isTablet && isLandscape) ? 0.65 : 1.0;

//     String language = Localizations.localeOf(context).languageCode;
//     final defaultSpeaker = appbarBottomModel.firstWhere(
//       (speaker) => speaker['language'] == language,
//       orElse: () => appbarBottomModel.first,
//     );

//     final speakerName = speakerProvider.speakerName ?? defaultSpeaker['name'];
//     final speakerImagePath =
//         speakerProvider.speakerImagePath ?? defaultSpeaker['image'];
//     final speakerAudio =
//         speakerProvider.speakerAudio ?? defaultSpeaker['audio'];
//     final nationalFlagName =
//         speakerProvider.nationalFlagName ?? defaultSpeaker['flagName'];
//     final nationalFlagPath =
//         speakerProvider.nationalFlagPath ?? defaultSpeaker['flagPath'];

//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding: EdgeInsets.only(bottom: 8.h * scaleFactor),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // --- Top Bar Section ---
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: (isTablet && isLandscape ? 32.w : 16.w),
//                   vertical: 8.h * scaleFactor,
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     // Menu Button
//                     IconButton(
//                       icon: Icon(Icons.menu_rounded,
//                           size: 28.sp * scaleFactor, color: kDark),
//                       onPressed: () => Scaffold.of(context).openDrawer(),
//                       splashRadius: 24 * scaleFactor,
//                       constraints: BoxConstraints(minWidth: 40.w * scaleFactor),
//                       padding: EdgeInsets.zero,
//                       alignment: Alignment.centerLeft,
//                     ),

//                     // Logo (Center)
//                     Expanded(
//                       child: Center(
//                         child: SvgPicture.asset(
//                           'assets/images/logo/appbar-icon.svg',
//                           height: 32.h * scaleFactor,
//                           fit: BoxFit.contain,
//                         ),
//                       ),
//                     ),

//                     // Credits Pill
//                     InkWell(
//                       onTap: () => showPaymentDialog(context),
//                       borderRadius: BorderRadius.circular(30.r),
//                       child: Container(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 12.w * scaleFactor,
//                             vertical: 6.h * scaleFactor),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(30.r),
//                           border: Border.all(color: Colors.grey.shade200),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             SvgPicture.asset(
//                               'assets/images/logo/credit-icon.svg',
//                               width: 18.w * scaleFactor,
//                               height: 18.h * scaleFactor,
//                             ),
//                             SizedBox(width: 6.w * scaleFactor),
//                             Text(
//                               displayCredits,
//                               style: GoogleFonts.prompt(
//                                 fontSize: 14.sp * scaleFactor,
//                                 fontWeight: FontWeight.w600,
//                                 color: kDark,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               Divider(height: 1, color: Colors.grey.shade100),

//               // --- Bottom Bar Section (Speaker Info) ---
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: (isTablet && isLandscape ? 32.w : 16.w),
//                   vertical: 8.h * scaleFactor,
//                 ),
//                 child: Row(
//                   children: [
//                     // Play Button
//                     InkWell(
//                       onTap: () async {
//                         if (_isPlaying) {
//                           await _audioPlayer.stop();
//                           setState(() => _isPlaying = false);
//                         } else if (speakerAudio != null &&
//                             speakerAudio.isNotEmpty) {
//                           try {
//                             final response = await http.get(
//                               Uri.parse(speakerAudio),
//                               headers: {'Referer': 'https://voice.botnoi.ai/'},
//                             );
//                             final audioBytes = response.bodyBytes;
//                             if (audioBytes.isNotEmpty) {
//                               final mimeType =
//                                   response.headers['content-type'] ??
//                                       'audio/wav';
//                               await _audioPlayer.play(
//                                   BytesSource(audioBytes, mimeType: mimeType));
//                               setState(() => _isPlaying = true);
//                             }
//                           } catch (e) {
//                             debugPrint("Audio Error: $e");
//                           }
//                         }
//                       },
//                       borderRadius: BorderRadius.circular(20),
//                       child: Container(
//                         padding: EdgeInsets.all(8.r * scaleFactor),
//                         decoration: BoxDecoration(
//                           color: Colors.blue.withOpacity(0.05),
//                           shape: BoxShape.circle,
//                         ),
//                         child: GradientIcon(
//                           icon: _isPlaying
//                               ? Icons.pause_rounded
//                               : Icons.play_arrow_rounded,
//                           size: 24.sp * scaleFactor,
//                           gradient: const LinearGradient(
//                             colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                         ),
//                       ),
//                     ),

//                     SizedBox(width: 12.w * scaleFactor),
//                     Container(
//                         height: 24.h * scaleFactor,
//                         width: 1,
//                         color: Colors.grey.shade200),
//                     SizedBox(width: 12.w * scaleFactor),

//                     // Speaker Info (Expanded to prevent overflow)
//                     Expanded(
//                       child: InkWell(
//                         onTap: () {
//                           if (_audioPlayer.state == PlayerState.playing) {
//                             _audioPlayer.stop();
//                           }
//                           context.go('/speaker');
//                         },
//                         borderRadius: BorderRadius.circular(8.r),
//                         child: Row(
//                           children: [
//                             CircleAvatar(
//                               radius: 18.r * scaleFactor,
//                               backgroundColor: Colors.grey.shade100,
//                               backgroundImage: CachedNetworkImageProvider(
//                                 speakerImagePath!,
//                                 headers: const {
//                                   'Referer': 'https://voice.botnoi.ai/'
//                                 },
//                               ),
//                             ),
//                             SizedBox(width: 12.w * scaleFactor),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     speakerName!,
//                                     style: GoogleFonts.prompt(
//                                       fontSize: 14.sp * scaleFactor,
//                                       fontWeight: FontWeight.w600,
//                                       color: kDark,
//                                       height: 1.1,
//                                     ),
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                   SizedBox(height: 2.h),
//                                   Row(
//                                     children: [
//                                       ClipOval(
//                                         child: Image.asset(
//                                           nationalFlagPath!,
//                                           width: 14.w * scaleFactor,
//                                           height: 14.w * scaleFactor,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                       SizedBox(width: 6.w * scaleFactor),
//                                       Flexible(
//                                         child: Text(
//                                           nationalFlagName!,
//                                           style: GoogleFonts.prompt(
//                                             fontSize: 10.sp * scaleFactor,
//                                             color: Colors.grey.shade600,
//                                             fontWeight: FontWeight.w400,
//                                           ),
//                                           maxLines: 1,
//                                           overflow: TextOverflow.ellipsis,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 Text(
//                                   'appbar_bottom.change'.tr(),
//                                   style: GoogleFonts.prompt(
//                                     fontSize: 12.sp * scaleFactor,
//                                     fontWeight: FontWeight.w500,
//                                     color: Colors.blue,
//                                   ),
//                                 ),
//                                 SizedBox(width: 4.w),
//                                 Icon(Icons.arrow_forward_ios_rounded,
//                                     size: 12.sp * scaleFactor,
//                                     color: Colors.blue),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }