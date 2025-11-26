import 'package:botnoivoice/screen/drawer/gensub/uploadwithrecord/upload_rec_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:botnoivoice/screen/drawer/gensub/upload/upload_screen.dart';
import 'package:botnoivoice/screen/drawer/gensub/record/record_screen.dart';
import 'package:botnoivoice/screen/drawer/gensub/topbar_gensub.dart'; 
import 'package:easy_localization/easy_localization.dart';
import 'package:botnoivoice/screen/drawer/drawer_appbar.dart';

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
      ref.read(uploadRecordProvider.notifier).loadProjects(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(uploadRecordProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const TopbarGensub(),
      drawer: const DrawerAppbar(), 
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
                    ref.read(uploadRecordProvider.notifier).deleteProject(ref, project);
                  },
                ),
                RecordScreen(
                  projects: controller.projects,
                  onProjectCreated: (project) {
                    ref.read(uploadRecordProvider.notifier).addProject(project);
                  },
                  onProjectDeleted: (project) {
                    ref.read(uploadRecordProvider.notifier).deleteProject(ref, project);
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
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.file_upload),
            label: "upload_gensub.upload".tr(),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.mic),
            label: "record_gensub.record".tr(),
          ),
        ],
      ),
    );
  }
}
