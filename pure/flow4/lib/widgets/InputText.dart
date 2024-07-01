import 'package:flutter/material.dart';

class InputText extends StatefulWidget {
  const InputText({Key? key}) : super(key: key);

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  final TextEditingController _textController = TextEditingController();
  final int maxLength = 1000; // จำนวนคำสูงสุดที่อนุญาต

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Center(
                child: Container(
                  width: 380,
                  height: 475,
                  decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                      ),
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 25, right: 10, top: 20),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            TextField(
                              style: const TextStyle(color: Colors.black),
                              minLines: 16,
                              maxLines: 16,
                              keyboardType: TextInputType.multiline,
                              controller: _textController,
                              onChanged: (text) {
                                if (_textController.text.length > maxLength) {
                                  _textController.text = _textController.text
                                      .substring(0, maxLength);

                                  _textController.selection =
                                      TextSelection.fromPosition(
                                    TextPosition(
                                        offset: _textController.text.length),
                                  );
                                }
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    'กรุณากรอกข้อความที่ต้องการจะสร้าง...',
                                hintStyle:
                                    TextStyle(color: Colors.grey, fontSize: 20),
                                hintMaxLines: 1,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 25),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 1),
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        textStyle:
                                            const TextStyle(fontSize: 10),
                                      ),
                                      onPressed: () {
                                        _textController.clear();
                                        setState(() {});
                                      },
                                      child: Image.asset(
                                          'assets/logo/Frame 1028950648.png'),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${_textController.text.length}/$maxLength',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
