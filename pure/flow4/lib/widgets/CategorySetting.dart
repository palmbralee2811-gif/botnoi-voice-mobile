import 'package:flutter/material.dart';

class CategorySetting extends StatefulWidget {
  const CategorySetting({Key? key}) : super(key: key);

  @override
  _CategorySettingState createState() => _CategorySettingState();
}

class _CategorySettingState extends State<CategorySetting> {
  
  @override
  Widget build(BuildContext context) {
    double currentSliderValue = 20.00;
    return InkWell(
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: Colors.white,
                height: 245,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25, top: 10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'ความดัง',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Slider(
                                value: currentSliderValue,
                                max: 100,
                                divisions: 50,
                                label: currentSliderValue.round().toString(),
                                onChanged: (double value){
                                  setState(() {
                                    currentSliderValue = value;
                                  });
                                }),
                              const Text(
                                '0 db',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'ความเร็ว',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                              Slider(
                                value: currentSliderValue,
                                max: 100,
                                divisions: 50,
                                label: currentSliderValue.round().toString(),
                                onChanged: (double value){
                                  setState(() {
                                    currentSliderValue = value;
                                  });
                                }),
                              const Text(
                                '0.25x',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
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
