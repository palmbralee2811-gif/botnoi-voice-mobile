import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:botnoivoice/Screens/HomeScreen/voiceScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late Size mediaSize;
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            width: screenWidth,
            height: screenHeight,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Color(0xFFB1E9FD),
                  Color(0xFFF9D8FD),
                ])),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Rectangle10094.png',
              width: screenWidth,
              fit: BoxFit.cover,
            ),
          ),
          _buildForm(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 50.0,
        ),
        _buildTop(context),
        const SizedBox(height: 50.0),
        _buildCenter(),
        const SizedBox(height: 10.0),
        _buildLoginLineButton(mediaSize),
        const SizedBox(height: 10.0),
        _buildLoginGoogleButton(mediaSize),
        const SizedBox(height: 30.0),
        _buildAccept(),
      ],
    );
  }

  Widget _buildTop(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    return Positioned(
      top: 40,
      left: 40,
      child: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: mediaSize.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                    child: GradientText(
                      'ยินดีต้อนรับ',
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9340FF),
                          Color(0xFF34BDFA),
                        ],
                      ),
                      style: GoogleFonts.prompt(
                        fontSize: 14,
                        decoration: TextDecoration.none,
                      ),
                    )),
                Padding(
                    padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                    child: GradientText(
                      'BOTNOI Voice',
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF9340FF),
                          Color(0xFF34BDFA),
                        ],
                      ),
                      style: GoogleFonts.prompt(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        decoration: TextDecoration.none,
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, bottom: 0.5),
                  child: Text(
                    'เปลี่ยนข้อความเป็นเสียงในทันที!\nไม่ว่าคุณจะต้องการพากษ์บทความ ฟังหนังสือ\nหรือสร้างเสียงบรรยายสำหรับวิดีโอ',
                    style: GoogleFonts.prompt(
                      fontSize: 14,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCenter() {
    return Center(
      child: Container(
        width: 200,
        height: 200,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/image559.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginLineButton(Size mediaSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF3ACE01),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.zero,
                minimumSize: Size(mediaSize.width * 0.2, 50.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/line.png',
                    height: 60.0,
                    width: 60.0,
                  ),
                  SizedBox(width: 8.0),
                  Text(
                    'เข้าสู่ระบบด้วย Line',
                    style: GoogleFonts.prompt(
                      fontSize: 16,
                      color: Colors.white,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginGoogleButton(Size mediaSize) {
    final auth = Provider.of<Authentication>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async {
                final user = await auth.signInWithGoogle(context);
                if (user != null) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VoiceScreen(speakerId: '',),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to sign in. Please try again.')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.zero,
                minimumSize: Size(mediaSize.width * 60.0, 60.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/google.png',
                    height: 40.0,
                    width: 40.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'เข้าสู่ระบบด้วย Google',
                    style: GoogleFonts.prompt(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccept() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Checkbox(
                value: _isChecked,
                onChanged: (value) {
                  setState(() {
                    _isChecked = value!;
                  });
                },
              ),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'I agree that I have read and accepted the ',
                    style: GoogleFonts.prompt(
                        fontSize: 14, color: Color(0xFF605E5C)),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Terms of USE',
                        style: GoogleFonts.prompt(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Terms of USE tapped");
                          },
                      ),
                      TextSpan(
                        text: ' and ',
                        style: GoogleFonts.prompt(
                            fontSize: 14, color: Color(0xFF605E5C)),
                      ),
                      TextSpan(
                        text: 'Private Policy',
                        style: GoogleFonts.prompt(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            print("Private Policy tapped");
                          },
                      ),
                      TextSpan(
                        text: '.',
                        style: GoogleFonts.prompt(
                            fontSize: 14, color: Color(0xFF605E5C)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    required this.gradient,
    required this.style,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style,
      ),
    );
  }
}
