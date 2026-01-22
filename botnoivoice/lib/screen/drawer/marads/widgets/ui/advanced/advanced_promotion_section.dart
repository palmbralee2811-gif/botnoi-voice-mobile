import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../mar_ads_collapsible_section.dart';
import '../basic_mar_ads_text_field.dart';

class AdvancedPromotionSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final TextEditingController promotionController;
  final TextEditingController targetCustomersController;
  final TextEditingController sellingPointController;
  final TextEditingController whyBuyController;
  final VoidCallback? onRandomSellingPoint;
  final VoidCallback? onRandomWhyBuy;

  const AdvancedPromotionSection({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.promotionController,
    required this.targetCustomersController,
    required this.sellingPointController,
    required this.whyBuyController,
    this.onRandomSellingPoint,
    this.onRandomWhyBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MarAdsCollapsibleSection(
          title: 'ข้อมูลโปรโมชั่น (Optional)',
          isExpanded: isExpanded,
          onTap: onToggle,
        ),
        if (isExpanded) ...[
          Divider(color: const Color(0xFFEEDDF3), height: 1.h, thickness: 1),
          SizedBox(height: 16.h),
          MarAdsTextField(
            label: 'โปรโมชั่น',
            placeholder: 'แถมฟรีหนังสือการสอน',
            controller: promotionController,
          ),
          MarAdsTextField(
            label: 'ลูกค้าที่เป็นกลุ่มเป้าหมาย',
            placeholder: 'คนชอบเทคโนโลยี',
            controller: targetCustomersController,
          ),
          MarAdsTextField(
            label: 'จุดขายทีดีกว่าคู่แข่ง',
            placeholder: 'ขายถูกที่สุดในย่าน',
            controller: sellingPointController,
            suffixIcon: IconButton(
              onPressed: onRandomSellingPoint,
              icon: const Icon(Icons.shuffle, color: Color(0xFF9E9E9E)),
              splashRadius: 20,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              padding: EdgeInsets.zero,
            ),
          ),
          MarAdsTextField(
            label: 'ทำไมลูกค้าถึงต้องซื้อ',
            placeholder: 'ประหยัดเงินจากของมือหนึ่ง',
            controller: whyBuyController,
            suffixIcon: IconButton(
              onPressed: onRandomWhyBuy,
              icon: const Icon(Icons.shuffle, color: Color(0xFF9E9E9E)),
              splashRadius: 20,
              constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ],
    );
  }
}
