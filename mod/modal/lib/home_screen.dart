import 'package:flutter/material.dart';
import 'package:modal/modals/Delete/DeleteModal.dart';
import 'package:modal/modals/Download/DownloadModal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _openDownloadModal() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => DownlaodModal(),
    );
  }

  void _openDeleteModal() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Deletemodal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFB1E9FD),
            Color(0xFFF9D8FD),
          ],
        ),
      ),
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _openDownloadModal();
              },
              child: Text('Download'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _openDeleteModal();
              },
              child: Text('Delete'),
            )
          ],
        ),
      ),
    ));
  }
}
