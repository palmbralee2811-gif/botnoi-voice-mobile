import 'package:botnoivoice/Widgets/custom_app_bar.dart';
import 'package:botnoivoice/Widgets/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              padding: EdgeInsets.only(left: 15.w),
              icon: Icon(
                Icons.menu_rounded,
                size: 32.sp,
                color: const Color(0xFF323130),
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ),
        backgroundColor: const Color(0xFFFFFFFF),
        // backgroundColor: Colors.black,
        title: CustomAppBar(context),
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
        ],
      ),
    );     
  }
}