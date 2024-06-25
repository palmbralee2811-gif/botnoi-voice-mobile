import 'package:flow3/screen/data.dart';
import 'package:flutter/material.dart';

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
            icon: Image.asset(
              'assets/logo/menubar11.png',
              width: 50,
              height: 50,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/logo/Property 1=studio, Property 2=deault.png',
              width: 50,
              height: 50,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/logo/menubar.png',
              width: 50,
              height: 50,
            ),
            label: '',
          ),
        ],
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
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputText(),
              SelectVoice(),
              Setting(),
              BuildVoice(),
            ],
          ),
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
    return Container(
      height: 100,
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
                        colors: [Color(0xFF00E0FF), Color(0xFF9A96F5)],
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

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExpansionPanelList(
              expandIconColor: Colors.black,
              elevation: 4,
              animationDuration: const Duration(milliseconds: 700),
              expandedHeaderPadding: const EdgeInsets.all(4),
              expansionCallback: (int index, bool isExpanded) {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              children: [
                ExpansionPanel(
                  backgroundColor: Colors.white,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 12, bottom: 12),
                      child: Text(
                        'ตั้งค่าเพิ่มเติม',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                  body: Container(
                    color: Colors.white,
                    height: 247,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                  'assets/logo/Property 1=lange,Property 2=Default.png'),
                              Image.asset('assets/logo/language.png'),
                              Image.asset('assets/logo/Category.png'),
                              Image.asset('assets/logo/Category (4).png'),
                              Image.asset('assets/logo/Category (5).png'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  isExpanded: _isExpanded,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class SelectVoice extends StatefulWidget {
  const SelectVoice({Key? key}) : super(key: key);

  @override
  _SelectVoiceState createState() => _SelectVoiceState();
}

class _SelectVoiceState extends State<SelectVoice> {
  bool _isExpanded = false;

  bool get isExpanded => _isExpanded;

  void toggleExpandedState() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = AppDataBase.data;

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ExpansionPanelList(
              expandIconColor: Colors.black,
              elevation: 4,
              animationDuration: const Duration(milliseconds: 700),
              expandedHeaderPadding: const EdgeInsets.all(4),
              expansionCallback: (int index, bool isExpanded) {
                toggleExpandedState();
              },
              children: [
                ExpansionPanel(
                  backgroundColor: Colors.white,
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return const Padding(
                      padding: EdgeInsets.only(
                          left: 20, right: 20, top: 12, bottom: 12),
                      child: Text(
                        'เลือกเสียง',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    );
                  },
                  body: Container(
                    color: Colors.white,
                    height: 247,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                  'assets/logo/Property 1=lange,Property 2=Default.png'),
                              Image.asset('assets/logo/language.png'),
                              Image.asset('assets/logo/Category.png'),
                              Image.asset('assets/logo/Category (4).png'),
                              Image.asset('assets/logo/Category (5).png'),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 170,
                          width: 370,
                          child: GridView.builder(
                            itemCount: data.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              mainAxisSpacing: 5,
                              crossAxisSpacing: 5,
                              mainAxisExtent: 80,
                            ),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Container(
                                    width: 68,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Container(
                                            color: Colors.transparent,
                                            child: Column(
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: Image.asset(
                                                    '${data[index].image}',
                                                    width: 40,
                                                    height: 40,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                Text(
                                                  '${data[index].name}',
                                                  style: const TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  isExpanded: _isExpanded,
                ),
              ],
            ),
          ],
        ),
      ],
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
  _SelectVoiceState selectVoiceState = _SelectVoiceState();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool expanded = selectVoiceState.isExpanded;

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
                  height: expanded ? 240 : 230,
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
                                    () {}); // ต้องเรียก setState เพื่อให้การเปลี่ยนแปลงของ TextField ทำให้ Widget ที่เกี่ยวข้อง rebuild
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
                                            () {}); // ต้องเรียก setState เพื่อให้การเปลี่ยนแปลงทำให้ Widget ที่เกี่ยวข้อง rebuild
                                      },
                                      child: const Text(
                                        'ลบ',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            height: 1),
                                      ),
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
