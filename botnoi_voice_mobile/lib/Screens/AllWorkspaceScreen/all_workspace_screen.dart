import 'package:botnoi_voice_mobile/Screens/DrawerAppBarScreen/drawer_appbar_screen.dart';
import 'package:botnoi_voice_mobile/Screens/SharedWidgets/workspace_appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AllWorkspaceScreen extends StatefulWidget {
  const AllWorkspaceScreen({super.key});

  @override
  AllWorkspaceScreenState createState() => AllWorkspaceScreenState();
}

class AllWorkspaceScreenState extends State<AllWorkspaceScreen> {
  //TODO: Query All Workspaces From API
  List<String> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            SizedBox(height: 10.h),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.w,
                  mainAxisSpacing: 10.h,
                ),
                itemCount: items.length + 1, 
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return GestureDetector(
                      onTap: () {
                        //TODO: Add new workspace
                        setState(() {
                          items.add('โปรเจค ${items.length + 1}');
                          debugPrint(items.toString());
                        });
                      },
                      child: Card(
                        elevation: 2,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add, 
                                size: 40.sp, 
                                color: Colors.grey
                              ),
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
                    return GestureDetector(
                      child: Card(
                        elevation: 2,
                        child: Stack(
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.folder,
                                    size: 40.sp,
                                    color: Colors.blue,
                                  ),
                                  SizedBox(height: 10.h),
                                  Text(
                                    items[index - 1],
                                    style: TextStyle(fontSize: 16.sp),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8.h,
                              right: 8.w,
                              child: PopupMenuButton<String>(
                                //TODO: Remove on select workspace
                                onSelected: (value) {
                                  if (value == 'delete') {
                                    setState(() {
                                      items.removeAt(index - 1);
                                    });
                                  }
                                },
                                itemBuilder: (BuildContext context) {
                                  return [
                                    const PopupMenuItem<String>(
                                      value: 'delete',
                                      child: Text('ลบโปรเจค'),
                                    ),
                                  ];
                                },
                                icon: Icon(
                                  Icons.more_vert,
                                  size: 20.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
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
