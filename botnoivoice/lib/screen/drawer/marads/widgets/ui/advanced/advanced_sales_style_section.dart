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
          title: 'สไตล์การขาย',
          isExpanded: isExpanded,
          onTap: onToggle,
        ),
        if (isExpanded) ...[
          MarAdsDropdown(
            label: 'คาแรกเตอร์คนขาย',
            value: selectedSalesCharacter,
            onTap: onTapSalesCharacter,
          ),
          MarAdsDropdown(
            label: 'สไตล์เนื้อหา',
            value: selectedContentStyle,
            onTap: onTapContentStyle,
          ),
        ],
      ],
    );
  }
}
