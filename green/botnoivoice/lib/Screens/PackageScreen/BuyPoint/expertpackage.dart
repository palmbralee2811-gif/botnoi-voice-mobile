import 'package:botnoivoice/Screens/PackageScreen/package_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Expertpackage extends StatefulWidget {
  const Expertpackage({super.key});

  @override
  State<Expertpackage> createState() => _ExpertpackageState();
}

class _ExpertpackageState extends State<Expertpackage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: const Color(0xFFBBBFC4),
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GradientTextPackageScreen(
              'แพ็คเกจผู้เชี่ยวชาญ',
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
          ),
          const SizedBox(height: 10),
          PromotionItem(
            points: '200,000',
            oldPrice: '',
            newPrice: '1,499',
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          PromotionItem(
            points: '71,000',
            oldPrice: '',
            newPrice: '1,099',
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          PromotionItem(
            points: '97,500',
            oldPrice: '1,699',
            newPrice: '1,299',
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF01BFFB),
                backgroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF01BFFB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'ดูเพิ่มเติม',
                style: GoogleFonts.prompt(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF01BFFB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PromotionItem extends StatelessWidget {
  final String points;
  final String oldPrice;
  final String newPrice;
  final Color color;

  PromotionItem({
    required this.points,
    required this.oldPrice,
    required this.newPrice,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/point.png',
                width: 16,
                height: 16,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$points พอยท์',
                    style: GoogleFonts.prompt(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '· แถมฟรี No Ads 1 เดือน',
                    style: GoogleFonts.prompt(
                      color: const Color(0xFF01BFFB),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              Text(
                oldPrice,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF01BFFB),
                ),
                child: Text(
                  newPrice,
                  style: TextStyle(
                    fontSize: 18,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
