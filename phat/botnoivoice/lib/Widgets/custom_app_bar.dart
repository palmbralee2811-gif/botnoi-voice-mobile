import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget //implements PreferredSize{
  {
  
  const CustomAppBar(BuildContext context, {
    super.key,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  String? credits;
  
  @override
  void initState() {
    fetchCredits();
    super.initState();
  }
  Future<void> fetchCredits() async {
    final auth = Provider.of<Authentication>(context, listen: false);
    credits = auth.getProfileWithToken(auth.jwtToken).toString();
    print('(Credit) JWT token isss : ${auth.jwtToken}');
  }
  
  @override
  Widget build(BuildContext context) {

    final auth = Provider.of<Authentication>(context);
    credits = auth.credits;
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 88.w, top: 5.h),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    'assets/logo/Aboutus_icon.png',
                    width: 25.w,
                    height: 25.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 5.w),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
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
                              SizedBox(width: 5.w),
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
                                    ' ${credits ?? " N/A"}',
                                    style: GoogleFonts.prompt(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF323130),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 5.w),
                            ],
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
    );
  }
}
