import 'package:botnoi_voice_mobile/Screens/EditWorkspaceScreen/text_box_input.dart';
import 'package:botnoi_voice_mobile/Screens/SharedWidgets/workspace_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditWorkspaceScreen extends StatefulWidget {
  final String text;

  const EditWorkspaceScreen({super.key, required this.text});

  @override
  State<EditWorkspaceScreen> createState() => _EditWorkspaceScreen();
}

class _EditWorkspaceScreen extends State<EditWorkspaceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          padding: EdgeInsets.only(left: 15.w),
          icon: Icon(
            Icons.menu_rounded,
            size: 32.sp,
            color: const Color(0xFF323130),
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        ),
        backgroundColor: Colors.white,
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
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextBoxInput(
                          initialText: widget.text,
                          onTextChanged: (newText) {
                            Navigator.of(context).pop(newText);
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
