import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RewardCard extends StatelessWidget {
  final String iconUrl;
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onTap;

  final bool isTablet;
  final bool isLandscape;

  const RewardCard({
    Key? key,
    required this.iconUrl,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onTap,
    required this.isTablet,
    required this.isLandscape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double maxWidth = 480;
    double minHeight = 180;
    EdgeInsets padding = const EdgeInsets.all(17).copyWith(left: 16, right: 16);

    if (isTablet) {
      maxWidth = isLandscape ? 440 : 400;
      minHeight = 200;
      padding = const EdgeInsets.all(20).copyWith(left: 16, right: 16);
    } else {
      maxWidth = double.infinity;
      minHeight = 180;
      padding = const EdgeInsets.all(16);
    }

    const Color startColor = Color(0xFF01BFFB); 
    const Color endColor = Color(0xFFEB85FC);  

    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        minHeight: minHeight,
      ),
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        border: Border.all(width: 1 , color: startColor ),
        borderRadius: BorderRadius.circular(24),
        
        image: DecorationImage(
      image: AssetImage('assets/images/reward/background_card_default.png'), // ระบุ path ของภาพ
      fit: BoxFit.cover, // ปรับให้ภาพพอดีกับขนาดของ Container
    ),
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: (iconUrl.endsWith('.svg'))
                            ? SvgPicture.asset(
                                iconUrl,
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                                placeholderBuilder: (context) =>
                                    const Icon(Icons.card_giftcard),
                              )
                            : Image.asset(
                                iconUrl,
                                width: 20,
                                height: 20,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.card_giftcard),
                              ),
                      ),
                  
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.only( left: 30),
                          child: ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                colors: [startColor, endColor],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                        child: Text(
                          title,
                          style: TextStyle(
                            fontFamily: 'Prompt',
                            fontSize: isTablet ? 24 : 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF01BFFB),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        ),
                          ),
                      ),
                    ],
                  ),
                ],
              ),
              // ใช้ Row เพื่อให้ description อยู่ตรงแนวเดียวกับไอคอน
                // ใช้ Align เพื่อจัดตำแหน่ง description ให้ตรงแนวเดียวกับไอคอน
          Align(
            alignment: Alignment.centerLeft, // ให้ description อยู่ทางซ้ายตามแนวไอคอน
            child: Padding(
              padding: const EdgeInsets.only(top: 15 , right: 40), // เพิ่ม padding
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 20 / 14,
                  letterSpacing: 0.25,
                  color: Color(0xFF4F4F4F),
                ),
                textAlign: TextAlign.start, // ตั้งข้อความให้ชิดซ้าย
              ),
            ),
          ),

              GestureDetector(
                onTap: onTap,
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  constraints: const BoxConstraints(
                    maxWidth: 264,
                    minHeight: 52,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF262626),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1),
                        blurRadius: 4,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Text(
                        buttonText,
                        style: const TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 16,
                          color: Colors.white,
                          height: 24 / 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
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
