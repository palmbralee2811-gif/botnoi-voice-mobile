import 'dart:ui';
import 'package:botnoivoice/function/app_language_function.dart';
import 'package:flutter/material.dart';
import 'package:botnoivoice/auth/auth_checker.dart';
import 'package:botnoivoice/ui/screen/splash/splash_screen.dart'; // เพิ่มหน้าจอ Splash
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization

class AppLanguageSelectionChecker extends StatefulWidget {
  const AppLanguageSelectionChecker({super.key});

  @override
  State<AppLanguageSelectionChecker> createState() =>
      _AppLanguageSelectionCheckerState();
}

class _AppLanguageSelectionCheckerState
    extends State<AppLanguageSelectionChecker> with WidgetsBindingObserver {



  // ฟังก์ชันเพื่อตั้งค่าภาษาเครื่อง
  Future<void> setDeviceLanguage(BuildContext context) async {
    String localeCode = await loadSelectedLanguage();
    Locale initialLocale;

    if (localeCode.isNotEmpty) {
      initialLocale = Locale(localeCode); // หากเลือกภาษาจาก SharedPreferences
    } else {
      // หากไม่ได้เลือกภาษา, ตรวจสอบภาษาเครื่อง
      String deviceLanguage =
          PlatformDispatcher.instance.locales.first.languageCode;

      // ใช้ switch-case เพื่อตรวจสอบภาษา
      switch (deviceLanguage) {
        case 'th': // ภาษาไทย
          initialLocale = const Locale('th');
          break;
        case 'en': // ภาษาอังกฤษ
          initialLocale = const Locale('en');
          break;
        case 'id': // ภาษาอินโดนีเซีย
          initialLocale = const Locale('id');
          break;
        default:
          // ถ้าภาษาเครื่องไม่ใช่ th, en, id ให้ใช้ภาษาอังกฤษ (en)
          initialLocale = const Locale('en');
          break;
      }
    }

    EasyLocalization.of(context)!
        .setLocale(initialLocale); // ตั้งค่าภาษาให้ตรงกับเครื่อง
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addObserver(this); // เพิ่ม Observer เพื่อตรวจจับการเปลี่ยนแปลง
    _initializeLocale();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // ลบ Observer เมื่อไม่ใช้งาน
    super.dispose();
  }

  // ฟังก์ชันนี้จะถูกเรียกเมื่อภาษาเครื่องเปลี่ยน
  @override
  void didChangeLocales(List<Locale>? locales) {
    super.didChangeLocales(locales);
    // รีเฟรชภาษาเมื่อภาษาเครื่องเปลี่ยน
    setState(() {
      setDeviceLanguage(context); // ตั้งค่าภาษาใหม่
    });
  }

  // ฟังก์ชันเริ่มต้นเพื่อโหลดภาษาเริ่มต้น
  _initializeLocale() async {
    setState(() {
      // ไม่มีการใช้ _localeCode แล้ว จึงไม่ต้องเก็บค่า
      setDeviceLanguage(context); // เรียกฟังก์ชันที่ตั้งค่าภาษา
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: loadSelectedLanguage(), // โหลดภาษาเริ่มต้นจาก SharedPreferences
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // ระหว่างโหลด แสดงหน้า splash screen
          return const SplashScreen(); // เพิ่มหน้าจอ SplashScreen ขณะโหลด
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          // หากเลือกภาษาไว้แล้ว, ไปที่ AuthChecker พร้อมกับภาษาเครื่อง
          setDeviceLanguage(context);
          return AuthChecker();
        } else {
          // หากยังไม่เลือกภาษา, ไปที่หน้าจอ LanguageSelectionScreen
          setDeviceLanguage(context);
          return AuthChecker(); // เมื่อโหลดเสร็จแล้ว ไปที่ AuthChecker
        }
      },
    );
  }
}
