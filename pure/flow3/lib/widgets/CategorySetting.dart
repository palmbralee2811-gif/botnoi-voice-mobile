import 'package:flutter/material.dart';

class CategorySetting extends StatefulWidget {
  const CategorySetting({Key? key}) : super(key: key);

  @override
  _CategorySettingState createState() => _CategorySettingState();
}

class _CategorySettingState extends State<CategorySetting> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          "เลือกเสียง",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Image.asset('assets/logo/caret-up-bold 2.png'),
                      ),
                    ],
                  )),
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
                        child: Image.asset('assets/logo/caret-up-bold 2.png'),
                      ),
                    ],
                  )),
              Container(
                color: Colors.white,
                height: 190,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20, right: 20, top: 10),
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
            ],
          ),
        ],
      ),
    );
  }
}
