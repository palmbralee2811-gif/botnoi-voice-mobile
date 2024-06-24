import 'package:flow3/screen/data.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const InputText(),
            const SelectVoice(),
            const Void(),
            const Setting(),
            const SizedBox(
              height: 10,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 3),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 70,
                        width: 370,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            gradient: const LinearGradient(
                              colors: [Color(0xFF00E0FF), Color(0xFF9A96F5)],
                            )),
                        child: const Center(
                          child: Text(
                            "สร้างเสียง",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 27,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Appbar(),
      ),
    );
  }
}

class Setting extends StatelessWidget {
  const Setting({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ตั้งค่าสเพิ่มเติม',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: const Icon(
                    Icons.menu,
                    weight: 50,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class Void extends StatelessWidget {
  const Void({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final data = AppDataBase.data;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                mainAxisExtent: 85,
              ),
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            '${data[index].image}',
                            width: 80,
                            height: 80,
                            scale: 30,
                          ),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Text(
                          //       '${data[index].name}',
                          //       style: const TextStyle(
                          //           fontSize: 20,
                          //           fontWeight: FontWeight.bold,
                          //           color: Colors.black),
                          //     ),
                          //     Text(
                          //       '${data[index].image}',
                          //       style: const TextStyle(
                          //           ),
                          //     ),
                          //   ],
                          // )
                        ],
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class SelectVoice extends StatelessWidget {
  const SelectVoice({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'เลือกเสียง',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Container(
                  height: 50,
                  width: 50,
                  child: const Icon(
                    Icons.menu,
                    weight: 50,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class InputText extends StatelessWidget {
  const InputText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xFF00E0FF), Color(0xFF9A96F5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 20),
              child: Center(
                  child: Container(
                width: 380,
                height: 230,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                  child: TextField(
                    minLines: 5,
                    maxLines: 9,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'กรุณากรอกข้อความที่ต้องการจะสร้าง...',
                      hintStyle:
                          TextStyle(color: Colors.grey[600], fontSize: 19),
                      hintMaxLines: 6,
                      helperText: 'ลบ',
                      helperStyle:
                          TextStyle(color: Colors.grey[600], fontSize: 20),
                      counterText: '0/100',
                    ),
                  ),
                ),
              )),
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
          Padding(
            padding: const EdgeInsets.only(left: 0, right: 10, top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: const Icon(
                    Icons.menu,
                    weight: 50,
                    color: Color(0xFF000000),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/logo/Frame.png',
                    width: 60,
                    height: 60,
                  ),
                ),
                Column(
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 214, 210, 210),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Image.asset(
                            'assets/logo/point.png',
                            width: 10,
                            height: 10,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
