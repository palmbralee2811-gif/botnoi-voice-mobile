import 'dart:math';
import 'package:botnoivoice/screen/drawer/marads/widgets/logic/mar_ads_advanced_logic.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/models/mar_ads_mock_data.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/service/prompt_service.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/advanced/advanced_basic_info_section.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/advanced/advanced_promotion_section.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/advanced/advanced_sales_style_section.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/components/mar_ads_create_button.dart';
import 'package:botnoivoice/screen/drawer/marads/widgets/ui/components/mar_ads_points_badge.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import '../ui/mar_ads_mode_selector.dart';
import '../ui/basic_mar_ads_text_field.dart';
import '../ui/mar_ads_dropdown.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:botnoivoice/screen/drawer/drawer_appbar.dart';
import 'package:go_router/go_router.dart';

class MarAdsAdvancedScreen extends ConsumerStatefulWidget {
  const MarAdsAdvancedScreen({super.key});

  @override
  ConsumerState<MarAdsAdvancedScreen> createState() =>
      _MarAdsAdvancedScreenState();
}

class _MarAdsAdvancedScreenState extends ConsumerState<MarAdsAdvancedScreen> {
  // เพิ่มตัวแปร Logic และ Logger
  late final MarAdsAdvancedLogic _logic;
  final Logger _logger = Logger();
  bool _isLoading = false;
  String _selectedMode = 'Advanced mode';
  String _selectedContentLength = '~30 วิ';
  String _selectedSalesCharacter = 'แม่ค้าสาวสุดสวย';
  String _selectedContentStyle = 'จูงใจให้ใช้';

  //  Map สีสำหรับแสดงผล
  String _selectedProductColor = '';
  final Map<String, Color> _colorMap = {
    'ดำ': const Color(0xFF262626),
    'แดง': const Color(0xFFFF0000),
    'ขาว': const Color(0xFFFFFFFF),
    'ชมพู': const Color(0xFFFF40E5),
    'น้ำเงิน': const Color(0xFF0055FF),
  };

  final List<String> _salesCharacters = const [
    'แม่ค้าสาวสุดสวย',
    'เด็กประถม',
    'วัยรุ่นผู้ชาย',
    'วัยรุ่นผู้หญิง',
    'พ่อค้ามือทอง',
    'ป้าข้างบ้าน',
    'ลุงกำนัน',
    'คุณตา',
    'คุณยาย',
  ];

  final List<String> _contentStyles = const [
    'จูงใจให้ใช้',
    'ตลก',
    'จริงจัง',
    'ออดอ้อน',
    'เรียกความสงสาร',
    'รีวิวสินค้า'
  ];

  final Map<String, String> _characterToSpeakerId = {
    'แม่ค้าสาวสุดสวย': '6',
    'เด็กประถม': '2',
    'วัยรุ่นผู้ชาย': '31',
    'วัยรุ่นผู้หญิง': '3',
    'พ่อค้ามือทอง': '5',
    'ป้าข้างบ้าน': '89',
    'ลุงกำนัน': '46',
  };

  // [เพิ่ม] Helper: แปลงชื่อคาแรกเตอร์เป็นภาษาปัจจุบัน
  String _getLocalizedCharacterDisplay(String logicValue) {
    switch (logicValue) {
      case 'แม่ค้าสาวสุดสวย':
        return 'marads_adv.char_beauty'.tr();
      case 'เด็กประถม':
        return 'marads_adv.char_kid'.tr();
      case 'วัยรุ่นผู้ชาย':
        return 'marads_adv.char_teen_boy'.tr();
      case 'วัยรุ่นผู้หญิง':
        return 'marads_adv.char_teen_girl'.tr();
      case 'พ่อค้ามือทอง':
        return 'marads_adv.char_pro_seller'.tr();
      case 'ป้าข้างบ้าน':
        return 'marads_adv.char_auntie'.tr();
      case 'ลุงกำนัน':
        return 'marads_adv.char_chief'.tr();
      case 'คุณตา':
        return 'marads_adv.char_grandpa'.tr();
      case 'คุณยาย':
        return 'marads_adv.char_grandma'.tr();
      default:
        return logicValue;
    }
  }

  // [เพิ่ม] Helper: แปลงสไตล์เนื้อหา (ใช้ Key เดิมจาก Basic ได้ หรือสร้างใหม่ก็ได้)
  String _getLocalizedStyleDisplay(String logicValue) {
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

  // [เพิ่ม] Helper: แปลงสี
  String _getLocalizedColorDisplay(String logicValue) {
    switch (logicValue) {
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
        return logicValue;
    }
  }

  // [เพิ่ม] Helper: แปลงความยาว
  String _getLocalizedLengthDisplay(String logicValue) {
    if (logicValue.contains('30')) return 'marads_basic.length_30'.tr();
    if (logicValue.contains('60')) return 'marads_basic.length_60'.tr();
    return logicValue;
  }

  final TextEditingController _productController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _promotionController = TextEditingController();
  final TextEditingController _targetCustomersController =
      TextEditingController();
  final TextEditingController _sellingPointController = TextEditingController();
  final TextEditingController _whyBuyController = TextEditingController();
  final TextEditingController _sizeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _materialController = TextEditingController();
  final TextEditingController _additionalInfoController =
      TextEditingController();

  bool _isBasicInfoExpanded = true;
  bool _isSalesStyleExpanded = true;
  bool _isPromotionInfoExpanded = true;

  void _randomizeText({
    required TextEditingController controller,
    required Map<int, String> thData,
    required Map<int, String> enData,
  }) {
    // เช็คภาษาปัจจุบันของ App
    final String currentLang = Localizations.localeOf(context).languageCode;

    // เลือก Data ตามภาษา (ถ้าไม่ใช่ th ให้ใช้ en)
    final Map<int, String> selectedData =
        (currentLang == 'th') ? thData : enData;

    if (selectedData.isNotEmpty) {
      final random = Random();
      final List<String> values = selectedData.values.toList();
      // สุ่มและใส่ค่าลง Controller
      setState(() {
        controller.text = values[random.nextInt(values.length)];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _logic = MarAdsAdvancedLogic(PromptService());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadAllTokensIfLoggedIn(ref);
    });
  }

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
    _additionalInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userToken = ref.watch(currentUserTokenStateProvider);
    final int currentPoints =
        int.tryParse(userToken.remainingCredits.toString()) ?? 0;

    // คำนวณราคาตามความยาวที่เลือก ( ~30, ~60 วิ)
    int costPerGen = 100; // เริ่มต้นที่ 30 วิ (100 Points)
    if (_selectedContentLength.contains('60')) {
      costPerGen = 150; // ถ้าเลือก 60 วิ เป็น 150 Points
    }

    // คำนวณจำนวนครั้งที่สามารถสร้างได้
    final int canCreateTimes =
        costPerGen == 0 ? 999 : (currentPoints / costPerGen).floor();

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
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
                  AdvancedBasicInfoSection(
                    isExpanded: _isBasicInfoExpanded,
                    onToggle: () => setState(
                        () => _isBasicInfoExpanded = !_isBasicInfoExpanded),
                    productController: _productController,
                    brandController: _brandController,
                    priceController: _priceController,
                    // ส่ง Function สร้างปุ่ม Tags เดิมเข้าไปแสดงผล
                    productPropertiesButton: _buildProductPropertiesButton(),
                  ),
                  SizedBox(height: 16.h),
                  AdvancedSalesStyleSection(
                    isExpanded: _isSalesStyleExpanded,
                    onToggle: () => setState(
                        () => _isSalesStyleExpanded = !_isSalesStyleExpanded),
                    // selectedSalesCharacter: _selectedSalesCharacter,
                    onTapSalesCharacter: _handleSalesCharacterTap,
                    // selectedContentStyle: _selectedContentStyle,
                    onTapContentStyle: _handleContentStyleTap,

                    selectedSalesCharacter:
                        _getLocalizedCharacterDisplay(_selectedSalesCharacter),
                    selectedContentStyle:
                        _getLocalizedStyleDisplay(_selectedContentStyle),
                  ),
                  SizedBox(height: 16.h),
                  AdvancedPromotionSection(
                    isExpanded: _isPromotionInfoExpanded,
                    onToggle: () => setState(() =>
                        _isPromotionInfoExpanded = !_isPromotionInfoExpanded),
                    promotionController: _promotionController,
                    targetCustomersController: _targetCustomersController,
                    sellingPointController: _sellingPointController,
                    whyBuyController: _whyBuyController,
                    onRandomSellingPoint: () {
                      _randomizeText(
                        controller: _sellingPointController,
                        thData: MarAdsMockData
                            .thAdvantage, // จุดขายที่ดีกว่าคู่แข่ง
                        enData: MarAdsMockData.enAdvantage,
                      );
                    },
                    onRandomWhyBuy: () {
                      _randomizeText(
                        controller: _whyBuyController,
                        thData: MarAdsMockData.thReason,
                        enData: MarAdsMockData.enReason,
                      );
                    },
                  ),
                  SizedBox(height: 16.h),
                  MarAdsDropdown(
                    // ใช้ Widget กลาง
                    label: 'marads_adv.label_length'.tr(),
                    value: _getLocalizedLengthDisplay(_selectedContentLength),
                    showInfoIcon: true,
                    onTap: _handleContentLengthTap,
                  ),
                  MarAdsTextField(
                    label: 'marads_adv.label_extra'.tr(),
                    placeholder: 'marads_adv.placeholder_extra'.tr(),
                    controller: _additionalInfoController,
                    height: 100.h,
                    maxLines: null,
                  ),
                ],
              ),
            ),
          ),
          MarAdsCreateButton(
            remainingCount: canCreateTimes.toString(),
            isFormValid: _productController.text.isNotEmpty &&
                _brandController.text.isNotEmpty &&
                _priceController.text.isNotEmpty,
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
              builder: (context) {
                return IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size:
                        ResponsiveDesignOrientation.isLandscape ? 12.sp : 25.sp,
                    color: const Color(0xFF3D3D3D),
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

  Widget _buildProductPropertiesButton() {
    // เช็คว่ามีการกรอกข้อมูลอะไรมาบ้างไหม
    bool hasProperties = _sizeController.text.isNotEmpty ||
        _modelController.text.isNotEmpty ||
        _materialController.text.isNotEmpty ||
        (_selectedProductColor.isNotEmpty &&
            _selectedProductColor != 'ไม่ระบุ');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      alignment: Alignment.centerLeft, // จัดชิดซ้าย
      child: hasProperties
          ? Wrap(
              spacing: 8.w, // ระยะห่างแนวนอนระหว่าง Tags
              runSpacing: 8.h,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // แสดง Tags ตามข้อมูลที่มี
                if (_sizeController.text.isNotEmpty)
                  _buildInfoChip(_sizeController.text, () {
                    setState(() {
                      _sizeController.clear();
                    });
                  }),
                if (_modelController.text.isNotEmpty)
                  _buildInfoChip(_modelController.text, () {
                    setState(() {
                      _modelController.clear();
                    });
                  }),
                if (_selectedProductColor.isNotEmpty &&
                    _selectedProductColor != 'ไม่ระบุ')
                  _buildColorChip(_selectedProductColor, () {
                    setState(() {
                      _selectedProductColor = '';
                    });
                  }),
                if (_materialController.text.isNotEmpty)
                  _buildInfoChip(_materialController.text, () {
                    setState(() {
                      _materialController.clear();
                    });
                  }),

                // ปุ่ม + เล็กๆ
                _buildSmallAddButton(),
              ],
            )
          : _buildInitialAddButton(), // ถ้าไม่มีข้อมูล โชว์ปุ่มใหญ่เหมือนเดิม
    );
  }

  // ปุ่มใหญ่ตอนแรก (คุณสมบัติของสินค้า +)
  Widget _buildInitialAddButton() {
    return GestureDetector(
      onTap: _navigateToProductProperties,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: const LinearGradient(
            colors: [Color(0xFFD6C8DD), Color(0xFFDEC9D4)], // สีม่วงจางๆ ตามธีม
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min, // หดขนาดเท่าเนื้อหา (ชิดซ้าย)
          children: [
            Text(
              'marads_adv.btn_properties'.tr(),
              style: GoogleFonts.prompt(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF262626),
              ),
            ),
            SizedBox(width: 8.w),
            Icon(Icons.add, size: 16.w, color: const Color(0xFF262626)),
          ],
        ),
      ),
    );
  }

  // ปุ่ม + เล็กๆ
  Widget _buildSmallAddButton() {
    return GestureDetector(
      onTap: _navigateToProductProperties,
      child: Container(
        width: 32.h,
        height: 32.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          gradient: const LinearGradient(
            colors: [Color(0xFFD6C8DD), Color(0xFFDEC9D4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Icon(Icons.add, size: 18.w, color: const Color(0xFF262626)),
      ),
    );
  }

  // Tag ข้อความทั่วไป
  Widget _buildInfoChip(String label, VoidCallback onDelete) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 6.h, 8.w, 6.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: GoogleFonts.prompt(
              fontSize: 12.sp,
              color: const Color(0xFF262626),
            ),
          ),
          SizedBox(width: 6.w), // ระยะห่าง
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.close_rounded,
              size: 14.sp,
              color: const Color(0xFF888888),
            ),
          ),
        ],
      ),
    );
  }

  // Tag สี (มีวงกลมสีนำหน้า)
  Widget _buildColorChip(String colorName, VoidCallback onDelete) {
    final color = _colorMap[colorName] ?? Colors.grey;
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 6.h, 8.w, 6.h),
      decoration: BoxDecoration(
        // ใช้ Gradient พื้นหลังจางๆ เพื่อให้ดูพรีเมียมเหมือนรูปตัวอย่าง
        gradient: LinearGradient(
          colors: [
            const Color(0xFFD6C8DD).withOpacity(0.3),
            const Color(0xFFDEC9D4).withOpacity(0.3)
          ],
        ),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFD6C8DD)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: colorName == 'ขาว'
                  ? Border.all(color: Colors.grey.shade300)
                  : null,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            colorName,
            style: GoogleFonts.prompt(
              fontSize: 12.sp,
              color: const Color(0xFF262626),
            ),
          ),
          SizedBox(width: 6.w),
          GestureDetector(
            onTap: onDelete,
            child: Icon(
              Icons.close_rounded,
              size: 14.sp,
              color: const Color(0xFF888888),
            ),
          ),
        ],
      ),
    );
  }

  // ฟังก์ชันนำทางและรับค่ากลับ
  Future<void> _navigateToProductProperties() async {
    final result = await context.push('/marads/product-properties');

    if (result != null && result is Map) {
      // แก้ type check ให้กว้างขึ้นกันพลาด
      setState(() {
        _sizeController.text = result['size']?.toString() ?? '';
        _modelController.text = result['model']?.toString() ?? '';
        _materialController.text = result['material']?.toString() ?? '';
        _selectedProductColor = result['color']?.toString() ?? '';
      });
    }
  }

  //// ฟังก์ชันแปลงคาแรกเตอร์เป็น Speaker ID
  String? _getSpeakerIdFromCharacter(String character) {
    return _characterToSpeakerId[character];
  }

  // เพิ่มฟังก์ชันสำหรับยิง API
  Future<void> _handleCreateMessage() async {
    if (_isLoading) return;
    if (_productController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8.w),
              Text('marads_adv.error_no_product'.tr()),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      _logger.i("MarAds Advanced: start create_prompt_ads");

      final response = await _logic.createAdvancedPromptAds(
        ref: ref,
        context: context,
        productName: _productController.text,
        brandName: _brandController.text,
        price: _priceController.text,

        // Properties
        size: _sizeController.text,
        model: _modelController.text,
        material: _materialController.text,
        color: _selectedProductColor,

        // Style
        salesCharacter: _selectedSalesCharacter,
        contentStyle: _selectedContentStyle,

        // Promo
        promotion: _promotionController.text,
        targetCustomers: _targetCustomersController.text,
        sellingPoint: _sellingPointController.text,
        whyBuy: _whyBuyController.text,

        contentLengthLabel: _selectedContentLength,
        additionalInfo: _additionalInfoController.text,
      );

      _logger.i("Response: $response");

      if (response != null && response['data'] != null) {
        String generatedText = response['data'].toString();
        // ลบวงเล็บ [ ] ออกถ้ามี
        if (generatedText.startsWith('[') && generatedText.endsWith(']')) {
          generatedText = generatedText.substring(1, generatedText.length - 1);
        }

        // หา Speaker ID จากคาแรกเตอร์ที่เลือก
        final String? targetSpeakerId =
            _getSpeakerIdFromCharacter(_selectedSalesCharacter);

        // ไปหน้า Result พร้อมข้อความ
        if (mounted) {
          context.push(
            Uri(
              path: '/marads/result',
              queryParameters: {
                'text': generatedText,
                'style': _selectedContentStyle,
                'mode': 'advanced',
                'product_name': _productController.text,
                'sales_character': _selectedSalesCharacter,
                'content_length':
                    _selectedContentLength.contains('30') ? 'กลาง' : 'ยาว',
                if (targetSpeakerId != null)
                  'speaker_id': targetSpeakerId, // ส่ง ID ไปด้วย
              },
            ).toString(),
          );
        }
      } else {
        // กรณี response ผิดพลาดหรือไม่มา
        if (mounted) context.push('/marads/result');
      }
    } catch (e, stack) {
      _logger.e("Error creating ad", error: e, stackTrace: stack);
      if (mounted) {
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

  void _handleModeSelectorTap() {
    MarAdsModeSelector.show(context, _selectedMode, (mode) {
      if (mode == 'Basic mode') {
        context.go('/marads'); //นำทางไปยังหน้า Basic
      } else if (mode == 'Advanced mode') {
        setState(() => _selectedMode =
            'Advanced mode'); // แค่อัปเดต UI ให้ Modal รู้ว่าเลือกอันนี้อยู่
      } else if (mode == 'History') {
        context.go('/marads/history');
      }
    });
  }

  void _handleSalesCharacterTap() {
    _showSelectionModal(
      title: 'marads_adv.header_character'.tr(),
      items: _salesCharacters,
      selectedValue: _selectedSalesCharacter, // ส่งค่าที่เลือกปัจจุบัน
      onSelected: (val) => setState(() => _selectedSalesCharacter = val),
      itemBuilder: (val) => _getLocalizedCharacterDisplay(val),
    );
  }

  void _handleContentStyleTap() {
    _showSelectionModal(
      title: 'marads_adv.header_style'.tr(),
      items: _contentStyles, // ใช้ Constants
      selectedValue: _selectedContentStyle,
      onSelected: (val) => setState(() => _selectedContentStyle = val),
      itemBuilder: (val) => _getLocalizedStyleDisplay(val),
    );
  }

  void _handleContentLengthTap() {
    final List<String> lengths = ['~30 วิ', '~60 วิ'];

    _showSelectionModal(
      title: 'marads_adv.header_length'.tr(),
      items: lengths,
      selectedValue: _selectedContentLength,
      onSelected: (val) => setState(() => _selectedContentLength = val),
      itemBuilder: (val) => _getLocalizedLengthDisplay(val),
    );
  }

  void _showSelectionModal({
    required String title,
    required List<String> items,
    required Function(String) onSelected,
    required String selectedValue, // รับค่ามาเพื่อเช็คตัวหนา
    String Function(String)? itemBuilder,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // หรือ false ถ้าไม่ต้องการให้เต็มจอมาก แต่ true ยืดหยุ่นกว่า
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. ติ่งสีเทาด้านบน
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

              // 2. หัวข้อ + ปุ่มปิด
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.prompt(
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
              ...items.map((item) => ListTile(
                    title: Text(
                      itemBuilder != null ? itemBuilder(item) : item,
                      style: GoogleFonts.prompt(
                          fontSize: 14.sp,
                          fontWeight: item == selectedValue
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: const Color(0xFF262626)),
                    ),
                    onTap: () {
                      onSelected(item);

                      context.pop();
                    },
                  )),
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        ),
      ),
    );
  }
}
