import 'package:botnoivoice/screen/drawer/gensub/upload_rec_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:botnoivoice/screen/drawer/gensub/upload/upload_screen.dart';
import 'package:botnoivoice/screen/drawer/gensub/record/record_screen.dart';
// Note: ต้องมั่นใจว่า UploadRecordState ไม่มี apiToken แล้ว

class UploadRecScreen extends ConsumerStatefulWidget {
  const UploadRecScreen({super.key});

  @override
  ConsumerState<UploadRecScreen> createState() => _UploadRecScreenState();
}

class _UploadRecScreenState extends ConsumerState<UploadRecScreen> {
  @override
  void initState() {
    super.initState();
    // เรียกหลัง widget ถูก mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ✅ แก้ไข: ส่ง context เข้าไปใน loadProjects
      ref.read(uploadRecordProvider.notifier).loadProjects(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(uploadRecordProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          controller.selectedIndex == 0
              ? "อัปโหลดไฟล์"
              : controller.selectedIndex == 1
                  ? "อัดเสียง"
                  : "โปรไฟล์",
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: controller.loading
          ? const Center(child: CircularProgressIndicator())
          : IndexedStack(
              index: controller.selectedIndex,
              children: [
                UploadScreen(
                  projects: controller.projects,
                  onProjectCreated: (project) {
                    ref.read(uploadRecordProvider.notifier).addProject(project);
                  },
                  onProjectDeleted: (project) {
                    //  แก้ไข: ส่ง context เข้าไปใน deleteProject
                    ref.read(uploadRecordProvider.notifier).deleteProject(context, project);
                  },
                  //  ลบ apiToken ออกจาก Widget Call
                  // apiToken: controller.apiToken, 
                ),
                RecordScreen(
                  projects: controller.projects,
                  onProjectCreated: (project) {
                    ref.read(uploadRecordProvider.notifier).addProject(project);
                  },
                  onProjectDeleted: (project) {
                    //  แก้ไข: ส่ง context เข้าไปใน deleteProject
                    ref.read(uploadRecordProvider.notifier).deleteProject(context, project);
                  },
                ),
                const Center(
                  child: Text("หน้าโปรไฟล์ (ยังไม่ได้ทำ)"),
                ),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          ref.read(uploadRecordProvider.notifier).changeTab(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.file_upload),
            label: "อัปโหลดไฟล์",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mic),
            label: "อัดเสียง",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "โปรไฟล์",
          ),
        ],
      ),
    );
  }
}