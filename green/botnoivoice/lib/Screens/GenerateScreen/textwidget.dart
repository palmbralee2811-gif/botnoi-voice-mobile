import 'package:botnoivoice/Screens/GenerateScreen/CategoryVoice.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatefulWidget {
  final TextEditingController textController;

  const TextWidget({super.key, required this.textController, required Null Function(String speakerId) onSpeakerIdSelected});

  final int maxLength = 1000;

  @override
  _TextWidgetState createState() => _TextWidgetState();
}

class _TextWidgetState extends State<TextWidget> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  int _selectedPageIndexVoice = 0;
  int _selectedPageIndexSetting = 0;
  int _inputtext = 0;

  void _selectPageVoice(int index) {
    setState(() {
      _selectedPageIndexVoice = index;
    });
  }

  void _selectPageSetting(int index) {
    setState(() {
      _selectedPageIndexSetting = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    
    if (_selectedPageIndexVoice == 1) {
      _inputtext = 1;
      //categoryVoice
      if (_selectedPageIndexSetting == 1) {
        _selectedPageIndexVoice = 0;
        _selectedPageIndexSetting = 1;
      }
    }
    if (_selectedPageIndexSetting == 2) {
      _selectedPageIndexVoice = 1;
      _selectedPageIndexSetting = 0;
    }
    if (_selectedPageIndexVoice == 2) {
      _inputtext = 0;
    }
    if (_selectedPageIndexSetting == 1) {
      _inputtext = 1;
      //categorySetting
    }
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width: 380,
                        height: _inputtext == 1 ? 271 : 481,
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
                          padding: const EdgeInsets.only(
                              left: 25, right: 10, top: 20),
                          child: Column(
                            children: [
                              TextField(
                                style: const TextStyle(color: Colors.black),
                                minLines: _inputtext == 1 ? 7 : 16,
                                maxLines: _inputtext == 1 ? 7 : 16,
                                keyboardType: TextInputType.multiline,
                                controller: _textController,
                                onChanged: (text) {
                                  if (_textController.text.length >
                                      widget.maxLength) {
                                    _textController.text = _textController.text
                                        .substring(0, widget.maxLength);

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
                                      'พิมพ์ข้อความเพื่อสร้างเสียง',
                                  hintStyle: TextStyle(
                                      color: Colors.grey, fontSize: 20),
                                  hintMaxLines: 1,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 1),
                                          child: TextButton(
                                            style: TextButton.styleFrom(
                                              textStyle:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                            onPressed: () {
                                              _textController.clear();
                                              setState(
                                                  () {}); // To update the counter
                                            },
                                            child: Image.asset(
                                                'assets/logo/Frame 1028950648.png'),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${_textController.text.length}/${widget.maxLength}',
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
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            
            if (_selectedPageIndexVoice == 0) {
              _selectPageVoice(1);
            } else if (_selectedPageIndexVoice == 1) {
              _selectPageVoice(2);
            } else if (_selectedPageIndexVoice == 2) {
              _selectPageVoice(1);
            }
            
          },
          child: Column(
            children: [
              InkWell(
                  child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 224, 221, 221),
                              blurRadius: 6.0,
                            ),
                          ],
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey,
                            width: 1,
                          )),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "เลือกเสียง",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: _selectedPageIndexVoice == 1
                                  ? const Icon(
                                      Icons.expand_less,
                                      color: Color(0xFF323130),
                                      size: 30,
                                    )
                                  : const Icon(
                                      Icons.expand_more,
                                      color: Color(0xFF323130),
                                      size: 30,
                                    ),


                                    ),
                        ],
                      ))),
            ],
          ),
        ),
        
        if (_selectedPageIndexVoice == 1) ...[CategoryVoice(textController: widget.textController, speakerId: '',)],

        /*
        InkWell(
          onTap: () {
            if (_selectedPageIndexSetting == 0) {
              _selectPageSetting(1);
            } else if (_selectedPageIndexSetting == 1) {
              _selectPageSetting(2);
            } else if (_selectedPageIndexSetting == 2) {
              _selectPageSetting(1);
            }
          },
          

          child: Column(
            children: [
              Container(
                  height: 55,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 224, 221, 221),
                          blurRadius: 6.0,
                        ),
                      ],
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Text(
                          "ตั้งค่าเพิ่มเติม",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: _selectedPageIndexSetting == 1
                              ? const Icon(
                                  Icons.expand_less,
                                  color: Color(0xFF323130),
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.expand_more,
                                  color: Color(0xFF323130),
                                  size: 30,
                                )),
                    ],
                  )),
            ],
          ),
        ),

        if (_selectedPageIndexSetting == 1) ...[const CategorySetting()],
        */
      ],
    );
  }
}
