import 'package:botnoivoice/screen/drawer/drawer_appbar.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/components/mar_ads_create_button.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/components/mar_ads_points_badge.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_collapsible_section.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/mar_ads_image_uploader.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // ตัวแปร State สำหรับควบคุมการยืดหดของ Section
  bool _isImageSectionExpanded = true;
  bool _isDetailSectionExpanded = true;

  //ตัวแปรเก็บ path รูปภาพที่เลือก
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadAllTokensIfLoggedIn(ref);
    });
    _logic = MarAdsLogic(PromptService());

    // สั่ง Rebuild หน้าจอทุกครั้งที่พิมพ์ เพื่อให้ปุ่มตรวจสอบ isNotEmpty ได้ทันที
    _productController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _productController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _additionalInfoController.dispose();
    super.dispose();
  }

  // [เพิ่ม] Helper: แปลงค่า Logic (ไทย) -> UI (ภาษาปัจจุบัน) สำหรับ Style
  String _getLocalizedStyleDisplay(BuildContext context, String logicValue) {
    switch (logicValue) {
      case 'จูงใจให้ใช้':
        return 'marads_basic.style_persuasive'.tr();
      case 'ตลก':
        return 'marads_basic.style_funny'.tr();
      case 'จริงจัง':
        return 'marads_basic.style_serious'.tr();
      case 'ออดอ้อน':
        return 'marads_basic.style_begging'.tr();
      case 'เรียกความสงสาร':
        return 'marads_basic.style_sympathy'.tr();
      case 'รีวิวสินค้า':
        return 'marads_basic.style_review'.tr();
      default:
        return logicValue;
    }
  }

  // [เพิ่ม] Helper: แปลงค่า Logic -> UI สำหรับ Length
  String _getLocalizedLengthDisplay(BuildContext context, String logicValue) {
    if (logicValue.contains('15')) return 'marads_basic.length_15'.tr();
    if (logicValue.contains('30')) return 'marads_basic.length_30'.tr();
    if (logicValue.contains('60')) return 'marads_basic.length_60'.tr();
    return logicValue;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

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
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFFFFFFF),
      drawer: const DrawerAppbar(),
      appBar: _buildAppBar(),
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
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
                      title: 'marads_basic.header_image'.tr(),
                      isExpanded: _isImageSectionExpanded,
                      onTap: () {
                        setState(() {
                          _isImageSectionExpanded = !_isImageSectionExpanded;
                        });
                      },
                    ),
                    if (_isImageSectionExpanded)
                      MarAdsImageUploader(
                        onImageSelected: (path, name) {
                          setState(() {
                            // อัปเดต path เพื่อนำไปใช้ validate และส่ง API
                            _selectedImagePath = path;
                          });
                        },
                      ),

                    // 2. ส่วนรายละเอียดสินค้า
                    SizedBox(height: 8.h),
                    MarAdsCollapsibleSection(
                      title: 'marads_basic.header_detail'.tr(),
                      isExpanded: _isDetailSectionExpanded,
                      onTap: () {
                        setState(() {
                          _isDetailSectionExpanded = !_isDetailSectionExpanded;
                        });
                      },
                    ),
                    if (_isDetailSectionExpanded)
                      Column(
                        children: [
                          MarAdsTextField(
                            label: 'marads_basic.label_product'.tr(),
                            placeholder:
                                'marads_basic.placeholder_product'.tr(),
                            controller: _productController,
                            isRequired: true,
                          ),
                          MarAdsTextField(
                            label: 'marads_basic.label_brand'.tr(),
                            placeholder: 'marads_basic.placeholder_brand'.tr(),
                            controller: _brandController,
                          ),
                          MarAdsTextField(
                            label: 'marads_basic.label_price'.tr(),
                            placeholder: 'marads_basic.placeholder_price'.tr(),
                            controller: _priceController,
                          ),
                          MarAdsDropdown(
                            label: 'marads_basic.label_style'.tr(),
                            value: _getLocalizedStyleDisplay(
                                context, _selectedContentStyle),
                            onTap: _handleContentStyleTap,
                          ),
                          MarAdsDropdown(
                            label: 'marads_basic.label_length'.tr(),
                            value: _getLocalizedLengthDisplay(
                                context, _selectedContentLength),
                            showInfoIcon: true,
                            onTap: _handleContentLengthTap,
                          ),
                          _buildAdditionalInfoLabel(), // กล่องข้อมูลเสริมพิมพ์ได้
                        ],
                      ),
                    SizedBox(height: 150.h),
                  ],
                ),
              ),
            ),
            MarAdsCreateButton(
              remainingCount: canCreateTimes.toString(),
              isFormValid: _productController.text.isNotEmpty ||
                  _selectedImagePath != null,
              isLoading: _isLoading,
              onPressed: _handleCreateMessage,
            ),
          ],
        ),
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
      label: 'marads_basic.label_extra'.tr(),
      placeholder: 'marads_basic.placeholder_extra'.tr(),
      controller: _additionalInfoController,
      height: 100.h,
      maxLines: null,
      textInputAction: TextInputAction.done, // Enable "Done" button
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.w),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 4. ติ่งสีเทาด้านบน (Gray Handle)
              Center(
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // 1. หัวข้อ + กากบาทมุมขวา
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'marads_basic.header_style'.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(
                      Icons.close,
                      size: 24.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // 3. รายการเลือก (Bold เมื่อถูกเลือก)
              ListTile(
                title: Text(
                  'marads_basic.style_persuasive'.tr(),
                  style: TextStyle(
                    fontWeight: _selectedContentStyle == 'จูงใจให้ใช้'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: const Color(0xFF262626),
                  ),
                ),
                onTap: () {
                  setState(() => _selectedContentStyle = 'จูงใจให้ใช้');
                  context.pop();
                },
              ),
              ListTile(
                title: Text(
                  'marads_basic.style_funny'.tr(),
                  style: TextStyle(
                    fontWeight: _selectedContentStyle == 'ตลก'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: const Color(0xFF262626),
                  ),
                ),
                onTap: () {
                  setState(() => _selectedContentStyle = 'ตลก');
                  context.pop();
                },
              ),
              ListTile(
                title: Text(
                  'marads_basic.style_serious'.tr(),
                  style: TextStyle(
                    fontWeight: _selectedContentStyle == 'จริงจัง'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: const Color(0xFF262626),
                  ),
                ),
                onTap: () {
                  setState(() => _selectedContentStyle = 'จริงจัง');
                  context.pop();
                },
              ),
              ListTile(
                title: Text(
                  'marads_basic.style_begging'.tr(),
                  style: TextStyle(
                    fontWeight: _selectedContentStyle == 'ออดอ้อน'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: const Color(0xFF262626),
                  ),
                ),
                onTap: () {
                  setState(() => _selectedContentStyle = 'ออดอ้อน');
                  context.pop();
                },
              ),
              ListTile(
                title: Text(
                  'marads_basic.style_sympathy'.tr(),
                  style: TextStyle(
                    fontWeight: _selectedContentStyle == 'เรียกความสงสาร'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: const Color(0xFF262626),
                  ),
                ),
                onTap: () {
                  setState(() => _selectedContentStyle = 'เรียกความสงสาร');
                  context.pop();
                },
              ),
              ListTile(
                title: Text(
                  'marads_basic.style_review'.tr(),
                  style: TextStyle(
                    fontWeight: _selectedContentStyle == 'รีวิวสินค้า'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: const Color(0xFF262626),
                  ),
                ),
                onTap: () {
                  setState(() => _selectedContentStyle = 'รีวิวสินค้า');
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleContentLengthTap() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.w),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 4. ติ่งสีเทาด้านบน
              Center(
                child: Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // 1. หัวข้อ + กากบาท
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'marads_basic.header_length'.tr(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(
                      Icons.close,
                      size: 24.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              ListTile(
                title: Text(
                  'marads_basic.length_15'.tr(),
                  style: TextStyle(
                    fontWeight: _selectedContentLength == '~15 วิ'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: const Color(0xFF262626),
                  ),
                ),
                onTap: () {
                  setState(() => _selectedContentLength = '~15 วิ');
                  context.pop();
                },
              ),
              ListTile(
                title: Text(
                  'marads_basic.length_30'.tr(),
                  style: TextStyle(
                    fontWeight: _selectedContentLength == '~30 วิ'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: const Color(0xFF262626),
                  ),
                ),
                onTap: () {
                  setState(() => _selectedContentLength = '~30 วิ');
                  context.pop();
                },
              ),
              ListTile(
                title: Text(
                  'marads_basic.length_60'.tr(),
                  style: TextStyle(
                    fontWeight: _selectedContentLength == '~60 วิ'
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: const Color(0xFF262626),
                  ),
                ),
                onTap: () {
                  setState(() => _selectedContentLength = '~60 วิ');
                  context.pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleCreateMessage() async {
    if (_isLoading) return;

    // กันเหนียว validate อีกที
    if (_productController.text.isEmpty && _selectedImagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('marads_basic.error_required_image_or_product'.tr()),
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
        imagePath: _selectedImagePath,
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
