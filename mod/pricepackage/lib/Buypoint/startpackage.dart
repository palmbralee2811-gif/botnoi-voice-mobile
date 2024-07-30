import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pricepackage/package.dart';

class Startpackage extends StatefulWidget {
  const Startpackage({super.key});

  @override
  State<Startpackage> createState() => _StartpackageState();
}

class _StartpackageState extends State<Startpackage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: Color(0xFFBBBFC4),
          width: 2.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: GradientText(
              'แพ็คเกจผู้เริ่มต้น',
              gradient: LinearGradient(
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
          SizedBox(height: 10),
          PromotionItem(
            points: '4,100',
            oldPrice: '100',
            newPrice: '99',
            color: Colors.white,
          ),
          SizedBox(height: 10),
          PromotionItem(
            points: '12,500',
            oldPrice: '',
            newPrice: '199',
            color: Colors.white,
          ),
          SizedBox(height: 10),
          PromotionItem(
            points: '23,500',
            oldPrice: '300',
            newPrice: '299',
            color: Colors.white,
          ),
          SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                foregroundColor: Color(0xFF01BFFB),
                backgroundColor: Colors.white,
                side: BorderSide(color: Color(0xFF01BFFB)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'ดูเพิ่มเติม',
                style: GoogleFonts.prompt(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF01BFFB),
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
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/point4.png',
                width: 16,
                height: 16,
              ),
              SizedBox(width: 10),
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
                      color: Color(0xFF01BFFB),
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
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.red,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF01BFFB),
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
