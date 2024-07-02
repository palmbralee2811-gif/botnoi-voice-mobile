import 'package:flow3/widgets/CategorySetting.dart';

import 'package:flow3/widgets/CategoryVoice.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        elevation: 16,
        shadowColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              title: const Text('Settings'),
              onTap: () {},
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedIconTheme: const IconThemeData(color: Color(0xFF9A96F5)),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/logo/menubar11.png',
              color: Colors.transparent,
              width: 45,
              height: 45,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _currentIndex == 1
                ? SvgPicture.asset(
                    'assets/logo/waveform-bold 1 (1).svg',
                    width: 24,
                    height: 24,
                  )
                : SvgPicture.asset(
                    'assets/logo/waveform-bold 1.svg',
                    width: 24,
                    height: 24,
                  ),
            label: 'สตูดิโอ',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/logo/menubar.png',
              color: Colors.transparent,
              width: 50,
              height: 50,
            ),
            label: '',
          ),
        ],
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          color: Color(0xFFFFFFFF),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Appbar(),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF00E0FF), Color(0xFF9A96F5)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
          ),
          // child: const SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [BottomVoice(), BuildVoice()],
            ),
          // ),
        ),
      ),
    );
  }
}

class BuildVoice extends StatelessWidget {
  const BuildVoice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Container(
      height: screenSize.height * 0.11,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 70,
                  width: 370,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 224, 221, 221),
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
                      )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "สร้างเสียง",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 4),
                        child: Image.asset(
                          'assets/logo/point.png',
                          width: 20,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '0',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BottomVoice extends StatefulWidget {
  const BottomVoice({Key? key}) : super(key: key);

  final int maxLength = 1000;

  @override
  _BottomVoiceState createState() => _BottomVoiceState();
}

class _BottomVoiceState extends State<BottomVoice> {
  
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
    var screenSize = MediaQuery.of(context).size;
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
                        height: _inputtext == 1 ? screenSize.height * 0.286 : screenSize.height * 0.522,
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
                                minLines: _inputtext == 1 ? 6 : 15,
                                maxLines: _inputtext == 1 ? 6 : 15,
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
                                      'กรุณากรอกข้อความที่ต้องการจะสร้าง...',
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
                      height: -_selectedPageIndexVoice == 1 ? screenSize.height * 0.07 : screenSize.height * 0.076,
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
                              padding: const EdgeInsets.only(right: 20),
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
                                    )),
                        ],
                      ))),
            ],
          ),
        ),
        if (_selectedPageIndexVoice == 1) ...[const CategoryVoice()],
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
                  height: _selectedPageIndexSetting == 1 ? screenSize.height * 0.068 : screenSize.height * 0.068,
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
      ],
    );
  }
}

class Appbar extends StatelessWidget {
  const Appbar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 109),
                child: Image.asset(
                  'assets/logo/Frame.png',
                  width: 50,
                  height: 50,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 70,
                        decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(255, 224, 221, 221),
                              blurRadius: 3.0,
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 35,
                              width: 27,
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/logo/point.png',
                                      width: 26,
                                      height: 26,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Column(
                              children: [
                                Text(
                                  '100',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
