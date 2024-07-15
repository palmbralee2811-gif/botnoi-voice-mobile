import 'package:flutter/material.dart';
class InputTextSlide extends StatefulWidget {
  final String initialSentences;
  final Function(String) onSentencesChanged;

  const InputTextSlide({
    super.key,
    required this.initialSentences,
    required this.onSentencesChanged,
  });
  @override
  _InputTextSlideState createState() => _InputTextSlideState();
}

class _InputTextSlideState extends State<InputTextSlide> {
  late TextEditingController _textController = TextEditingController();
  
  @override
  void initState() {
    _textController = TextEditingController(text: widget.initialSentences);
    super.initState();
  }
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // bool expanded = selectVoiceState.isExpanded;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Center(
              child: Container(
                width: (MediaQuery.of(context).size.width)*0.85,
                height: (MediaQuery.of(context).size.height)*0.32,
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
                  padding: const EdgeInsets.only(left: 25, right: 10, top: 20),
                  child: Column(
                    children: [
                      Expanded(
                        child: TextField(
                          style: const TextStyle(color: Colors.black),
                          minLines: 6,
                          maxLines: 9,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.done,
                          controller: _textController,
                          onChanged: (text) {
                            setState(
                                () {}); 
                          },
                          onSubmitted: (text) {
                            FocusScope.of(context).unfocus();
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
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                                style: TextButton.styleFrom(
                                  textStyle:
                                      const TextStyle(fontSize: 10),
                                ),
                                onPressed: () {
                                  _textController.clear();
                                  setState(
                                      () {}); 
                                },
                                child: Image.asset('assets/images/vector_text.png'),
                            ),
                            Text(
                              '${_textController.text.length}/100',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 16,
                                fontFamily: 'Prompt',
                                height: 1,
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
              onPressed: (){
              widget.onSentencesChanged(_textController.text);
            }, 
              child: const Text('Update Sentences'),
          )
        ],
      ),
    );
  }
}
