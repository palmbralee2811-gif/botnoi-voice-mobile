import 'package:flutter/material.dart';

class InputTextSlide extends StatefulWidget {
  const InputTextSlide({Key? key,required this.message}) : super(key: key);
  final String message;

  @override
  _InputTextSlideState createState() => _InputTextSlideState();
}

class _InputTextSlideState extends State<InputTextSlide> {
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InputTextSlide'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Enter your message to InputText',
              ),
              onChanged: (text) {
                // Automatically navigate to InputText with the text
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputText(message: text),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class InputText extends StatefulWidget {
  final String message;

  const InputText({Key? key, required this.message}) : super(key: key);

  @override
  _InputTextState createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.message);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InputText'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'Enter your message to InputTextSlide',
              ),
              onChanged: (text) {
             
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InputTextSlide(message: text),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


