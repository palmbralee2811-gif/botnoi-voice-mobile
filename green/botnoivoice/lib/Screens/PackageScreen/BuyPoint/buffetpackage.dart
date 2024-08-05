import 'package:botnoivoice/Screens/PackageScreen/package_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuffetPackage extends StatefulWidget {
  const BuffetPackage({super.key});

  @override
  State<BuffetPackage> createState() => _BuffetPackageState();
}

class _BuffetPackageState extends State<BuffetPackage> {
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
            'แพ็คเกจบุฟเฟต์',
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'โหลดไม่อั้น ไม่มี API !',
              style: GoogleFonts.prompt(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 10),
          PromotionItem(
            points: '1',
            oldPrice: '',
            newPrice: '1,499',
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          PromotionItem(
            points: '7',
            oldPrice: '',
            newPrice: '10,000',
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          PromotionItem(
            points: '31',
            oldPrice: '20,000',
            newPrice: '11,999',
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
                    '$points วัน',
                    style: GoogleFonts.prompt(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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
