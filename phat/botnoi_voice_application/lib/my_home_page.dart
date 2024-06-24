import 'package:botnoi_voice_application/custom_app_bar.dart';
import 'package:botnoi_voice_application/data/dummy_forms.dart';
import 'package:botnoi_voice_application/widgets/custom_add_new_button.dart';
import 'package:botnoi_voice_application/widgets/custom_card.dart';
import 'package:botnoi_voice_application/widgets/custom_nav_bar.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> body = const[
    Icon(Icons.home),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color.fromARGB(255, 242, 219, 241),
    //App Bar
      appBar: PreferredSize(preferredSize: 
      const Size.fromHeight(50),
      child: Container(
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
        child: const CustomAppBar(backgroundColor: Color.fromARGB(255, 242, 219, 241),),
      )),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: dummyForms.length,
              itemBuilder: (BuildContext context, int index) {
                return CustomCard(
                  id: dummyForms[index].id,
                  name: dummyForms[index].name,
                  country: dummyForms[index].country,
                  sentences: dummyForms[index].sentences,
                );
              }
            ),
          ),
          const CustomAddNewButton(),
          const SizedBox(height: 15,),
          const CustomNavBar(),
        
        ],
      ),
      
      drawer: Drawer(
        width: 180,
        child: Container(
        ) ,
      ),
    ) ;
  }
}
