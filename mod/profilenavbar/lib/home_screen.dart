import 'package:flutter/material.dart';
import 'package:profilenavbar/navbar/About_us.dart';
import 'package:profilenavbar/navbar/FAQ.dart';
import 'package:profilenavbar/navbar/Suggestions.dart';
import 'package:profilenavbar/navbar/myAccount.dart';
import 'package:profilenavbar/splash_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MyAccount()));
                  print("My Account");
                },
                child: Text("ข้อมูลส่วนตัว"),
              ),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => FAQ()));
                  print("FAQ");
                },
                child: Text("FAQ"),
              ),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => About_us()));
                  print("About Us");
                },
                child: Text("เกี่ยวกับเรา"),
              ),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Suggestions()));
                  print("About Us");
                },
                child: Text("ข้อเสนอเเนะ"),
              ),
            ),
          ),
          SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SplashScreen()));
                  print("About Us");
                },
                child: Text("splash screen"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
