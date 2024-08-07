import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TextBoxInput extends StatefulWidget {
  final String initialText;
  final Function(String) onTextChanged;

  const TextBoxInput({
    super.key,
    required this.initialText,
    required this.onTextChanged,
  });

  final int maxLength = 1000;

  @override
  State<TextBoxInput> createState() => _TextBoxInputState();
}

class _TextBoxInputState extends State<TextBoxInput> {
  late TextEditingController textController = TextEditingController();

  @override
  void initState() {
    textController = TextEditingController(text: widget.initialText);
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool expanded = selectVoiceState.isExpanded;
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
            child: Center(
              child: Container(
                width: (MediaQuery.of(context).size.width) * 0.85.w,
                height: (MediaQuery.of(context).size.height) * 0.32.h,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 5.r,
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 10.w, top: 20.h),
                  child: Column(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.black),
                          minLines: 6,
                          maxLines: 9,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          controller: textController,
                          onChanged: (text) {
                            if (textController.text.length > widget.maxLength) {
                              textController.text = textController.text
                                  .substring(0, widget.maxLength);
                              textController.selection =
                                  TextSelection.fromPosition(
                                TextPosition(
                                    offset: textController.text.length),
                              );
                            }
                            setState(() {
                              // _showClearIcon = textController.text.isNotEmpty;
                            });
                          },
                          onSubmitted: (text) {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'พิมพ์ข้อความให้ตรงกับภาษาที่เลือก . . .',
                            hintStyle: TextStyle(
                              color: const Color(0xFFA19F9D),
                              fontStyle:
                                  GoogleFonts.prompt(fontSize: 14.sp).fontStyle,
                            ),
                            hintMaxLines: 1,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              textStyle: TextStyle(fontSize: 10.sp),
                            ),
                            onPressed: () {
                              textController.clear();
                              setState(() {});
                            },
                            child: Image.asset('assets/images/vector_text.png'),
                          ),
                          Text(
                            '${textController.text.length} / ${widget.maxLength}',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16.sp,
                              fontFamily: 'Prompt',
                              height: 1.h,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onTextChanged(textController.text);
            },
            child: const Text('แก้ไขข้อความ'),
          )
        ],
      ),
    );
  }
}
