import 'package:botnoivoice/Screens/DrawerAppBarScreen/drawer_appbar_screen.dart';
import 'package:botnoivoice/Widgets/WorkspaceWidget/workspace_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllWorkspaceScreen extends StatefulWidget {
  const AllWorkspaceScreen({super.key});

  @override
  _AllWorkspaceScreenState createState() => _AllWorkspaceScreenState();
}

class _AllWorkspaceScreenState extends State<AllWorkspaceScreen> {
  List<String> items = []; // รายการสำหรับเก็บข้อมูลของไอเทมที่เพิ่มเข้ามา

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: const DrawerAppbarScreen(),
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
        title: WorkspaceAppBarWidget(context),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "โปรเจคของฉัน",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10.h), // เพิ่มระยะห่างระหว่างข้อความและ GridView
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // จำนวนคอลัมน์ของกริด
                  crossAxisSpacing: 10.w, // ระยะห่างระหว่างคอลัมน์
                  mainAxisSpacing: 10.h, // ระยะห่างระหว่างแถว
                ),
                itemCount: items.length +
                    1, // จำนวนไอเทมที่ต้องการแสดงในกริด เพิ่ม +1 สำหรับปุ่มเพิ่มโปรเจค
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // ปุ่มแรก ให้เป็น ปุ่ม เพิ่มไอเทม
                    return GestureDetector(
                      onTap: () {
                        // เมื่อคลิกให้เพิ่มไอเทมใหม่
                        setState(() {
                          items.add(
                              'โปรเจค ${items.length + 1}'); // เพิ่มไอเทมใหม่ในรายการ
                          debugPrint(items.toString());
                        });
                      },
                      child: Card(
                        elevation: 2,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, size: 40.sp, color: Colors.grey),
                              SizedBox(height: 10.h),
                              Text(
                                'สร้างโปรเจคใหม่',
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    // ส่วนนี้แสดงโปรเจคที่ถูกสร้างขึ้นมา
                    return GestureDetector(
                      onLongPress: () {
                        setState(() {
                          items.removeAt(
                              index - 1); // ลบไอเทมออกจากรายการตาม index
                          debugPrint(items.toString());
                        });
                      },
                      child: Card(
                        elevation: 2,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.folder,
                                  size: 40.sp, color: Colors.blue),
                              SizedBox(height: 10.h),
                              Text(
                                items[index -
                                    1], // index - 1 เพื่อไม่ให้ชนกับปุ่มเพิ่มโปรเจค
                                style: TextStyle(fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
