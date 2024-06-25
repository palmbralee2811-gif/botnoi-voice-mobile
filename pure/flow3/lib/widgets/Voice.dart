import 'package:flutter/material.dart';

class SelectVoice extends StatefulWidget {
  const SelectVoice({Key? key}) : super(key: key);

  @override
  _SelectVoiceState createState() => _SelectVoiceState();
}

void _selsectedPage(int index) {
    return ;
}


class _SelectVoiceState extends State<SelectVoice> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
     
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
                      "เลือกเสียง",
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
      ),
    );
  }
}

