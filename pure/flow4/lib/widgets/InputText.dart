import 'package:flutter/material.dart';
class InputTextSlide extends StatefulWidget {
  const InputTextSlide({Key? key}) : super(key: key);

  @override
  _InputTextSlideState createState() => _InputTextSlideState();
}

class _InputTextSlideState extends State<InputTextSlide> {
  final TextEditingController _textController = TextEditingController();
  // _SelectVoiceState selectVoiceState = _SelectVoiceState();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool expanded = selectVoiceState.isExpanded;

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
                  height: 230,
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
                              minLines: 6,
                              maxLines: 9,
                              keyboardType: TextInputType.multiline,
                              controller: _textController,
                              onChanged: (text) {
                                setState(
                                    () {}); 
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
                                        setState(
                                            () {}); 
                                      },
                                      child: Image.asset('assets/logo/Frame 1028950648.png'),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${_textController.text.length}/100',
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

class InputText extends StatefulWidget {
  const InputText({Key? key}) : super(key: key);

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  final TextEditingController _textController = TextEditingController();
  // _SelectVoiceState selectVoiceState = _SelectVoiceState();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool expanded = selectVoiceState.isExpanded;

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
                                setState(
                                    () {}); 
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
                                        setState(
                                            () {});
                                      },
                                      child: Image.asset('assets/logo/Frame 1028950648.png'),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '${_textController.text.length}/100',
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
