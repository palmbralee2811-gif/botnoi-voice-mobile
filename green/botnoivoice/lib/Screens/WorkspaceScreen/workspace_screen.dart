import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Model/models.dart';
import 'package:botnoivoice/Screens/DrawerAppBarScreen/drawer_appbar_screen.dart';
import 'package:botnoivoice/Widgets/WorkspaceWidget/workspace_appbar_widget.dart';
import 'package:botnoivoice/Widgets/WorkspaceWidget/workspace_add_button_widget.dart';
import 'package:botnoivoice/Widgets/WorkspaceWidget/workspace_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class WorkspaceScreen extends StatefulWidget {
  const WorkspaceScreen({super.key});
  @override
  State<WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<WorkspaceScreen> {
  // Backend backend = Backend();
  List<ListProject> listProjects = [];
  @override
  void initState() {
    super.initState();
    fetchDataFromBackend();
  }

  Future<void> fetchDataFromBackend() async {
    final auth = Provider.of<Authentication>(context, listen: false);

    // Call getInfo() to fetch data from Backend
    await auth.getAllWorkspace();
    // Update listProjects with fetched data
    listProjects = auth.listProjects;

    if (listProjects.isNotEmpty) {
      // Get the first listProject
      final firstProject = listProjects[0];

      // Extract speakerIds from all workspaces within the first listProject
      List<int> speakerIds = firstProject.workSpaces
          .map((workspace) => workspace.speaker)
          .toList();
      print(speakerIds);

      // Fetch image URLs for all speakerIds
      List<Map<String, String>> fetchedSpeakerDetails =
          await auth.fetchImageUrl(speakerIds);

      // Update imageUrlList with fetched data
      if (fetchedSpeakerDetails.length == firstProject.workSpaces.length) {
        for (int i = 0; i < firstProject.workSpaces.length; i++) {
          listProjects[0].workSpaces[i].faceImageUrl =
              fetchedSpeakerDetails[i]['face_image']!;
          listProjects[0].workSpaces[i].engName =
              fetchedSpeakerDetails[i]['eng_name']!;
          print(listProjects[0].workSpaces[i].engName);
        }
      } else {
        print(
            'The number of fetched image URLs does not match the number of workspaces.');
      }
      setState(() {});
    }
  }

  void deleteCard(int projectIndex, int workspaceIndex) {
    final auth = Provider.of<Authentication>(context, listen: false);
    setState(() {
      listProjects[projectIndex].workSpaces.removeAt(workspaceIndex);
      auth.updateWorkSpaces(listProjects[projectIndex].workspaceId,
          listProjects[projectIndex].workSpaces);
    });
  }

  void updateCardSentences(
      int projectIndex, int workspaceIndex, String updatedSentences) async {
    final auth = Provider.of<Authentication>(context, listen: false);
    var speaker = listProjects[projectIndex].workSpaces[workspaceIndex].speaker;

    await updateUrlAudio(
        projectIndex, workspaceIndex, updatedSentences, speaker);
    setState(() {
      listProjects[projectIndex].workSpaces[workspaceIndex].text =
          updatedSentences;
      // รับตัว speaker listProjects[projectIndex].workSpaces[workspaceIndex].speaker
      // ดูได้ที่ตัว models
      auth.updateWorkSpaces(listProjects[projectIndex].workspaceId,
          listProjects[projectIndex].workSpaces);
    });
  }

  Future<void> updateUrlAudio(int projectIndex, int workspaceIndex,
      String updatedSentences, int speaker) async {
    final auth = Provider.of<Authentication>(context, listen: false);
    String? urlAudio = await auth.generateAudio(updatedSentences, speaker);
    print('URL audio $urlAudio');
    if (urlAudio != null) {
      setState(() {
        listProjects[projectIndex].workSpaces[workspaceIndex].url = urlAudio;
      });
    }
  }

  Future<void> _refreshData() async {
    // Fetch data from backend again
    await fetchDataFromBackend();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context, listen: false);

    // แสดง email ผู้ใช้งาน ปัจจุบัน
    firebase_auth.User? user = firebase_auth.FirebaseAuth.instance.currentUser;
    String? email = auth.getUserEmail(user);
    return Scaffold(
      //background color of whole screen
      backgroundColor: const Color.fromARGB(255, 242, 219, 241),

      //App Bar
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

      // List of card (Body)
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Container(
          decoration: const BoxDecoration(
              color: Color.fromARGB(255, 242, 219, 241),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFB1E9FD),
                    Color(0xFFF9D8FD),
                  ])),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    itemCount: listProjects.isNotEmpty
                        ? listProjects[0].workSpaces.length + 1
                        : 0,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == listProjects[0].workSpaces.length) {
                        return const WorkspaceAddButtonWidget();
                      } else {
                        return WorkspaceCardWidget(
                          sentences: listProjects[0].workSpaces[index].text,
                          audioUrl: listProjects[0].workSpaces[index].url,
                          speakerName:
                              listProjects[0].workSpaces[index].engName,
                          imageUrlList:
                              listProjects[0].workSpaces[index].faceImageUrl,
                          changedValue: (value) {
                            updateCardSentences(0, index, value);
                          },
                          onDelete: () {
                            deleteCard(0, index);
                          },
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),

      drawer: DrawerAppbarScreen(
        auth: auth,
        email: email,
        screenSizeheight: MediaQuery.of(context).size.height,
      ),
    );
  }
}
