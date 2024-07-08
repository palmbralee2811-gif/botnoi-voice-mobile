import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

void _selsectedPage(int index) {
  return;
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Column(
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
                  child: Image.asset('assets/logo/caret-down-bold (1) 1.png'),
                ),
              ],
            )),
      ],
    );
  }
}
