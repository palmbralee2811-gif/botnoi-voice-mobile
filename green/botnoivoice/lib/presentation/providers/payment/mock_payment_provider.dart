import 'package:flutter/material.dart';

class MockPaymentProvider with ChangeNotifier {
  // ข้อมูลตัวอย่างสำหรับ Hot Promotion
  List<Map<String, String>> mockProducts = [
    {
      'title': '30,500 พ้อยท์',
      'originalPrice': '750',
      'currentPrice': '400',
    },
    {
      'title': '80,000 พ้อยท์',
      'originalPrice': '2,000',
      'currentPrice': '1,000',
    },
    {
      'title': '200,000 พ้อยท์',
      'originalPrice': '5,000',
      'currentPrice': '2,300',
    },
  ];

  // ข้อมูลตัวอย่างสำหรับ Starter Promotion
  List<Map<String, String>> mockStarterProducts = [
    {
      'title': '4,100 พ้อยท์',
      'originalPrice': '',
      'currentPrice': '99',
    },
    {
      'title': '12,500 พ้อยท์',
      'originalPrice': '299',
      'currentPrice': '199',
    },
    {
      'title': '23,500 พ้อยท์',
      'originalPrice': '499',
      'currentPrice': '349',
    },
  ];

  // การจำลองการซื้อสินค้า
  Future<void> simulatePurchase(String title) async {
    await Future.delayed(const Duration(seconds: 2)); // จำลองเวลาการประมวลผล
    // เพิ่มโลจิกอื่นถ้าจำเป็น
  }
}
