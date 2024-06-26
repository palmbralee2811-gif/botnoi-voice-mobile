import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late Color myColor;
  late Size mediaSize;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscureText = true;
  bool rememberUser = false;
  bool _isKeyboardVisible = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isKeyboardVisible = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaSize = MediaQuery.of(context).size;
    myColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFB1E9FD),
                Color(0xFFF9D8FD),
              ],
            ),
          ),
          child: CustomScrollView(
            slivers: [
              if (!_isKeyboardVisible)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverAppBarDelegate(
                    child: Container(
                      color: Colors.transparent,
                      child: AppBar(
                        leading: IconButton(
                          icon: const Icon(Icons.arrow_back_ios,
                              color: Colors.white),
                          onPressed: () {
                            print('Back button pressed');
                          },
                        ),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                      ),
                    ),
                  ),
                ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    _buildTop(),
                  ],
                ),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: _buildBottom(mediaSize),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTop() {
    return SafeArea(
      child: SingleChildScrollView(
        child: SizedBox(
          width: mediaSize.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 40.0, bottom: 5.0),
                child: Image.asset(
                  'assets/images/logo_botnoi.png',
                  height: 100,
                  width: 100,
                  color: Colors.white,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 40.0, bottom: 5.0),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 2,
                    decoration: TextDecoration.none,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 40.0, bottom: 10.0),
                child: Text(
                  "Botnoi Voice",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: 2,
                    decoration: TextDecoration.none,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottom(Size mediaSiz) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(child: SizedBox(height: mediaSize.height * 0.03)),
        _buildInputField(emailController),
        Flexible(
            child:
                SizedBox(height: mediaSize.height * 0.02)), // email - password
        _buildInputField(passwordController, isPassword: true),
        Flexible(
            child: SizedBox(
                height: mediaSize.height * 0.01)), // password - remember
        _buildRememberForgot(),
        Flexible(
            child: SizedBox(
                height: mediaSize.height * 0.03)), // remember me - login
        _buildLoginButton(),
        Flexible(
            child: SizedBox(height: mediaSize.height * 0.04)), // login - or
        _buildOtherLogin(),
        Flexible(
            child: SizedBox(height: mediaSize.height * 0.04)), // or - create
        _buildCreateAccount(),
      ],
    );
  }

  Widget _buildGreyText(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey, fontSize: 16.0),
    );
  }

  Widget _buildInputField(TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Color(0xFFEFEFEF),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFEFEFEF).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: isPassword ? 'Password' : 'Email',
          hintStyle: TextStyle(color: Color(0xFFBBBFC4)),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
        ),
        obscureText: isPassword ? _obscureText : false,
      ),
    );
  }

  Widget _buildRememberForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
                value: rememberUser,
                onChanged: (value) {
                  setState(() {
                    rememberUser = value!;
                  });
                }),
            _buildGreyText("Remember me"),
          ],
        ),
        TextButton(
          onPressed: () {},
          child: const Text("Forgot password ?",
              style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {
        debugPrint("Email : ${emailController.text}");
        debugPrint("Password : ${passwordController.text}");
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.grey.withOpacity(0.5),
        elevation: 7,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.zero,
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.purple, Colors.blue],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 60,
          alignment: Alignment.center,
          child: const Text(
            "LOGIN",
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildOtherLogin() {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'or try another',
                style: TextStyle(color: Colors.grey, fontSize: 16.0),
                maxLines: 1,
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.grey,
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                print("Line login ");
              },
              child: SizedBox(
                width: 50,
                height: 50,
                child: Image.asset("assets/images/logo_line.png"),
              ),
            ),
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                print("Google login ");
              },
              child: SizedBox(
                width: 50,
                height: 50,
                child: Image.asset("assets/images/logo_google.png"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildCreateAccount() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      const Flexible(
        child: Text(
          "Don't have an account? ",
          style: TextStyle(color: Colors.grey),
        ),
      ),
      GestureDetector(
        onTap: () {
          debugPrint("Navigate to Create Account");
        },
        child: const Text(
          "Create an account",
          style: TextStyle(color: Colors.blue),
          maxLines: 1,
        ),
      ),
    ],
  );
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _SliverAppBarDelegate({required this.child});

  @override
  double get minExtent => kToolbarHeight;

  @override
  double get maxExtent => kToolbarHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
