import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pricepackage/Addonpackage/more.dart';
import 'package:pricepackage/Addonpackage/noads.dart';
import 'package:pricepackage/Addonpackage/report.dart';
import 'package:pricepackage/Buypoint/buffetpackage.dart';
import 'package:pricepackage/Buypoint/expertpackage.dart';
import 'package:pricepackage/Buypoint/promotionCard.dart';
import 'package:pricepackage/Buypoint/regularpackage.dart';
import 'package:pricepackage/Buypoint/startpackage.dart';
import 'package:pricepackage/Buypoint/Indicatethepoints.dart';
import 'package:pricepackage/Pointcard.dart';

class Package extends StatefulWidget {
  const Package({super.key});

  @override
  State<Package> createState() => _PackageState();
}

class _PackageState extends State<Package> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
            print('Back');
          },
        ),
        flexibleSpace: Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Image.asset(
              'assets/images/botnoivoice.png',
              width: 34,
              height: 38,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB1E9FD),
              Color(0xFFF9D8FD),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 60.0,
              decoration: const BoxDecoration(
                color: Colors.black,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [Color(0xFF01BFFB), Color(0xFFEB85FC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Icon(
                        Icons.campaign,
                        color: Colors.white,
                        size: 42.0,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.prompt(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              children: [
                                TextSpan(text: 'อย่าพลาด! '),
                                WidgetSpan(
                                  child: GradientText(
                                    'Login ',
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF01BFFB),
                                        Color(0xFFEB85FC),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    style: GoogleFonts.prompt(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                TextSpan(text: 'หรือ '),
                                WidgetSpan(
                                  child: GradientText(
                                    'Sign up',
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFEB85FC),
                                        Color(0xFF01BFFB),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    style: GoogleFonts.prompt(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            'ตอนนี้เพื่อรับโปรโมชั่นและข้อเสนอสุดพิเศษมากมาย',
                            style: GoogleFonts.prompt(
                              fontSize: 10.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Pointcard(),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: buildBottom(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBottom(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: _buildShop(context),
    );
  }

  Widget _buildShop(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        appBar: TabBar(
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          labelStyle: GoogleFonts.prompt(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
          unselectedLabelStyle: GoogleFonts.prompt(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
          tabs: [
            Tab(
              child: Text(
                "ชื้อพอยท์",
                style: GoogleFonts.prompt(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Tab(
              child: Text(
                "แพ็คเสริม",
                style: GoogleFonts.prompt(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10.0,
                    ),
                    GradientText(
                      'ลดแรงสุดในเดือนนี้',
                      gradient: const LinearGradient(
                        colors: [Color(0xFFEB85FC), Color(0xFF01BFFB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      style: GoogleFonts.prompt(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Center(
                      child: Text(
                        "แพ็คเกจราคาพิเศษ ลดมากกว่า 50% \nเฉพาะ เดือนนี้ อย่ารอช้า ซื้อเลยวันนี้",
                        style: GoogleFonts.prompt(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Promotioncard(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Startpackage(),
                    SizedBox(
                      height: 10.0,
                    ),
                    RegularPackage(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Expertpackage(),
                    SizedBox(
                      height: 10.0,
                    ),
                    BuffetPackage(),
                    SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Indicatethepoints(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Report(),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10.0,
                    ),
                    GradientText(
                      'เเพ็คเสริม',
                      gradient: const LinearGradient(
                        colors: [Color(0xFF01BFFB), Color(0xFFEB85FC)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      style: GoogleFonts.prompt(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Text(
                      "ปลดล็อคขีดจำกัดด้วยแพ็คเสริมพิเศษสุดคุ้ม",
                      style: GoogleFonts.prompt(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Noads(),
                    SizedBox(
                      height: 10.0,
                    ),
                    More(),
                    SizedBox(
                      height: 10.0,
                    ),
                    Report(),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    required this.style,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
