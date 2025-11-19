import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:botnoivoice/shared/style/style.dart';
import 'package:botnoivoice/screen/responsive/responsive_design_orientation.dart';
import 'package:go_router/go_router.dart';

class MarAdsResultScreen extends StatefulWidget {
  final String? generatedText;

  const MarAdsResultScreen({
    super.key,
    this.generatedText,
  });

  @override
  State<MarAdsResultScreen> createState() => _MarAdsResultScreenState();
}

class _MarAdsResultScreenState extends State<MarAdsResultScreen> {
  late TextEditingController _textController;
  String _selectedCharacter = 'เอวา';
  String _selectedMode = 'Result';

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(
      text: widget.generatedText ??
          'พบกับโปรโมชั่นพิเศษสำหรับโทรศัพท์มือถือแบรนด์ Pineapple ราคาลดจาก 3,000 บาท เหลือเพียง 1,000 บาทเท่านั้น! โปรโมชั่นนี้มีถึงสิ้นเดือนนี้เท่านั้น อย่าพลาดโอกาสที่จะเป็นเ���้าของโทรศัพท์คุณภาพในราคาสุดคุ้ม รับประกันความพึงพอใจในทุกการใช้งาน!',
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  int get _characterCount => _textController.text.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildModeSelectorRow(),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: _buildTextBox(),
              ),
            ),
          ),
          _buildBottomButtons(),
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
                context.go('/home');
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
              child: _buildPointsBadge(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsBadge() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 20.w,
            height: 20.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF262626),
            ),
            child: Center(
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF01BFFB), Color(0xFFEB85FC)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ).createShader(bounds),
                child: Text(
                  'P',
                  style: GoogleFonts.inter(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Text(
              '100',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF262626),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelectorRow() {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.fromLTRB(16.w, 5.h, 16.w, 5.h),
    color: Colors.white,
    child: Row(
      children: [
        _buildCharacterSelector(),
        Spacer(),
        _buildResultSelector(),
      ],
    ),
  );
}




  Widget _buildCharacterSelector() {
  return GestureDetector(
    onTap: _handleCharacterSelectorTap,
    child: Container(
      height: 33.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FA),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: const Color(0xFF868688),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 25.w,
            height: 25.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300],
            ),
            child: Center(
              child: Icon(
                Icons.female,
                size: 16.sp,
                color: Colors.pink,
              ),
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            _selectedCharacter,
            style: GoogleFonts.prompt(
              fontSize: 10.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF262626),
            ),
          ),
          SizedBox(width: 5.w),
          Icon(
            Icons.keyboard_arrow_down,
            size: 12.sp,
            color: const Color(0xFF262626),
          ),
        ],
      ),
    ),
  );
}





  Widget _buildResultSelector() {
    const gradient = LinearGradient(
      colors: [Color(0xFF01BFFB), Color(0xFFEB85FC)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return GestureDetector(
      onTap: _handleResultSelectorTap,
      child: CustomPaint(
        painter: _GradientBorderPainter(
          gradient: gradient,
          radius: 8.r,
        ),
        child: Container(
          height: 33.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F8FA),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => gradient.createShader(bounds),
                child: Text(
                  _selectedMode,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                    height: 1.67,
                    letterSpacing: 0.25,
                  ),
                ),
              ),
              SizedBox(width: 5.w),
              ShaderMask(
                shaderCallback: (bounds) => gradient.createShader(bounds),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 12.sp,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextBox() {
    const gradient = LinearGradient(
      colors: [Color(0xFF01BFFB), Color(0xFFEB85FC)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Container(
      padding: EdgeInsets.all(2.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9747FF).withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 300.h,
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF262626),
                  height: 1.43,
                  letterSpacing: 0.25,
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(height: 20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    _textController.clear();
                    setState(() {});
                  },
                  child: Icon(
                    Icons.close,
                    size: 24.sp,
                    color: const Color(0xFF4F4F4F),
                  ),
                ),
                Text(
                  '$_characterCount ตัวอักษร',
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF888888),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: const Color(0xFF262626),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              onPressed: _handleCreateVoice,
              child: Text(
                'สร้างเสียง',
                style: GoogleFonts.lexend(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  height: 1.4,
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: const Color(0xFFE5E5E5),
                width: 1,
              ),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              onPressed: _handleMakeMorePersuasive,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'ทำให้ดูโน้มน้าวมากขึ้น',
                    style: GoogleFonts.lexend(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF262626),
                      height: 1.4,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  _buildPointsIconWithCount(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointsIconWithCount() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16.w,
          height: 16.h,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF262626),
                ),
              ),
              Center(
                child: ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Color(0xFF01BFFB), Color(0xFFEB85FC)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ).createShader(bounds),
                  child: Text(
                    'P',
                    style: GoogleFonts.inter(
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          '15',
          style: GoogleFonts.lexend(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF262626),
            height: 1.4,
          ),
        ),
      ],
    );
  }

  void _handleCharacterSelectorTap() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "เลือกคาแรกเตอร์",
              style: GoogleFonts.prompt(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),
            const Divider(),
            ListTile(
              title: const Text('เอวา'),
              onTap: () {
                setState(() => _selectedCharacter = 'เอวา');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('แจ็ค'),
              onTap: () {
                setState(() => _selectedCharacter = 'แจ็ค');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('มายด์'),
              onTap: () {
                setState(() => _selectedCharacter = 'มายด์');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleResultSelectorTap() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "เลือกโหมด",
              style: GoogleFonts.prompt(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 12.h),
            const Divider(),
            ListTile(
              title: const Text('Result'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Edit'),
              onTap: () {
                setState(() => _selectedMode = 'Edit');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _handleCreateVoice() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('กำลังสร้างเสียง...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleMakeMorePersuasive() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('กำลังปรับปรุงข��อความให้โน้มน้าวมากขึ้น...'),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  final Gradient gradient;
  final double radius;

  _GradientBorderPainter({required this.gradient, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
