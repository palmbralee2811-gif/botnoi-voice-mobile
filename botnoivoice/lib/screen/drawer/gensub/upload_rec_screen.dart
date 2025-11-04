import 'package:botnoivoice/screen/drawer/gensub/upload_rec_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:botnoivoice/screen/drawer/gensub/upload/upload_screen.dart';
import 'package:botnoivoice/screen/drawer/gensub/record/record_screen.dart';
import 'package:easy_localization/easy_localization.dart';

class UploadRecScreen extends ConsumerStatefulWidget {
  const UploadRecScreen({super.key});

  @override
  ConsumerState<UploadRecScreen> createState() => _UploadRecScreenState();
}

class _UploadRecScreenState extends ConsumerState<UploadRecScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
          controller.selectedIndex == 0 ? "text_to_gensub.upload".tr() : "text_to_gensub.record".tr(),
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
                    ref.read(uploadRecordProvider.notifier).deleteProject(context, project);
                  },
                ),
                RecordScreen(
                  projects: controller.projects,
                  onProjectCreated: (project) {
                    ref.read(uploadRecordProvider.notifier).addProject(project);
                  },
                  onProjectDeleted: (project) {
                    ref.read(uploadRecordProvider.notifier).deleteProject(context, project);
                  },
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
        items:  [
          BottomNavigationBarItem(
            icon: const Icon(Icons.file_upload),
            label: "text_to_gensub.upload".tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.mic),
            label: "text_to_gensub.record".tr(),
          ),
        ],
      ),
    );
  }
}
