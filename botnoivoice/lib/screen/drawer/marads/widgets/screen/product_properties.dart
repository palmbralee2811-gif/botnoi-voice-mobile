import 'package:botnoivoice/screen/drawer/marads/widgets/ui/basic_mar_ads_text_field.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductPropertiesScreen extends StatefulWidget {
  const ProductPropertiesScreen({super.key});

  @override
  State<ProductPropertiesScreen> createState() =>
      _ProductPropertiesScreenState();
}

class _ProductPropertiesScreenState extends State<ProductPropertiesScreen> {
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();

  String _selectedColor = 'ไม่ระบุ';

  // Map สีสำหรับแสดงผล
  final Map<String, Color> _colorMap = {
    'ดำ': const Color(0xFF262626),
    'แดง': const Color(0xFFFF0000),
    'ขาว': const Color(0xFFFFFFFF),
    'ชมพู': const Color(0xFFFF40E5),
    'น้ำเงิน': const Color(0xFF0055FF),
  };

//   @override
//   void dispose() {
//     _sizeController.dispose();
//     _modelController.dispose();
//     _materialController.dispose();
//     super.dispose();
//   }

  String _getLocalizedColorName(String key) {
    if (key == 'ไม่ระบุ') return 'marads_props.color_unspecified'.tr();
    // ใช้ Key ร่วมกับหน้า Advanced
    switch (key) {
      case 'ดำ':
        return 'marads_adv.color_black'.tr();
      case 'แดง':
        return 'marads_adv.color_red'.tr();
      case 'ขาว':
        return 'marads_adv.color_white'.tr();
      case 'ชมพู':
        return 'marads_adv.color_pink'.tr();
      case 'น้ำเงิน':
        return 'marads_adv.color_blue'.tr();
      default:
        return key;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        title: Column(
          children: [
            Text(
              'marads_props.title'.tr(),
              style: GoogleFonts.prompt(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF262626),
              ),
            ),
            Text(
              'marads_props.subtitle'.tr(),
              style: GoogleFonts.prompt(
                fontSize: 11.sp, // ตัวเล็กกว่าและสีจางลง เพื่อเป็นคำอธิบาย
                fontWeight: FontWeight.w400,
                color: const Color(0xFF888888),
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            size: 20.sp,
            color: const Color(0xFF262626),
          ),
          onPressed: () {
            context.pop();
          },
        ),
        iconTheme: const IconThemeData(color: Color(0xFF262626)),
      ),
      body: Column(
        children: [
          // สพื้นที่กรอกข้อมูล
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Column(
                children: [
                  MarAdsTextField(
                    label: 'marads_props.label_size'.tr(),
                    placeholder: 'marads_props.placeholder_size'.tr(),
                    controller: _sizeController,
                  ),
                  MarAdsTextField(
                    label: 'marads_props.label_model'.tr(),
                    placeholder: 'marads_props.placeholder_model'.tr(),
                    controller: _modelController,
                  ),
                  _buildColorDropdown(),
                  MarAdsTextField(
                    label: 'marads_props.label_material'.tr(),
                    placeholder: 'marads_props.placeholder_material'.tr(),
                    controller: _materialController,
                  ),
                ],
              ),
            ),
          ),
          // ปุ่มบันทึก
          Padding(
            padding: EdgeInsets.only(bottom: 24.h, top: 10.h),
            child: _buildSubmitButton(),
          ),
        ],
      ),
    );
  }

  // -------------------------------
  // DROPDOWN UI
  // -------------------------------
  Widget _buildColorDropdown() {
    // เพิ่ม Container ครอบเพื่อให้มี Padding เท่ากับ MarAdsTextField
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'marads_props.label_color'.tr(),
            style: GoogleFonts.prompt(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF262626),
              height: 1.43,
              letterSpacing: 0.25,
            ),
          ),
          SizedBox(height: 8.h),
          GestureDetector(
            onTap: _showColorPicker,
            child: Container(
              height: 50.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFFDBDBDB)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // ส่วนแสดงผลด้านซ้าย วงกลมสี (ถ้ามี) + ชื่อสี
                  Row(
                    children: [
                      if (_colorMap.containsKey(_selectedColor)) ...[
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            color: _colorMap[_selectedColor],
                            shape: BoxShape.circle,
                            border: _selectedColor == 'ขาว'
                                ? Border.all(color: const Color(0xFFDBDBDB))
                                : null,
                          ),
                        ),
                        SizedBox(width: 10.w),
                      ],
                      Text(
                        _getLocalizedColorName(_selectedColor),
                        style: GoogleFonts.prompt(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          // ถ้าเป็นค่าเริ่มต้น "ไม่ระบุ" ให้ใช้สีเทา (เหมือน Placeholder) ถ้าเลือกแล้วใช้สีดำ
                          color: _selectedColor == 'ไม่ระบุ'
                              ? const Color(0xFFC4C4C4)
                              : const Color(0xFF262626),
                        ),
                      ),
                    ],
                  ),
                  // ส่วนแสดงผลด้านขวา ไอคอนลูกศร
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 20.sp,
                    color: const Color(0xFF262626),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(
              16.w, 16.h, 16.w, MediaQuery.of(context).padding.bottom + 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'marads_props.header_select_color'.tr(),
                style: GoogleFonts.prompt(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.3,
                ),
              ),
              SizedBox(height: 12.h),
              const Divider(),
              _buildColorOption('ไม่ระบุ'),
              ..._colorMap.entries.map(
                (e) {
                  return _buildColorOption(e.key, color: e.value);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget เสริมสำหรับสร้างรายการสีใน BottomSheet
  Widget _buildColorOption(String label, {Color? color}) {
    return ListTile(
      onTap: () {
        setState(() {
          _selectedColor = label;
        });

        context.pop();
      },
      contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
      minLeadingWidth: 20.w,
      leading: color != null
          ? Container(
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: label == 'ขาว'
                    ? Border.all(color: const Color(0xFFE0E0E0))
                    : null,
              ),
            )
          : null,
      title: Text(
        _getLocalizedColorName(label),
        style: GoogleFonts.prompt(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF262626),
        ),
      ),
    );
  }

  // -------------------------------
  // SUBMIT BUTTON
  // -------------------------------
  Widget _buildSubmitButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () {
          final result = {
            'size': _sizeController.text,
            'model': _modelController.text,
            'color': _selectedColor,
            'material': _materialController.text,
          };
          context.pop(result);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF262626),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        child: Text(
          'marads_props.btn_save'.tr(),
          style: GoogleFonts.prompt(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
      ),
    );
  }
}
