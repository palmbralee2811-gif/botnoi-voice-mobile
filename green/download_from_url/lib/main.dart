import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
    setState(() {
      _isDownloading = true;
    });

    try {
      Dio dio = Dio();
      String url = 'https://botnoi-dictionary.s3.amazonaws.com/44f0ebcc8623fab277604a1bd22f9246ac0a1fc2832474405f7ac57b669e0e84_06172024102226021948.m4a';
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String savePath = "${appDocDir.path}/downloaded_audio.m4a";

      await dio.download(url, savePath, onReceiveProgress: (received, total) {
        if (total != -1) {
          setState(() {
            _progress = (received / total * 100).toStringAsFixed(0) + "%";
          });
        }
      });

      setState(() {
        _isDownloading = false;
        _progress = 'Download completed: $savePath';
      });
    } catch (e) {
      setState(() {
        _isDownloading = false;
        _progress = 'Download failed: $e';
      });
    }
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
