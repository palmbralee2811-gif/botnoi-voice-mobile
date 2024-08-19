import 'package:botnoi_voice_mobile/MainServer/ObjectModels/workspace_model.dart';
import 'package:botnoi_voice_mobile/MainServer/main_server_provider.dart';
import 'package:botnoi_voice_mobile/Screens/DrawerAppBarScreen/drawer_appbar_screen.dart';
import 'package:botnoi_voice_mobile/Screens/SharedWidgets/workspace_appbar_widget.dart';
import 'package:botnoi_voice_mobile/Screens/WorkspaceScreen/text_box_card.dart';
import 'package:botnoi_voice_mobile/Screens/WorkspaceScreen/workspace_add_button_widget.dart';
import 'package:botnoi_voice_mobile/Screens/WorkspaceScreen/workspace_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key});
  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  List<WorkspaceModel> workSpaces = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 242, 219, 241),
      drawer: const DrawerAppbar(),
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
        backgroundColor: Colors.white,
        title: WorkspaceAppBarWidget(context),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: const WorkspaceNavbar(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchDataFromBackend,
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
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: workSpaces.isNotEmpty
                      ? workSpaces[0].textBoxes.length + 1
                      : 0,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == workSpaces[0].textBoxes.length) {
                      return const WorkspaceAddButtonWidget();
                    } else {
                      return TextBoxCard(
                        text: workSpaces[0].textBoxes[index].text,
                        audioUrl: workSpaces[0].textBoxes[index].url,
                        speakerName: workSpaces[0].textBoxes[index].engName,
                        imageUrlList:
                            workSpaces[0].textBoxes[index].faceImageUrl,
                        onTextChanged: (value) {
                          updateTextBox(0, index, value);
                        },
                        onDelete: () {
                          Provider.of<MainServerProvider>(context,
                                  listen: false)
                              .deleteTextBox(
                            workspaceIndex: 0,
                            textBoxIndex: index,
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
