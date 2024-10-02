import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCheckboxWidget extends StatefulWidget {
  const CustomCheckboxWidget({super.key});

  @override
  State<CustomCheckboxWidget> createState() => _CustomCheckboxWidgetState();
}

class _CustomCheckboxWidgetState extends State<CustomCheckboxWidget> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.h,
          decoration: BoxDecoration(
            color: isChecked ? const Color(0xFFB1E9FD) : Colors.white,
            borderRadius: BorderRadius.circular(4.r),
            border: Border.all(
              color: Colors.white,
            ),
          ),
          child: Checkbox(
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                isChecked = value ?? false;
              });
            },
            activeColor: const Color(0xFF00B0FF), // สีเมื่อถูกเลือก
            checkColor: Colors.white, // สีของเครื่องหมายถูก
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          'จดจำรหัสผ่าน',
          style: TextStyle(
            fontSize: 16.sp,
          ),
        ),
      ],
    );
  }
}
