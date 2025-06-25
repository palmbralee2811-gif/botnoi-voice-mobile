// education_screen.dart

import 'package:botnoivoice/screen/appbar/appbar_template.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EducationScreen extends StatelessWidget {
  const EducationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTemplate(
        title:
            'app_drawer.education'.tr(), // ใช้ localization key เดียวกับในเมนู
        onPressed: () {
          context.pop(); // ให้ปุ่ม back กดกลับไปหน้าก่อนหน้าได้
        },
      ),
      body: const Center(
        child: Text(
          'Education Page Content Here',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
