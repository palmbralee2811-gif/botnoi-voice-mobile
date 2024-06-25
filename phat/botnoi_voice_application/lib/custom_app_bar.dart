import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget //implements PreferredSize{
  {
  final Color backgroundColor;
  
  const CustomAppBar({
    super.key,
    required this.backgroundColor,
    });

  @override
  //Size get preferredSize => const Size.fromHeight(40.0);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      centerTitle: true,
      title: const Icon(
      Icons.favorite,
      color: Colors.pink,
      size: 35.0,
      semanticLabel: 'Text to announce in accessibility modes',
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
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 1,),
                Stack(
                  alignment: Alignment.center,
                  children: [
                  Icon(Icons.notifications),
                ]
                ,
                ),
                Text("100",style: TextStyle(fontSize: 15),),
                SizedBox(width: 4),
        
              ],),
        ),
        const SizedBox(width: 35),
      ],
    );

  }
  
  // @override
  // Widget get child => throw UnimplementedError();


}
