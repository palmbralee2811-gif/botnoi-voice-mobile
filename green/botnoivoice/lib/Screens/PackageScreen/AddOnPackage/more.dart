import 'package:botnoivoice/Screens/PackageScreen/package_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class More extends StatefulWidget {
  const More({super.key});

  @override
  State<More> createState() => _MoreState();
}

class _MoreState extends State<More> {
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
          GradientTextPackageScreen(
            'More Text',
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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'สร้างเสียงมากกว่า 2,000 ตัวอักษร/กล่องเสียง',
                style: GoogleFonts.prompt(
                  fontSize: 16,
                  color: const Color(0xFF605E5C),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          PromotionItem(
            points: '1',
            oldPrice: '1,000',
            newPrice: '500',
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF01BFFB),
                backgroundColor: const Color(0xFF01BFFB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'สมัคร',
                style: GoogleFonts.prompt(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$points เดือน',
                    style: GoogleFonts.prompt(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '(31 วัน)',
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
              Text(
                newPrice,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
