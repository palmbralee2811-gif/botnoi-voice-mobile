import 'dart:async';
import 'package:flutter/material.dart';

int _snackBarCount = 0;
Timer? _snackBarTimer;

void showAddSnackBar(BuildContext context, String text) {
  _snackBarCount++;


    // รีเซ็ตหรือเริ่มนับใหม่ทุกครั้งที่กด
  _snackBarTimer?.cancel();
  _snackBarTimer = Timer(Duration(seconds: 2) , () { //เปลี่ยนหน่วงเวลา
    // เมื่อไม่มีการกดเพิ่มใน 2 วิ → แสดงผลสุดท้าย
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${text}'.replaceAll('{count}', _snackBarCount.toString())),
        duration: Duration(seconds: 1), //เวลาที่แสดง
      ),
    );

    // รีเซ็ต count เพื่อรอบใหม่
    _snackBarCount = 0;
  });
}
