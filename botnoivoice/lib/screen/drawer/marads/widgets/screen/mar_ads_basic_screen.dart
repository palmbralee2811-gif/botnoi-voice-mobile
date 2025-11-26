import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../ui/basic_mar_ads_text_field.dart';
import '../ui/mar_ads_dropdown.dart';
import '../ui/mar_ads_mode_selector.dart';
import '../ui/mar_ads_free_badge.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:botnoivoice/shared/style/style.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/service/prompt_service.dart';
import 'package:go_router/go_router.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/logic/mar_ads_basic_logic.dart';
import 'package:logger/logger.dart';


class MarAdsScreen extends StatefulWidget {
  const MarAdsScreen({super.key});

  @override
  State<MarAdsScreen> createState() => _MarAdsScreenState();
}

class _MarAdsScreenState extends State<MarAdsScreen> {
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();
  late final MarAdsLogic _logic;
  final Logger _logger = Logger();
  bool _isLoading = false;

  String _selectedContentStyle = 'จูงใจให้ใช้';
  String _selectedContentLength = '~15 วิ';
  String _selectedMode = 'Basic mode';

  @override
  void initState() {
    super.initState();
    _logic = MarAdsLogic(PromptService());
  }

  @override
  void dispose() {
    _productController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  MarAdsModeSelector(
                    selectedMode: _selectedMode,
                    onTap: _handleModeSelectorTap,
                  ),
                  MarAdsTextField(
  label: 'สินค้าที่ต้องการขาย*',
  placeholder: 'คอร์สสอนภาษา, โทรศัพท์มือถือ, ...',
  controller: _productController,
  isRequired: true,
),
MarAdsTextField(
  label: 'ชื่อแบรนด์/ชื่อยี่ห้อ',
  placeholder: 'บอทน้อย',
  controller: _brandController,
),
MarAdsTextField(
  label: 'ราคา',
  placeholder: '129 บาท, 99 บาท จาก 129 บาท',
  controller: _priceController,
),
                  MarAdsDropdown(
                    label: 'สไตล์เนื้อหา',
                    value: _selectedContentStyle,
                    onTap: _handleContentStyleTap,
                  ),
                  MarAdsDropdown(
                    label: 'ความยาวของเนื้อหา* (มีผลต่อพอยท์ที่ใช้)',
                    value: _selectedContentLength,
                    showInfoIcon: true,
                    onTap: _handleContentLengthTap,
                  ),
                  _buildAdditionalInfoLabel(), // 👈 กล่องข้อมูลเสริมพิมพ์ได้
                ],
              ),
            ),
          ),
          _buildBottomButton(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight:
          ResponsiveDesignOrientation.isLandscape ? 150.h : 58.h,
      title: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                size: ResponsiveDesignOrientation.isLandscape
                    ? 12.sp
                    : 25.sp,
                color: kDark,
              ),
              onPressed: () {
                context.go('/home');
              },
            ),
          ),
          Center(
            child: SvgPicture.asset(
              'assets/images/logo/appbar-icon.svg',
              width: ResponsiveDesignOrientation.isLandscape
                  ? 30.w
                  : 28.w,
              height: ResponsiveDesignOrientation.isLandscape
                  ? 30.h
                  : 28.h,
              fit: BoxFit.contain,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 16.w),
              child: const MarAdsFreeBadge(remainingCount: '10/10'),
            ),
          ),
        ],
      ),
    );
  }

  /// กล่อง "ข้อมูลเสริมอื่นๆ" ให้พิมพ์ได้เลย
  Widget _buildAdditionalInfoLabel() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ข้อมูลเสริมอื่นๆ (ไม่จำเป็นต้องกรอก)',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF262626),
              height: 2,
              letterSpacing: 0.25,
            ),
          ),
          SizedBox(height: 5.h),
          Container(
            height: 100.h,
            padding: const EdgeInsets.all(1.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: const LinearGradient(
                colors: [Color(0xFF332261), Color(0xFF7E2449)],
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.r),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
              child: TextField(
                controller: _additionalInfoController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF262626),
                  height: 1.25,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'พลาดไม่ได้, หมดเขตในอีก 3 วัน',
                  hintStyle: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFFC2C2C2),
                    height: 1.25,
                  ),
                  isCollapsed: true,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ปุ่มล่างสุด + validate 3 ช่องบังคับ
  Widget _buildBottomButton() {
    final bool isFormValid = _productController.text.isNotEmpty &&
        _brandController.text.isNotEmpty &&
        _priceController.text.isNotEmpty;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.info_outline,
                size: 12.w,
                color: const Color(0xFF262626),
              ),
              SizedBox(width: 5.w),
              Text(
                'สร้างได้ 10 ครั้ง',
                style: GoogleFonts.inter(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF262626),
                  height: 1.67,
                  letterSpacing: 0.25,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Opacity(
            opacity: isFormValid ? 1.0 : 0.25,
            child: Container(
              width: double.infinity,
              height: 56.h,
              decoration: BoxDecoration(
                color: const Color(0xFF262626),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                onPressed: isFormValid ? _handleCreateMessage : null,
                child: Text(
                  'สร้างข้อความ',
                  style: GoogleFonts.prompt(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleModeSelectorTap() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Basic mode'),
              onTap: () {
                setState(() => _selectedMode = 'Basic mode');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Advanced mode'),
              onTap: () {
                Navigator.pop(context);
                context.go('/marads/advanced');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleContentStyleTap() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "สไตล์ของเนื้อหา",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
            SizedBox(height: 12.h),
            const Divider(),
            ListTile(
              title: const Text('จูงใจให้ใช้'),
              onTap: () {
                setState(() => _selectedContentStyle = 'จูงใจให้ใช้');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('ตลก'),
              onTap: () {
                setState(() => _selectedContentStyle = 'ตลก');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('จริงจัง'),
              onTap: () {
                setState(() => _selectedContentStyle = 'จริงจัง');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('ออดอ้อน'),
              onTap: () {
                setState(() => _selectedContentStyle = 'ออดอ้อน');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('เรียกความสงสาร'),
              onTap: () {
                setState(
                    () => _selectedContentStyle = 'เรียกความสงสาร');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('รีวิวสินค้า'),
              onTap: () {
                setState(() => _selectedContentStyle = 'รีวิวสินค้า');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleContentLengthTap() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ความยาวของเนื้อหา",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
            SizedBox(height: 12.h),
            const Divider(),
            ListTile(
              title: const Text('~15 วิ'),
              onTap: () {
                setState(() => _selectedContentLength = '~15 วิ');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('~30 วิ'),
              onTap: () {
                setState(() => _selectedContentLength = '~30 วิ');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('~60 วิ'),
              onTap: () {
                setState(() => _selectedContentLength = '~60 วิ');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

      Future<void> _handleCreateMessage() async {
    if (_isLoading) return;

    // กันเหนียว validate อีกที
    if (_productController.text.isEmpty ||
        _brandController.text.isEmpty ||
        _priceController.text.isEmpty) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      _logger.i("MarAds: start create_prompt_ads");

      final response = await _logic.createPromptAdsFromForm(
        context: context,
        productName: _productController.text,
        brandName: _brandController.text,
        price: _priceController.text,
        contentStyle: _selectedContentStyle,
        contentLengthLabel: _selectedContentLength,
        additionalInfo: _additionalInfoController.text,
      );

      _logger.i("MarAds: create_prompt_ads response: $response");

      // ตอนนี้ยังไม่ต้อง parse model แค่ยิงสำเร็จ + ไปหน้า result
      context.push('/marads/result');
    } catch (e, stack) {
_logger.e(
  "MarAds: error on create_prompt_ads",
  error: e,
  stackTrace: stack,
);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

}
