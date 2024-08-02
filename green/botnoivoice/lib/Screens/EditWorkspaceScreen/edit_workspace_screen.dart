import 'package:botnoivoice/Widgets/WorkspaceWidget/workspace_appbar_widget.dart';
import 'package:botnoivoice/Widgets/WorkspaceWidget/workspace_input_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditWorkspaceScreen extends StatefulWidget {
  final String sentences;
  
  const EditWorkspaceScreen({
    super.key,
    required this.sentences
    });

  @override
  State<EditWorkspaceScreen> createState() {return _EditWorkspaceScreen();}
}

class _EditWorkspaceScreen extends State <EditWorkspaceScreen>{
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
        title: WorkspaceAppBarWidget(context),
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
                        WorkspaceInputTextWidget(
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