import 'package:botnoivoice/screen/drawer/drawer_appbar.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/components/mar_ads_create_button.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/components/mar_ads_points_badge.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../ui/basic_mar_ads_text_field.dart';
import '../ui/mar_ads_dropdown.dart';
import '../ui/mar_ads_mode_selector.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:botnoivoice/shared/style/style.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/service/prompt_service.dart';
import 'package:go_router/go_router.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/logic/mar_ads_basic_logic.dart';
import 'package:logger/logger.dart';

class MarAdsScreen extends ConsumerStatefulWidget {
  const MarAdsScreen({super.key});

  @override
  ConsumerState<MarAdsScreen> createState() => _MarAdsScreenState();
}

class _MarAdsScreenState extends ConsumerState<MarAdsScreen> {
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadAllTokensIfLoggedIn(ref);
    });
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
    // [เพิ่ม] 1. ดึงข้อมูล Point และคำนวณจำนวนครั้ง
    final userToken = ref.watch(currentUserTokenStateProvider);
    final int currentPoints =
        int.tryParse(userToken.remainingCredits.toString()) ?? 0;
    // [เพิ่ม] คำนวณราคาตามความยาวที่เลือก (~15, ~30, ~60 วิ)
    int costPerGen = 50; // เริ่มต้นที่ 50 (สำหรับ 15 วิ)
    if (_selectedContentLength.contains('30')) {
      costPerGen = 100;
    } else if (_selectedContentLength.contains('60')) {
      costPerGen = 150;
    }

    // ถ้า cost เป็น 0 ให้โชว์เลขเยอะๆ หรือสัญลักษณ์ infinity, ถ้าไม่ 0 ก็เอา point / cost
    final int canCreateTimes =
        costPerGen == 0 ? 999 : (currentPoints / costPerGen).floor();
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
                  _buildAdditionalInfoLabel(), // กล่องข้อมูลเสริมพิมพ์ได้
                ],
              ),
            ),
          ),
          MarAdsCreateButton(
            remainingCount: canCreateTimes.toString(),
            isFormValid: _productController.text.isNotEmpty,
            isLoading: _isLoading,
            onPressed: _handleCreateMessage,
          ),
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
            child: Builder(
              // หุ้มด้วย Builder เพื่อสร้าง context ใหม่ใต้ Scaffold
              builder: (context) {
                return IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size:
                        ResponsiveDesignOrientation.isLandscape ? 12.sp : 25.sp,
                    color: kDark,
                  ),
                  onPressed: () {
                    context.go('/home');
                  },
                );
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
              child: Consumer(
                builder: (context, ref, child) {
                  final userToken = ref.watch(currentUserTokenStateProvider);
                  final points = userToken.remainingCredits ?? 0;
                  return MarAdsPointsBadge(points: points.toString());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// กล่อง "ข้อมูลเสริมอื่นๆ" ให้พิมพ์ได้เลย
  Widget _buildAdditionalInfoLabel() {
    return MarAdsTextField(
      label: 'ข้อมูลเสริมอื่นๆ (ไม่จำเป็นต้องกรอก)',
      placeholder: 'พลาดไม่ได้, หมดเขตในอีก 3 วัน',
      controller: _additionalInfoController,
      height: 100.h, // กำหนดความสูง
      maxLines: null, // พิมพ์ได้ไม่จำกัดบรรทัด
    );
  }

  void _handleModeSelectorTap() {
    MarAdsModeSelector.show(context, _selectedMode, (mode) {
      if (mode == 'Basic mode') {
        setState(() => _selectedMode = 'Basic mode');
      } else if (mode == 'Advanced mode') {
        context.go('/marads/advanced');
      } else if (mode == 'History') {
        context.go('/marads/history');
      }
    });
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

  Future<void> _handleCreateMessage() async {
    if (_isLoading) return;

    // กันเหนียว validate อีกที
    if (_productController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('กรุณากรอกข้อมูลที่จำเป็นให้ครบถ้วน'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      _logger.i("MarAds: start create_prompt_ads");

      final response = await _logic.createPromptAdsFromForm(
        ref: ref,
        context: context,
        productName: _productController.text,
        brandName: _brandController.text,
        price: _priceController.text,
        contentStyle: _selectedContentStyle,
        contentLengthLabel: _selectedContentLength,
        additionalInfo: _additionalInfoController.text,
      );

      _logger.i("MarAds: create_prompt_ads response: $response");

      // ดึงข้อความจาก response และส่งไปยังหน้า Result
      if (response != null && response['data'] != null) {
        String generatedText = response['data'].toString();

        // API ส่งมาเป็น "[ข้อความ...]" ต้องเอาวงเล็บออกเพื่อให้สวยงาม
        if (generatedText.startsWith('[') && generatedText.endsWith(']')) {
          generatedText = generatedText.substring(1, generatedText.length - 1);
        }

        // ส่ง text ไปผ่าน query parameters (routing.dart ของคุณรอรับ key ชื่อ 'text' อยู่แล้ว)
        context.push(
          Uri(
            path: '/marads/result',
            queryParameters: {
              'text': generatedText,
              'style': _selectedContentStyle,
              'product_name': _productController.text,
              'content_length': _selectedContentLength.contains('15')
                  ? 'สั้น'
                  : (_selectedContentLength.contains('30') ? 'กลาง' : 'ยาว'),
            },
          ).toString(),
        );
      } else {
        // กันเหนียว กรณี response มาผิดรูปแบบ
        context.push('/marads/result');
      }
    } catch (e, stack) {
      _logger.e(
        "MarAds: error on create_prompt_ads",
        error: e,
        stackTrace: stack,
      );
      if (mounted) {
        // แสดง Error ที่โยนมาจาก Service/Logic ให้ผู้ใช้เห็น
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception:', '').trim()),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}
