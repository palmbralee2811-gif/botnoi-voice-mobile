// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:botnoivoice/screen/drawer/marads/widgets/ui/marads_ui_style.dart';

// class ProductPropertiesScreen extends StatefulWidget {
//   const ProductPropertiesScreen({super.key});

//   @override
//   State<ProductPropertiesScreen> createState() =>
//       _ProductPropertiesScreenState();
// }

// class _ProductPropertiesScreenState extends State<ProductPropertiesScreen> {
//   final TextEditingController _sizeController = TextEditingController();
//   final TextEditingController _modelController = TextEditingController();
//   final TextEditingController _materialController = TextEditingController();

//   String _selectedColor = 'ไม่ระบุ';

//   // hover state
//   bool _hoverSize = false;
//   bool _hoverModel = false;
//   bool _hoverMaterial = false;
//   bool _hoverColor = false;

//   @override
//   void dispose() {
//     _sizeController.dispose();
//     _modelController.dispose();
//     _materialController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: MarAdsUIStyle.grayBackground,
//       appBar: AppBar(
//         title: Text(
//           'คุณสมบัติของสินค้า (Optional)',
//           style: GoogleFonts.inter(
//               fontSize: 16.sp, fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         iconTheme: const IconThemeData(color: Colors.black87),
//       ),
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
//         child: Column(
//           children: [
//             _buildTextField(
//                 'ขนาด/ปริมาณ', '256 GB', _sizeController, (v) {
//               setState(() => _hoverSize = v);
//             }, _hoverSize),
//             SizedBox(height: 12.h),

//             _buildTextField(
//                 'รุ่น/ลาย/ประเภท', 'No.11', _modelController, (v) {
//               setState(() => _hoverModel = v);
//             }, _hoverModel),
//             SizedBox(height: 12.h),

//             _buildColorDropdown(),
//             SizedBox(height: 12.h),

//             _buildTextField(
//                 'วัสดุ/วัตถุดิบ/สเปค', 'M4 Chip', _materialController, (v) {
//               setState(() => _hoverMaterial = v);
//             }, _hoverMaterial),

//             const Spacer(),
//             _buildSubmitButton(),
//           ],
//         ),
//       ),
//     );
//   }

//   // -------------------------------
//   // TEXTFIELD UI
//   // -------------------------------
//   Widget _buildTextField(
//     String label,
//     String placeholder,
//     TextEditingController controller,
//     Function(bool) onHover,
//     bool isHover,
//   ) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label,
//             style: GoogleFonts.inter(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w400,
//                 color: const Color(0xFF262626))),
//         SizedBox(height: 5.h),

//         MouseRegion(
//           onEnter: (_) => onHover(true),
//           onExit: (_) => onHover(false),
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 150),
//             decoration: isHover
//                 ? MarAdsUIStyle.hoverStrokeBox
//                 : MarAdsUIStyle.strokeBox,
//             child: TextField(
//               controller: controller,
//               decoration: InputDecoration(
//                 hintText: placeholder,
//                 hintStyle: GoogleFonts.inter(
//                     fontSize: 12.sp,
//                     fontWeight: FontWeight.w400,
//                     color: MarAdsUIStyle.grayLight),
//                 border: InputBorder.none,
//                 contentPadding: EdgeInsets.symmetric(
//                     horizontal: 16.w, vertical: 12.h),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // -------------------------------
//   // DROPDOWN UI
//   // -------------------------------
//   Widget _buildColorDropdown() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('สีของสินค้า',
//             style: GoogleFonts.inter(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w400,
//                 color: const Color(0xFF262626))),
//         SizedBox(height: 5.h),

//         MouseRegion(
//           onEnter: (_) => setState(() => _hoverColor = true),
//           onExit: (_) => setState(() => _hoverColor = false),
//           child: GestureDetector(
//             onTap: _showColorPicker,
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 150),
//               height: 50.h,
//               padding: EdgeInsets.symmetric(horizontal: 16.w),
//               decoration: _hoverColor
//                   ? MarAdsUIStyle.hoverStrokeBox
//                   : MarAdsUIStyle.strokeBox,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     _selectedColor,
//                     style: GoogleFonts.inter(
//                         fontSize: 12.sp,
//                         fontWeight: FontWeight.w400,
//                         color: const Color(0xFF262626)),
//                   ),
//                   const Icon(Icons.keyboard_arrow_down, size: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _showColorPicker() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => ListView(
//         shrinkWrap: true,
//         children: ['ไม่ระบุ', 'แดง', 'น้ำเงิน', 'ดำ', 'ขาว']
//             .map((color) =>
//                 ListTile(title: Text(color), onTap: () {
//                   setState(() => _selectedColor = color);
//                   Navigator.pop(context);
//                 }))
//             .toList(),
//       ),
//     );
//   }

//   // -------------------------------
//   // SUBMIT BUTTON
//   // -------------------------------
//   Widget _buildSubmitButton() {
//     return Container(
//       width: double.infinity,
//       height: 56.h,
//       decoration: MarAdsUIStyle.solidButton,
//       child: ElevatedButton(
//         onPressed: () {
//           final result = {
//             'size': _sizeController.text,
//             'model': _modelController.text,
//             'color': _selectedColor,
//             'material': _materialController.text,
//           };
//           Navigator.pop(context, result);
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.transparent,
//           shadowColor: Colors.transparent,
//           shape: RoundedRectangleBorder(
//             borderRadius: MarAdsUIStyle.radius20,
//           ),
//         ),
//         child: Text(
//           'ตกลง',
//           style: GoogleFonts.inter(
//               fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.white),
//         ),
//       ),
//     );
//   }
// }
