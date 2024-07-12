import 'package:flutter/material.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Download File Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isDownloading = false;
  String _progress = '';

  Future<void> _downloadFile() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    var path = '/storage/emulated/0/Download/downloaded_audio$time.m4a';
    var file = File(path);
    await OpenFile.open(file.toString());
    var res = await get(Uri.parse(
        "https://botnoi-dictionary.s3.amazonaws.com/634342b38841939aad06ff18bcf0bc89888b0e54ae5eaa425935543a1a4b66ee_07112024043219840716.mp3"));
    file.writeAsBytes(res.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download File Example'),
      ),
      body: Center(
        child: _isDownloading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(_progress),
                ],
              )
            : ElevatedButton(
                onPressed: _downloadFile,
                child: Text('Download File'),
              ),
      ),
    );
  }
}
