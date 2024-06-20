import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Scaffold(      
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00E0FF), Color(0xFF9A96F5)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: 380,
                    height: 230,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  Container( 
                    margin: const EdgeInsets.only(top: 400),
                    width: 380,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: GestureDetector(
                      onTap: () {  
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFB1E9FD), Color(0xFFF9D8FD)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),),
                        child: const Center(
                          child: Text(
                            "สร้างเสียง",
                            style: TextStyle(color: Colors.white, fontSize: 27,fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
