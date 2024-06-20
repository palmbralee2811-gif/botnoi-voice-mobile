import 'package:flow3/screen/home.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  @override
  Widget build(BuildContext context) {
    Widget activePage = const Home();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.menu, color: Colors.black),
                  tooltip: 'Menu Icon',
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.comment, color: Colors.black),
                  tooltip: 'Comment Icon',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        leading: Container(
          margin: const EdgeInsets.all(10),
          child: Image(image: AssetImage('assets/images/point(1).png'),),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(10),
          )
        ),
        ),
        body: activePage,
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'สตูดิโอ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: 'แก้ไขคำอ่าน',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.science),
              label: 'ตั้งค่า',
            ),
          ],
        ));
  }
}
