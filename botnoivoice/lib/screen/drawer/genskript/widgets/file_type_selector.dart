// lib/widgets/file_type_selector.dart
import 'package:flutter/material.dart';

class FileTypeSelector extends StatelessWidget {
  final String selected;
  final Function(String) onSelect;

  const FileTypeSelector({super.key, required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final types = [
      {'id': 'image', 'label': 'รูปภาพ'},
      {'id': 'pdf', 'label': 'PDF'},
      {'id': 'pptx', 'label': 'PPTX'}
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: types.map((type) {
          bool isSelected = selected == type['id'];
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelect(type['id']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF333333) : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    type['label']!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}