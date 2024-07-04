
import 'package:flow3/widgets/CategoryVoice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  final int maxLength = 1000;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textController = TextEditingController();
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  int _selectedPageIndexVoice = 0;
  int _selectedPageIndexSetting = 0;
  int _inputtext = 0;
  // int _button = 0;

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
    final screenHeight = MediaQuery.of(context).size.height;
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;
    int _currentIndex = 0;
    if (_selectedPageIndexVoice == 1) {
      _inputtext = 1;
      // _button = 1;
      // if (_selectedPageIndexSetting == 1) {
      //   _selectedPageIndexVoice = 0;
      //   _selectedPageIndexSetting = 1;
      // }
    }
    // if (_selectedPageIndexSetting == 2) {
    //   _selectedPageIndexVoice = 1;
    //   _selectedPageIndexSetting = 0;
    // }
    if (_selectedPageIndexVoice == 2) {
      _inputtext = 0;
    }
    if (_selectedPageIndexSetting == 1) {
      _inputtext = 1;
    }

    return Scaffold(
      drawer: Drawer(
        elevation: 16,
        shadowColor: Colors.black,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
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
      // appBar: AppBar(
      //   backgroundColor: const Color(0xFFFFFFFF),
      //   title: AppBar(),
      // ),
      body: Column(
        children: <Widget>[
          SafeArea(
      child: Column(
        children: [
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 55.w,),
                Image.asset(
                  'assets/logo/Frame.png',
                  width: 30.w,
                  height: 34.h,
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 54.w,
                          decoration: BoxDecoration(
                            
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(255, 224, 221, 221),
                                blurRadius: 3.0,
                              ),
                            ],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 25.h,
                                width: 20.h,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/logo/point.png',
                                        width: 20.w,
                                        height: 20.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                    '100',
                                    style: TextStyle(
                                        fontSize: 12.sp,
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
          ),
        ],
      ),
    ),
          Container(
            color: Colors.blue,
            height: _inputtext == 1
                ? screenSizeheight * 0.35
                : screenSizeheight * 0.64,
            child: Padding(
              padding: EdgeInsets.all(10.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      width: screenSizewidth * 0.75.w,
                      height: _inputtext == 1
                          ? screenSizeheight * 0.24.h
                          : screenSizeheight * 0.40.h,
                      // _inputtext == 1
                      //     ? screenSizeheight * 0.270.h
                      //     : screenSizeheight * 0.40.h,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5.0,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 25.w, right: 10.w, top: 20.w),
                        child: Column(
                          children: [
                            TextField(
                              style: const TextStyle(color: Colors.black),
                              minLines: _inputtext == 1 ? 5 : 13,
                              maxLines: _inputtext == 1 ? 5 : 13,
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
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    'กรุณากรอกข้อความที่ต้องการจะสร้าง...',
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 14.sp),
                                hintMaxLines: 1,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 25.w),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 1.w),
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            textStyle:
                                                TextStyle(fontSize: 10.sp),
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
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12.sp,
                                      height: 1.h,
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
                ],
              ),
            ), // 60% of the screen height
          ),
          Expanded(
            child: Container(
              color: Colors.white,
              height: _inputtext == 1
                  ? screenSizeheight * 0.50
                  : screenSizeheight * 0.26,
              child: Column(children: [
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
                    child: Selectvoice(
                        screenSizeheight: screenSizeheight,
                        selectedPageIndexVoice: _selectedPageIndexVoice)),
                if (_selectedPageIndexVoice == 1)
                  if (_selectedPageIndexVoice == 1) ...[const CategoryVoice()],
                Expanded(
                  flex: 7,
                  child: InkWell(
                    onTap: () {
                      /////////////////
                    },
                    child: const BuildVoice()),
                ),
                Container(
                    height: screenSizeheight * 0.052.h,
                    width: screenSizewidth * 0.78.w,
                    color: const Color(0xFF27282B),
                    child: InkWell(
                      onTap: () {},
                      child: _currentIndex == 1
                          ? SvgPicture.asset(
                              'assets/logo/Property 1=studio, Property 2=deault (2).svg')
                          : SvgPicture.asset(
                              'assets/logo/Property 1=studio, Property 2=hover (1).svg'),
                    ))
              ]), // 40% of the screen height
            ),
          ),
        ],
      ),
    );
  }
}

class Selectvoice extends StatelessWidget {
  const Selectvoice({
    super.key,
    required this.screenSizeheight,
    required int selectedPageIndexVoice,
  }) : _selectedPageIndexVoice = selectedPageIndexVoice;

  final double screenSizeheight;
  final int _selectedPageIndexVoice;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: screenSizeheight * 0.06.h,
        decoration: BoxDecoration(
            color: Colors.transparent,
            border: Border.all(
              color: Colors.grey,
              width: 1.w,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Text(
                "เลือกเสียง",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(right: 20.w),
                child: _selectedPageIndexVoice == 1
                    ? Icon(
                        Icons.expand_less,
                        color: const Color(0xFF323130),
                        size: 20.sp,
                      )
                    : Icon(
                        Icons.expand_more,
                        color: const Color(0xFF323130),
                        size: 20.sp,
                      )),
          ],
        ));
  }
}

class Appbar extends StatelessWidget {
  const Appbar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 90.w),
                child: Image.asset(
                  'assets/logo/Frame.png',
                  width: 30.w,
                  height: 34.h,
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 54.w,
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
                              height: 25.h,
                              width: 20.h,
                              child: Padding(
                                padding: const EdgeInsets.all(2),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/logo/point.png',
                                      width: 20.w,
                                      height: 20.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  '100',
                                  style: TextStyle(
                                      fontSize: 12.sp,
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

class BuildVoice extends StatelessWidget {
  const BuildVoice({super.key});

  @override
  Widget build(BuildContext context) {
    double screenSizewidth = MediaQuery.of(context).size.width;
    double screenSizeheight = MediaQuery.of(context).size.height;
    return Container(
      height: screenSizeheight * 0.093.h,
      width: screenSizewidth * 0.78.w,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 55.h,
                width: screenSizewidth * 0.7.w,
                decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 224, 221, 221),
                      blurRadius: 6.0,
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10.r),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF9A96F5), Color(0xFF00E0FF)],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "สร้างเสียง",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 5.w, top: 4.w),
                      child: Image.asset(
                        'assets/logo/point.png',
                        width: 18.w,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0.w),
                      child: Text(
                        '0',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
