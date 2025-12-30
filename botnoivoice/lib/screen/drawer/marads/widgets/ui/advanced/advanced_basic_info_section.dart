import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../basic_mar_ads_text_field.dart';
import '../mar_ads_collapsible_section.dart';

class AdvancedBasicInfoSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final TextEditingController productController;
  final TextEditingController brandController;
  final TextEditingController priceController;
  final Widget productPropertiesButton; // รับ Widget ปุ่ม Tags เข้ามาแสดงผล

  const AdvancedBasicInfoSection({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.productController,
    required this.brandController,
    required this.priceController,
    required this.productPropertiesButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MarAdsCollapsibleSection(
          title: 'ข้อมูลเบื้องต้น*',
          isExpanded: isExpanded,
          onTap: onToggle,
        ),
        if (isExpanded) ...[
          Divider(color: const Color(0xFFEEDDF3), height: 1.h, thickness: 1),
          SizedBox(height: 16.h),
          MarAdsTextField(
            label: 'สินค้าที่ต้องการขาย*',
            placeholder: 'คอร์สสอนภาษา, โทรศัพท์มือถือ, ...',
            controller: productController,
            isRequired: true,
          ),
          MarAdsTextField(
            label: 'ชื่อแบรนด์/ชื่อยี่ห้อ',
            placeholder: 'บอทน้อย',
            controller: brandController,
          ),
          MarAdsTextField(
            label: 'ราคา',
            placeholder: '129 บาท, 99 บาท จาก 129 บาท',
            controller: priceController,
          ),
          // แสดงปุ่มที่รับเข้ามา
          productPropertiesButton,
        ],
      ],
    );
  }
}
