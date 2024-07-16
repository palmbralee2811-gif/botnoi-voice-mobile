import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget //implements PreferredSize{
  {
  final Color backgroundColor;
  
  const CustomAppBar({
    super.key,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  spreadRadius: 6,
                  blurRadius: 6,
                  offset: const Offset(0, -4),
                ),
              ],
      ),
      child: AppBar(
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Image.asset(
          'assets/images/logo_botnoi.png',
          height: 35.0,
        ),
        actions: [
          Container(
            width: 70,
            height: 35,
            decoration:  BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
              ),
            ],
              ),
              child: 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 1,),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                    Image.asset(
                      'assets/images/star_point.png',
                    ),
                  ]
                  ,
                  ),
                  const Text("100",style: TextStyle(fontSize: 15,fontFamily: 'Prompt'),),
                  const SizedBox(width: 4),

                ],),
          ),
          const SizedBox(width: 17),
        ],
      ),
    );

  }
}
