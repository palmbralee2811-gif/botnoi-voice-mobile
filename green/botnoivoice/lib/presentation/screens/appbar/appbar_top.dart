import 'package:botnoivoice/data/repositories/credits_repository_impl.dart';
import 'package:botnoivoice/data/managers/token_manager.dart';
import 'package:botnoivoice/presentation/screens/appbar/appbar_bottom.dart';
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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final creditsProvider = Provider.of<CreditsRepositoryImpl>(context, listen: false);
    final auth = Provider.of<TokenManager>(context, listen: false);
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
        height: 140.h,
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
      leadingWidth: 60.w,
      title: SizedBox(
        height: 140.h,
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
          height: 30.h,
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(255, 224, 221, 221),
                blurRadius: 3.0,
              ),
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
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
                  height: 20.h,
                  width: 20.h,
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: SvgPicture.asset(
                      'assets/images/logo/credit-icon.svg',
                      width: 20.w,
                      height: 20.h,
                    ),
                  ),
                ),
                Text(
                  ' ${credits ?? "N/A"}',
                  style: GoogleFonts.prompt(
                    fontSize: 12.sp,
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
        preferredSize: Size.fromHeight(30.h),
        child: const AppBarBottom(),
      ),
    );
  }
}
