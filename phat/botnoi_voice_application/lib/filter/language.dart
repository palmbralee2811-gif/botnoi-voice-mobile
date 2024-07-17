import 'package:flutter/material.dart';

class Language extends StatelessWidget {
  const Language({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          backgroundColor: Colors.white,
          context: context,
          builder: (BuildContext context) => Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      width: 360,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'ภาษา',
                            style: TextStyle(fontSize: 20, color: Colors.black),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child:
                                Image.asset('assets/images/Frame 1028950648.png'),
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
      },
      child: Container(
        width: 85,
        height: 35,
        decoration: const BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(
            image: AssetImage('assets/images/fff.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
