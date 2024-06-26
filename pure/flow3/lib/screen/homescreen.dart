import 'package:flow3/widgets/CategorySetting.dart';
import 'package:flow3/widgets/Inputtext.dart';
import 'package:flow3/widgets/Setting.dart';

import 'package:flow3/widgets/Voice.dart';
import 'package:flow3/widgets/CategoryVoice.dart';
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
              BottomVoice(),
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

class BottomVoice extends StatefulWidget {
  const BottomVoice({Key? key}) : super(key: key);

  @override
  _BottomVoiceState createState() => _BottomVoiceState();
}

class _BottomVoiceState extends State<BottomVoice> {
  int _selsectedPageIndexVoice = 0;
  int _selsectedPageIndexSetting = 0;
  void _selsectedPageVoice(int index) {
    setState(() {
      _selsectedPageIndexVoice = index;
    });
  }
  void _selsectedPageSetting(int index) {
    setState(() {
      _selsectedPageIndexSetting = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage1 = const SelectVoice();
    Widget activePage2 = const InputText();
    Widget activePage3 = const Setting();
/////////////////////Voice/////////////////////
    if (_selsectedPageIndexVoice == 1) {
      activePage1 = const CategoryVoice();
      activePage2 = const InputTextSlide();
    }
    if (_selsectedPageIndexVoice == 2) {
      activePage1 = const SelectVoice();
      activePage2 = const InputText();
    }
 ////////////////////Setting/////////////////
    if (_selsectedPageIndexSetting == 1) {
      // activePage3 = const Setting();
      activePage1 = const CategorySetting();
      activePage2 = const InputTextSlide();
    }
    if (_selsectedPageIndexSetting == 2) {
      activePage1 = const SelectVoice();
      activePage2 = const InputText();
    }
    return Column(
      children: [
        InkWell(
            onTap: () {
              if (_selsectedPageIndexVoice == 0) {
                _selsectedPageVoice(1);
                return;
              }
              if (_selsectedPageIndexVoice == 1) {
                _selsectedPageVoice(2);
                return;
              }
              if (_selsectedPageIndexVoice == 2) {
                _selsectedPageVoice(1);
                return;
              }
            },
            child: Column(children: [
              activePage2,
              activePage1,
              // activePage3
            ])),
        InkWell(
            onTap: () {
              if (_selsectedPageIndexSetting == 0) {
                _selsectedPageSetting(1);
                return;
              }
              if (_selsectedPageIndexSetting == 1) {
                _selsectedPageSetting(2);
                return;
              }
              if (_selsectedPageIndexSetting == 2) {
                _selsectedPageSetting(1);
                return;
              }
            },
            child: Column(children: [activePage3]))
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
