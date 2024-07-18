import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Suggestions extends StatefulWidget {
  const Suggestions({super.key});

  @override
  State<Suggestions> createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  int? _selectedEmoji;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'ข้อเสนอเเนะ',
          style: GoogleFonts.prompt(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
            print('Back');
          },
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              child: SizedBox(
                child: Text(
                  'ความรู้สึก',
                  style: GoogleFonts.prompt(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              child: Text(
                'คุณรู้สึกยังไงบ้างหลังจากได้ลองใช้งาน',
                style:
                    GoogleFonts.prompt(fontSize: 14, color: Color(0xFF605E5C)),
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.sentiment_satisfied_alt,
                      size: 64,
                      color: _selectedEmoji == 1 ? Colors.green : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedEmoji = 1;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.sentiment_neutral,
                      size: 64,
                      color: _selectedEmoji == 2 ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedEmoji = 2;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.sentiment_dissatisfied,
                      size: 64,
                      color: _selectedEmoji == 3 ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _selectedEmoji = 3;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide(
                      color: Color(0xFFD9D9D9),
                      width: 1.0,
                    ),
                  ),
                  labelText: 'แสดงความคิดเห็น',
                  labelStyle: GoogleFonts.prompt(
                    fontSize: 16,
                  ),
                  hintText: 'พิมพ์ข้อความ...',
                  hintStyle: GoogleFonts.prompt(
                    fontSize: 14,
                  ),
                ),
                maxLines: 3,
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: SizedBox(
                child: GradientButton(
                  text: 'ส่งข้อเสนอแนะ',
                  onPressed: () {
                    print('ส่งข้อเสนอแนะ');
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  GradientButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF9340FF), Color(0xFF34BDFA)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: onPressed,
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}
