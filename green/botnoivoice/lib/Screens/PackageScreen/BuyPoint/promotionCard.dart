import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Promotioncard extends StatefulWidget {
  const Promotioncard({super.key});

  @override
  State<Promotioncard> createState() => _PromotioncardState();
}

class _PromotioncardState extends State<Promotioncard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFC800FF), Color(0xFF00F6FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'โปรโมชั่นจำกัด 1/1',
            style: GoogleFonts.prompt(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          PromotionItem(
            points: '30,500',
            oldPrice: '750',
            newPrice: '400',
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          PromotionItem(
            points: '80,000',
            oldPrice: '2,000',
            newPrice: '1,000',
            color: Colors.white,
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
