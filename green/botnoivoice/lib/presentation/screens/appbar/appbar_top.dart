import 'package:botnoivoice/data/repositories/auth_repository_impl.dart';
import 'package:botnoivoice/data/repositories/credits_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AppBarTop extends StatefulWidget implements PreferredSizeWidget {
  const AppBarTop({super.key});

  @override
  State<AppBarTop> createState() => _AppBarTopState();

  @override
  Size get preferredSize =>
      Size.fromHeight(100.h); // ย้ายการกำหนด preferredSize มาที่นี่
}

class _AppBarTopState extends State<AppBarTop> {
  String? credits;

  @override
  void initState() {
    super.initState();
    final creditsProvider =
        Provider.of<CreditsRepositoryImpl>(context, listen: false);
    final auth =
        Provider.of<AuthenticationRepositoryImpl>(context, listen: false);
    creditsProvider.fetchCredits(auth);
  }

  @override
  Widget build(BuildContext context) {
    final credits = Provider.of<CreditsRepositoryImpl>(context).credits;

    return AppBar(
      backgroundColor: const Color(0xFFFFFFFF),
      elevation: 4.0,
      leading: SizedBox(
        width: double.infinity,
        height: 140.h, // กำหนดความสูง
        child: IconButton(
          icon: Icon(
            Icons.menu_rounded,
            size: 25.sp,
            color: const Color(0xFF323130),
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
      ),
      leadingWidth: 60.w, // กำหนดความกว้างสำหรับ leading เพื่อไม่ให้เบียด title
      title: SizedBox(
        height: 140.h, // กำหนดความสูง
        child: Center(
          child: SvgPicture.asset(
            'assets/images/logo/appbar-icon.svg',
            width: 30.w,
            height: 30.h,
            fit: BoxFit.contain,
          ),
        ),
      ),
      actions: [
        Container(
          height: 30.h, // ลดขนาดความสูงของ Container ให้เล็กลง
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 224, 221, 221),
                blurRadius: 3.0,
              ),
            ],
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(15.r), // ปรับขนาด BorderRadius ให้เล็กลง
          ),
          margin: EdgeInsets.only(right: 10.w),
          child: InkWell(
            onTap: () async {
              const url = 'https://voice.botnoi.ai/payment';
              await launchUrlString(url, mode: LaunchMode.platformDefault);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 5.w),
                SizedBox(
                  height: 20.h, // ลดขนาดของไอคอน
                  width: 20.h,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: SvgPicture.asset(
                      'assets/images/logo/credit-icon.svg',
                      width: 20.w, // ลดขนาดของไอคอน
                      height: 20.h,
                    ),
                  ),
                ),
                Text(
                  ' ${credits ?? "N/A"}',
                  style: GoogleFonts.prompt(
                    fontSize:
                        12.sp, // ลดขนาดของข้อความให้สมดุลกับ Container ใหม่
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF323130),
                  ),
                ),
                SizedBox(width: 5.w),
              ],
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(30.h), // กำหนดความสูงของ bottom
        child: const BottomAppBar(),
      ),
    );
  }
}
