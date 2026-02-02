import 'package:easy_localization/easy_localization.dart';
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
  final Widget productPropertiesButton;

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
          title: 'marads_adv.section_basic_info'.tr(),
          isExpanded: isExpanded,
          onTap: onToggle,
        ),
        if (isExpanded) ...[
          Divider(color: const Color(0xFFEEDDF3), height: 1.h, thickness: 1),
          SizedBox(height: 16.h),
          MarAdsTextField(
            label: 'marads_basic.label_product'.tr(),
            placeholder: 'marads_basic.placeholder_product'.tr(),
            controller: productController,
            isRequired: true,
          ),
          MarAdsTextField(
            label: 'marads_basic.label_brand'.tr(),
            placeholder: 'marads_basic.placeholder_brand'.tr(),
            controller: brandController,
          ),
          MarAdsTextField(
            label: 'marads_basic.label_price'.tr(),
            placeholder: 'marads_basic.placeholder_price'.tr(),
            controller: priceController,
          ),
          // แสดงปุ่มที่รับเข้ามา
          productPropertiesButton,
        ],
      ],
    );
  }
}
