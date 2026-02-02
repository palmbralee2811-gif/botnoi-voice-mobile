import 'package:botnoivoice/screen/drawer/gensub/uploadwithrecord/upload_rec_logic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:botnoivoice/screen/drawer/gensub/upload/upload_screen.dart';
import 'package:botnoivoice/screen/drawer/gensub/record/record_screen.dart';
import 'package:botnoivoice/screen/drawer/gensub/topbar_gensub.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:botnoivoice/screen/drawer/drawer_appbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: const TopbarGensub(),
      drawer: const DrawerAppbar(),
      body: controller.loading
          ? const Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.blue,
              ),
            )
          : IndexedStack(
              index: controller.selectedIndex,
              children: [
                UploadScreen(
                  projects: controller.projects,
                  onProjectCreated: (project) {
                    ref.read(uploadRecordProvider.notifier).addProject(project);
                  },
                  onProjectDeleted: (project) {
                    ref
                        .read(uploadRecordProvider.notifier)
                        .deleteProject(ref, project);
                  },
                ),
                RecordScreen(
                  projects: controller.projects,
                  onProjectCreated: (project) {
                    ref.read(uploadRecordProvider.notifier).addProject(project);
                  },
                  onProjectDeleted: (project) {
                    ref
                        .read(uploadRecordProvider.notifier)
                        .deleteProject(ref, project);
                  },
                ),
              ],
            ),
      
      // --- Modern Bottom Navigation Bar ---
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // เงาบางๆ ด้านบน
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: controller.selectedIndex,
          onTap: (index) {
            ref.read(uploadRecordProvider.notifier).changeTab(index);
          },
          backgroundColor: Colors.white,
          elevation: 0, // ปิดเงาเดิม
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12.sp,
          ),
          unselectedLabelStyle: TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12.sp,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Icon(Icons.cloud_upload_outlined, size: 24.r),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Icon(Icons.cloud_upload_rounded, size: 24.r),
              ),
              label: "upload_gensub.upload".tr(),
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Icon(Icons.mic_none_rounded, size: 24.r),
              ),
              activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 4.h),
                child: Icon(Icons.mic_rounded, size: 24.r),
              ),
              label: "record_gensub.record".tr(),
            ),
          ],
        ),
      ),
    );
  }
}