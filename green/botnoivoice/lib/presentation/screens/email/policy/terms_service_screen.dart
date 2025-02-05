import 'package:botnoivoice/presentation/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsServiceScreen extends StatefulWidget {
  const TermsServiceScreen({super.key});

  @override
  State<TermsServiceScreen> createState() => _TreamsofService();
}

class _TreamsofService extends State<TermsServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //TODO: [Fix] เปลี่ยนไปใช้ AppbarTemplate
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        //TODO: แปลงเฉพาะ `Terms of Service` เป็นภาษาไทย, อังกฤษ, อินโดนีเซีย
        title: Text(
          'Terms of Service',
          style:
              GoogleFonts.prompt(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: SvgPicture.asset(
                    'assets/images/logo/appbar-icon.svg',
                    width: 54.w,
                    height: 62.h,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Text(
                    'Agreement & Condition',
                    style: GoogleFonts.prompt(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: kDark),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 30.w),
                child: Text(
                  'Terms and Conditions of Use',
                  style: GoogleFonts.prompt(
                      fontSize: 14.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  'Accessing this website As well as opening various pages contained in this website, website users. (“User”) agrees and agrees to comply with the policies of Botnoi Group (“Bobotnoi Group”), applicable laws and the terms and conditions of use of the website set forth in this Agreement as well. Generally defined and specifically defined in any part of this website ("Terms and Conditions of Use"), the user acknowledges and agrees that these terms and conditions of use are are subject to change without prior notice.',
                  style: GoogleFonts.prompt(fontSize: 14.sp, color: kDark),
                ),
              ),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                  child: Text(
                    'However, any changes Any changes relating to the Terms and Conditions of Use will be published on this website, and when the user accesses this website after such changes, the user shall be deemed to have accepted all terms and conditions of use in accordance with. has been changed, so users are advised to always follow the terms and conditions of use of this website set forth herein.\nHowever, if you do not agree or wish to refuse to be bound by any of the terms and conditions of use, please stop visiting and using this website',
                    style: GoogleFonts.prompt(fontSize: 14.sp, color: kDark),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  '1. Use of the Website and Intellectual Property',
                  style: GoogleFonts.prompt(
                    fontSize: 14.sp,
                    color: kDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: Text(
                  '1.1 All information contained in this website including but not limited to picture message Trademarks, graphics, sound, screen design, applications, user interface design, data in any form. Any software programs contained in this website, including all materials downloaded by users from this website (hereinafter collectively referred to as "Content"), are owned by the BOTLIER GROUP or its affiliates. grant a license to Little Bot Group whose content is protected by intellectual property and/or other proprietary rights. under the laws of Thailand and/or the laws of other countries in any form. and whether it has been registered or not ',
                  style: GoogleFonts.prompt(fontSize: 14.sp, color: kDark),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  'By the way, the use of trade names trademark Service marks and other marks of Botnoi Group including any intellectual property to use any material appearing on this website for any purpose Users must obtain prior written consent from the bot group before proceeding.',
                  style: GoogleFonts.prompt(fontSize: 14.sp, color: kDark),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  '1.2 All trade names, product names, trademarks service marks and other marks as well as any other intellectual property that appears on this website other than Botnoi is intellectual property. The Group which has been compiled or made available as a component of this website is for the sole purpose of beautifying the appearance of the website by Botnoi Group, as the operator of this website, not intended to be take any action which infringes any commercial or intellectual property rights of any person unless otherwise stated on this website',
                  style: GoogleFonts.prompt(fontSize: 14.sp, color: kDark),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  '2.Acceptance of these terms and conditions',
                  style: GoogleFonts.prompt(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: kDark),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  '2.1. All Users must use the Service in accordance with the terms specified in the Terms and Conditions. This edition, the user will not be able to use the service unless the user has agreed to the terms and conditions. this edition',
                  style: GoogleFonts.prompt(fontSize: 14.sp, color: kDark),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  '2.2. Users who are minors may use the Service only with the prior consent of their parents or legal representatives. If such users use the Service on behalf of or for the purposes of any business entity, it shall be deemed that such business entity has agreed to these Terms and Conditions in advance.',
                  style: GoogleFonts.prompt(fontSize: 14.sp, color: kDark),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  '2.3. If there are terms and conditions Any additional terms and conditions relating to the Service, the User shall comply with such additional terms and conditions as well as the Terms and Conditions. in using this edition',
                  style: GoogleFonts.prompt(fontSize: 14.sp, color: kDark),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  '3. Disclaimer and Limitation of Liability',
                  style: GoogleFonts.prompt(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: kDark),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  '3.1 This website is a website for the use of Speech Synthetic. to use in a way that damages, defames, infringes intellectual copyright Or violate any law if the user uses the content on the website for illegal use. violation of privacy or violation of intellectual property The user is responsible for all legal consequences. solely',
                  style: GoogleFonts.prompt(fontSize: 14.sp, color: kDark),
                ),
              ),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                  child: Text(
                    '3.2 Botnoi Group reserves the right to consider not allowing users to use this website and reserves the right to change or suspend the website service in part or in whole and at any time. to the user without prior notice or stating the reason for doing so',
                    style: GoogleFonts.prompt(fontSize: 14.sp, color: kDark),
                  )),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                  child: Text(
                    '3.3 Botnoy Group does not warrant that all advertisements on this website (if any) are accurate, complete and free from any defects. Botnoy Group is only an intermediary in transmitting advertising data. and is not an agent, partner or legal relationship in any way with the owner of the advertisements displayed on this website. can not check Or know the source and/or details of all advertisements that appear on this website. If such advertisements cause loss or damage to the user. Botnoi Group disclaims all liability and legal obligations.',
                    style: GoogleFonts.prompt(fontSize: 14.sp, color: kDark),
                  )),
              Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                  child: Text(
                    '3.4 Other than those set forth in these Terms and Conditions of Use, Botnoi Group, its directors, managers, executives, employees, employees, agents or consultants of Botnoi Group will not be held liable for mistakes. or any defects of the website or from the information content appearing on the website as well as not being liable for the consequences of any omissions in connection with this website. Whether caused by contract, tort, negligence or any other cause that may occur Although a small group of bots have been informed that such damage may occur.',
                    style: GoogleFonts.prompt(fontSize: 14.sp, color: kDark),
                  )),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  '4. Compensation for damages If a user violates the terms of use of the service as specified and causes damage in any way to the bot group. Via Bot Noi Group We reserve the right to claim damages from that user.',
                  style: GoogleFonts.prompt(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: kDark),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  '5.External Service Provider Service This may contain content. or any other service provided or provided by an external service provider. In this regard, such third party service providers will be solely responsible for the Content. In addition, such Content or Services may be subject to terms of use or other terms and conditions which the third party provider has imposed for such Content and Services.',
                  style: GoogleFonts.prompt(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: kDark),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  '6. Website Security Policy Botnoi Group has chosen to use technology. Security measures for transactions on the internet network To protect user data during transmission through communication networks. or from data theft by any unauthorized person or network connected to the Bot Group is network, such as Firewall and Secured Socket Layer (SSL) encryption, etc.',
                  style: GoogleFonts.prompt(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: kDark),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
                child: Text(
                  '7. Governing Law Terms and conditions of use of this website are governed by the laws of Thailand',
                  style: GoogleFonts.prompt(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: kDark),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}
