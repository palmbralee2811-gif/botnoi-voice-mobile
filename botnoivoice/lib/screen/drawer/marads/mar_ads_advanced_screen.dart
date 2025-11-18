import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/mar_ads_mode_selector.dart';
import 'widgets/mar_ads_free_badge.dart';
import 'widgets/mar_ads_collapsible_section.dart';
import 'widgets/basic_mar_ads_text_field.dart';
import 'widgets/mar_ads_dropdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:botnoivoice/shared/style/style.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/product_properties.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/screen/drawer/drawer_appbar.dart';
import 'package:go_router/go_router.dart';

class MarAdsAdvancedScreen extends StatefulWidget {
  const MarAdsAdvancedScreen({super.key});

  @override
  State<MarAdsAdvancedScreen> createState() => _MarAdsAdvancedScreenState();
}

class _MarAdsAdvancedScreenState extends State<MarAdsAdvancedScreen> {
  String _selectedMode = 'Advanced mode';
  String _selectedContentLength = '~15 วิ';
  String _selectedSalesCharacter = 'แม่ค้าสาวสุดสวย';
  String _selectedContentStyle = 'จูงใจให้ใช้';
  String _additionalInfo = '';
  
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _promotionController = TextEditingController();
  final TextEditingController _targetCustomersController = TextEditingController();
  final TextEditingController _sellingPointController = TextEditingController();
  final TextEditingController _whyBuyController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();
  String _selectedColor = 'ไม่ระบุ';
  
  bool _isBasicInfoExpanded = false;
  bool _isSalesStyleExpanded = false;
  bool _isPromotionInfoExpanded = false;

  @override
  void dispose() {
    _productController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _promotionController.dispose();
    _targetCustomersController.dispose();
    _sellingPointController.dispose();
    _whyBuyController.dispose();
    _sizeController.dispose();
  _modelController.dispose();
  _materialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      drawer: const DrawerAppbar(),
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
                  SizedBox(height: 5.h),
                  MarAdsCollapsibleSection(
                    title: 'ข้อมูลเบื้องต้น*',
                    isExpanded: _isBasicInfoExpanded,
                    onTap: () {
                      setState(() {
                        _isBasicInfoExpanded = !_isBasicInfoExpanded;
                      });
                    },
                  ),
                  if (_isBasicInfoExpanded) ...[
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
                    _buildProductPropertiesButton(),
                  ],
                  _buildSpacer(),
                  MarAdsCollapsibleSection(
                    title: 'สไตล์การขาย',
                    isExpanded: _isSalesStyleExpanded,
                    onTap: () {
                      setState(() {
                        _isSalesStyleExpanded = !_isSalesStyleExpanded;
                      });
                    },
                  ),
                  if (_isSalesStyleExpanded) ...[
                    _buildSalesCharacterDropdown(),
                    MarAdsDropdown(
                      label: 'สไตล์เนื้อหา',
                      value: _selectedContentStyle,
                      onTap: _handleContentStyleTap,
                    ),
                  ],
                  _buildSpacer(),
                  MarAdsCollapsibleSection(
                    title: 'ข้อมูลโปรโมชั่น (Optional)',
                    isExpanded: _isPromotionInfoExpanded,
                    onTap: () {
                      setState(() {
                        _isPromotionInfoExpanded = !_isPromotionInfoExpanded;
                      });
                    },
                  ),
                  if (_isPromotionInfoExpanded) ...[
                    MarAdsTextField(
                      label: 'โปรโมชั่น',
                      placeholder: 'แถมฟรีหนังสือการสอน',
                      controller: _promotionController,
                    ),
                    MarAdsTextField(
                      label: 'ลูกค้าที่เป็นกลุ่มเป้าหมาย',
                      placeholder: 'คนชอบเทคโนโลยี',
                      controller: _targetCustomersController,
                    ),
                    MarAdsTextField(
                      label: 'จุดขายทีดีกว่าคู่แข่ง',
                      placeholder: 'ขายถูกที่สุดในย่าน',
                      controller: _sellingPointController,
                    ),
                    MarAdsTextField(
                      label: 'ทำไมลูกค้าถึงต้องซื้อ',
                      placeholder: 'ประหยัดเงินจากของมือหนึ่ง',
                      controller: _whyBuyController,
                    ),
                  ],
                  _buildSpacer(),
                  _buildContentLengthSection(),
                  _buildAdditionalInfoSection(),
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
      toolbarHeight: ResponsiveDesignOrientation.isLandscape ? 150.h : 58.h,
      title: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              icon: Icon(
                Icons.menu,
                size: ResponsiveDesignOrientation.isLandscape ? 22.sp : 32.sp,
                color: const Color(0xFF3D3D3D),
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
          ),
          Center(
            child: SvgPicture.asset(
              'assets/images/logo/appbar-icon.svg',
              width: ResponsiveDesignOrientation.isLandscape ? 30.w : 28.w,
              height: ResponsiveDesignOrientation.isLandscape ? 30.h : 28.h,
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

  Widget _buildSpacer() {
    return Container(
      width: double.infinity,
      height: 16.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
    );
  }

  Widget _buildProductPropertiesButton() {
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
  final result = await context.push('/marads/product-properties');
  if (result != null && result is Map<String, String>) {
    setState(() {
      _sizeController.text = result['size'] ?? '';
      _modelController.text = result['model'] ?? '';
      _materialController.text = result['material'] ?? '';
      _selectedColor = result['color'] ?? 'ไม่ระบุ';
    });
  }
},
            child: Container(
              height: 28.h,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.white,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'คุณสมบัติของสินค้า',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF262626),
                      height: 1.67,
                      letterSpacing: 0.25,
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Icon(
                    Icons.add,
                    size: 12.w,
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

  Widget _buildSalesCharacterDropdown() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'คาแรกเตอร์คนขาย',
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF262626),
              height: 1.43,
              letterSpacing: 0.25,
            ),
          ),
          SizedBox(height: 5.h),
          GestureDetector(
            onTap: _handleSalesCharacterTap,
            child: Container(
              height: 46.h,
              padding: EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF332261),
                    Color(0xFF7E2449),
                  ],
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedSalesCharacter,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF262626),
                        height: 1.67,
                        letterSpacing: 0.25,
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 12.w,
                      color: const Color(0xFF262626),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentLengthSection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'ความยาวของเนื้อหา* (มีผลต่อพอยท์ที่ใช้)',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF262626),
                    height: 1.43,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
              SizedBox(width: 4.w),
            ],
          ),
          SizedBox(height: 5.h),
          GestureDetector(
            onTap: _handleContentLengthTap,
            child: Container(
              height: 46.h,
              padding: EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF332261),
                    Color(0xFF7E2449),
                  ],
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedContentLength,
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfoSection() {
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
              height: 1.43,
              letterSpacing: 0.25,
            ),
          ),
          SizedBox(height: 5.h),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              final result = await context.push('/marads/additional-info');
              if (result != null && result is String) {
                setState(() {
                  _additionalInfo = result;
                });
              }
            },
            child: Container(
              height: 80.h,
              padding: EdgeInsets.all(1.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.r),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF332261),
                    Color(0xFF7E2449),
                  ],
                ),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    _additionalInfo.isNotEmpty
                        ? _additionalInfo
                        : "พลาดไม่ได้, หมดเขตในอีก 3 วัน",
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: _additionalInfo.isNotEmpty
                          ? const Color(0xFF262626)
                          : const Color(0xFF888888),
                      height: 1.67,
                      letterSpacing: 0.25,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton() {
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
            opacity: 0.25,
            child: Container(
              width: double.infinity,
              height: 56.h,
              decoration: BoxDecoration(
                color: const Color(0xFF262626),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Center(
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
                context.go('/marads');
              },
            ),
            ListTile(
              title: const Text('Advanced mode'),
              onTap: () {
                setState(() => _selectedMode = 'Advanced mode');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleSalesCharacterTap() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "คาแรกเตอร์คนขาย",
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
              title: const Text('แม่ค้าสาวสุดสวย'),
              onTap: () {
                setState(() => _selectedSalesCharacter = 'แม่ค้าสาวสุดสวย');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('พนักงานขายมืออาชีพ'),
              onTap: () {
                setState(() => _selectedSalesCharacter = 'พนักงานขายมืออาชีพ');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('เจ้าของร้านเป็นกันเอง'),
              onTap: () {
                setState(() => _selectedSalesCharacter = 'เจ้าของร้านเป็นกันเอง');
                Navigator.pop(context);
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
                setState(() => _selectedContentStyle = 'เรียกความสงสาร');
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
}
