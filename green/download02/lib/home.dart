import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final String imageUrl = 'https://satsang-foundation.org/wp-content/uploads/2022/08/Ganesha-Chathurthi-TSF-4.jpg';
  final Dio dio = Dio();
  double progress = 0.0;
  bool loading = false;

  Future<bool> saveFile(String url) async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      try {
        Directory? directory;
        if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory();
          if (directory != null) {
            String newPath = "";
            List<String> paths = directory.path.split("/");
            for (int x = 1; x < paths.length; x++) {
              String folder = paths[x];
              if (folder != "Android") {
                newPath += "/" + folder;
              } else {
                break;
              }
            }
            newPath = newPath + "/Download";
            directory = Directory(newPath);
          }
        } else {
          directory = await getApplicationDocumentsDirectory();
        }
        
        if (await directory!.exists()) {
          await directory.create(recursive: true);
        }

        String path = '${directory.path}/Shri Ganesha.jpeg';
        File savePath = File(path);
        await dio.download(
          url,
          savePath.path,
          onReceiveProgress: (downloadedSize, totalSize) {
            setState(() {
              progress = downloadedSize / totalSize;
            });
          },
        );
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      return false;
    }
  }

  void downloadImage() async {
    setState(() {
      loading = true;
    });
    bool download = await saveFile(imageUrl);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.onPrimary,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.fitHeight,
                ),
              ),
              LinearProgressIndicator(
                minHeight: 10.0,
                value: progress,
              ),
              ElevatedButton(
                onPressed: downloadImage,
                child: const Text('Download'),
              ),
              if (loading)
                CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
