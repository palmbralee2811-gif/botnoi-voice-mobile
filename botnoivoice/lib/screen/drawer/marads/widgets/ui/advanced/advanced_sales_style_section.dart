import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../mar_ads_collapsible_section.dart';
import '../mar_ads_dropdown.dart';

class AdvancedSalesStyleSection extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback onToggle;
  final String selectedSalesCharacter;
  final VoidCallback onTapSalesCharacter;
  final String selectedContentStyle;
  final VoidCallback onTapContentStyle;

  const AdvancedSalesStyleSection({
    super.key,
    required this.isExpanded,
    required this.onToggle,
    required this.selectedSalesCharacter,
    required this.onTapSalesCharacter,
    required this.selectedContentStyle,
    required this.onTapContentStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MarAdsCollapsibleSection(
          title: 'marads_adv.section_sales_style'.tr(),
          isExpanded: isExpanded,
          onTap: onToggle,
        ),
        if (isExpanded) ...[
          MarAdsDropdown(
            label: 'marads_adv.header_character'.tr(),
            value: selectedSalesCharacter,
            onTap: onTapSalesCharacter,
          ),
          MarAdsDropdown(
            label: 'marads_adv.header_style'.tr(),
            value: selectedContentStyle,
            onTap: onTapContentStyle,
          ),
        ],
      ],
    );
  }
}
