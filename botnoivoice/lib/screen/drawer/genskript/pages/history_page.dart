// lib/pages/history_page.dart
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine if we should show Desktop (Side-by-Side) or Mobile (Stacked) view
        bool isDesktop = constraints.maxWidth > 1024;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
        );
      },
    );
  }

  // DESKTOP VIEW: Side-by-side containers
  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Column: History Status
        Expanded(
          flex: 1,
          child: _buildHistoryContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.history, size: 48, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text(
                  "ยังไม่มีประวัติ",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                ),
                const Text(
                  "เริ่มสร้างสคริปต์เพื่อดูประวัติที่นี่",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 24), // Gap between columns
        // Right Column: Script Details Placeholder
        Expanded(
          flex: 2, // Right side is wider as per image_bbfce7.png
          child: _buildHistoryContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.description, color: Colors.grey[300], size: 48),
                const SizedBox(height: 16),
                const Text(
                  "เลือกสคริปต์เพื่อดูรายละเอียด",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // MOBILE VIEW: Stacked containers
  Widget _buildMobileLayout() {
    return Column(
      children: [
        _buildHistoryContainer(
          child: Column(
            children: [
              Icon(Icons.history, size: 48, color: Colors.grey[300]),
              const SizedBox(height: 16),
              const Text(
                "ยังไม่มีประวัติ",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const Text(
                "เริ่มสร้างสคริปต์เพื่อดูประวัติที่นี่",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildHistoryContainer(
          child: Column(
            children: [
              Icon(Icons.description, color: Colors.grey[300], size: 48),
              const SizedBox(height: 16),
              const Text(
                "เลือกสคริปต์เพื่อดูรายละเอียด",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Reusable helper for history card styling
  Widget _buildHistoryContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 80), // Increased vertical space for desktop look
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[100]!),
        ),
        child: child,
      ),
    );
  }
}