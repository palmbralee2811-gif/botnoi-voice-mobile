import 'package:botnoi_voice_application/backend.dart';
import 'package:botnoi_voice_application/models/models.dart';
import 'package:botnoi_voice_application/widgets/custom_app_bar.dart';
import 'package:botnoi_voice_application/widgets/custom_add_new_button.dart';
import 'package:botnoi_voice_application/widgets/custom_nav_bar.dart';
import 'package:botnoi_voice_application/widgets/home_page/custom_card.dart';
import 'package:flutter/material.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Backend backend = Backend();
  List<ListProject> listProjects = [];

  @override
  void initState()  {
   
    super.initState(); 
    fetchDataFromBackend();
  }

  Future<void> fetchDataFromBackend() async {
    // Call getInfo() to fetch data from Backend
    await backend.getAllWorkspace();  
    // Update listProjects with fetched data
    listProjects = backend.listProjects;

    if (listProjects.isNotEmpty) {
      // Get the first listProject
      final firstProject = listProjects[0];

      // Extract speakerIds from all workspaces within the first listProject
      List<int> speakerIds = firstProject.workSpaces.map((workspace) => workspace.speaker).toList();
      print(speakerIds);
       
      // Fetch image URLs for all speakerIds
      List<Map<String, String>> fetchedSpeakerDetails = await backend.fetchImageUrl(speakerIds);

      // Update imageUrlList with fetched data
      if (fetchedSpeakerDetails.length == firstProject.workSpaces.length) {
        for (int i = 0; i < firstProject.workSpaces.length; i++) {
          listProjects[0].workSpaces[i].faceImageUrl = fetchedSpeakerDetails[i]['face_image']!;
          listProjects[0].workSpaces[i].engName = fetchedSpeakerDetails[i]['eng_name']!;
          print(listProjects[0].workSpaces[i].engName);
        }
      } 
      else {
        print('The number of fetched image URLs does not match the number of workspaces.');
      }
     setState(() {
       
     });
    }
  }

  void deleteCard(int projectIndex, int workspaceIndex) {
    setState(() {
        listProjects[projectIndex].workSpaces.removeAt(workspaceIndex);
        backend.updateWorkSpaces(listProjects[projectIndex].workspaceId,listProjects[projectIndex].workSpaces);
    });
  }
  void updateCardSentences(int projectIndex, int workspaceIndex, String updatedSentences) async{
    var speaker = listProjects[projectIndex].workSpaces[workspaceIndex].speaker;
    await updateUrlAudio(projectIndex, workspaceIndex,updatedSentences,speaker);
    setState(() {
      listProjects[projectIndex].workSpaces[workspaceIndex].text = updatedSentences;
      backend.updateWorkSpaces(listProjects[projectIndex].workspaceId, listProjects[projectIndex].workSpaces);
    });
  }
  Future<void> updateUrlAudio (int projectIndex,int workspaceIndex,String updatedSentences, int speaker) async{
    String? urlAudio = await backend.generateAudio(updatedSentences,speaker);
    // print(urlAudio);
    if (urlAudio != null) {
      setState(() {
        listProjects[projectIndex].workSpaces[workspaceIndex].url =urlAudio;
      });
    }
  }
  
  
  
  Future<void> _refreshData() async {
    // Fetch data from backend again
    await fetchDataFromBackend();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //background color of whole screen
      backgroundColor: const Color.fromARGB(255, 242, 219, 241),
      
      //App Bar
      appBar: const PreferredSize(preferredSize: 
      Size.fromHeight(50),
      child: CustomAppBar(backgroundColor: Color.fromARGB(241, 255, 255, 255),)
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
              ]
            )
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: listProjects.isNotEmpty ? listProjects[0].workSpaces.length + 1: 0,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == listProjects[0].workSpaces.length) {
                      return const CustomAddNewButton();  
                    }
                    else {
                      // print('Displaying WorkSpace ${index+1}');
                      return CustomCard(
                      sentences: listProjects[0].workSpaces[index].text,
                      audioUrl: listProjects[0].workSpaces[index].url,
                      speakerName: listProjects[0].workSpaces[index].engName,
                      imageUrlList : listProjects[0].workSpaces[index].faceImageUrl,
                      changedValue: (value){
                        updateCardSentences(0, index, value);
                      },
                      onDelete:(){
                        deleteCard(0, index);
                      },
                    );
                    }
                  }
                ),
                
              ),
              
              // Custom Add button 
              //const CustomAddNewButton(),
              
              // Custom nav bar
              const CustomNavBar(),
            
            ],
          ),
        ),
      ),
      
      drawer: Drawer(
        width: 180,
        child: Container(
        ) ,
      ),
    ) ;
  }
}
