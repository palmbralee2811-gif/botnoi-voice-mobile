import 'package:botnoi_voice_application/widgets/custom_app_bar.dart';
import 'package:botnoi_voice_application/widgets/custom_nav_bar.dart';
import 'package:botnoi_voice_application/widgets/input_text.dart';
import 'package:flutter/material.dart';

class EditScreen extends StatefulWidget {
  final String sentences;
  
  const EditScreen({
    super.key,
    required this.sentences
    });

  @override
  State<EditScreen> createState(){
    return _EditScreen();
  }
}

class _EditScreen extends State <EditScreen>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar:const PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: CustomAppBar(
        backgroundColor: Color.fromARGB(241, 255, 255, 255),
        )
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 242, 219, 241),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFB1E9FD),
                    Color(0xFFF9D8FD),
                  ]
                )
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  child: SingleChildScrollView(
                    child: Column(
                       crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InputTextSlide(
                          initialSentences: widget.sentences,
                          onSentencesChanged: (newSentences) {
                            Navigator.of(context).pop(newSentences);
                          },
                        ),
                      ],   
                    ),
                  ),
                  ),
                ),
            ),
          ),
        const CustomNavBar(), ],
      ),
    );     
  }
}