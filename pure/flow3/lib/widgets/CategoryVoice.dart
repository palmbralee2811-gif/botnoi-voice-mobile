import 'package:flow3/screen/data.dart';
import 'package:flutter/material.dart';

class CategoryVoice extends StatefulWidget {
  const CategoryVoice({Key? key}) : super(key: key);

  @override
  _CategoryVoiceState createState() => _CategoryVoiceState();
}

class _CategoryVoiceState extends State<CategoryVoice> {
  @override
  Widget build(BuildContext context) {
    final data = AppDataBase.data;

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
                          color: Color.fromARGB(255, 202, 17, 17),
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
                color: Colors.white,
                height: 245,
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
                    SizedBox(
                      height: 170,
                      width: 370,
                      child: GridView.builder(
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          mainAxisExtent: 110,
                        ),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 160,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 22, 19, 19).withOpacity(0.0),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 14,
                                          left: 14,
                                          top: 10,
                                          bottom: 10),
                                      child: Container(
                                        color: Colors.transparent,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              child: Image.asset(
                                                '${data[index].image}',
                                                width: 80,
                                                height: 80,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Text(
                                              '${data[index].name}',
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold),
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
            ],
          ),
        ],
      ),
    );
  }
}
