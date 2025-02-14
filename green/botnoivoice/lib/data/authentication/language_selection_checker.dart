import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:botnoivoice/data/authentication/auth_checker.dart';
import 'package:botnoivoice/presentation/screens/splash/splash_screen.dart'; // เพิ่มหน้าจอ Splash
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization
import 'package:flutter/widgets.dart'; // สำหรับ WidgetsBindingObserver

class LanguageSelectionChecker extends StatefulWidget {
  const LanguageSelectionChecker({super.key});

  @override
  _LanguageSelectionCheckerState createState() => _LanguageSelectionCheckerState();
}

class _LanguageSelectionCheckerState extends State<LanguageSelectionChecker> with WidgetsBindingObserver {
  late String _localeCode;

  // โหลดภาษาที่บันทึกไว้
  Future<String> loadSelectedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selected_language') ?? ''; // ค่าเริ่มต้นเป็นค่าว่าง
  }

  // ฟังก์ชันเพื่อตั้งค่าภาษาเครื่อง
  Future<void> setDeviceLanguage(BuildContext context) async {
    String localeCode = await loadSelectedLanguage();
    Locale initialLocale = localeCode.isNotEmpty
        ? Locale(localeCode) // ใช้ภาษาที่เลือกไว้
        : Locale(WidgetsBinding.instance.window.locale.languageCode); // ใช้ภาษาของเครื่อง

    EasyLocalization.of(context)!.setLocale(initialLocale); // ตั้งค่าภาษาให้ตรงกับเครื่อง
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // เพิ่ม Observer เพื่อตรวจจับการเปลี่ยนแปลง
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
    String localeCode = await loadSelectedLanguage();
    setState(() {
      _localeCode = localeCode.isNotEmpty ? localeCode : WidgetsBinding.instance.window.locale.languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: loadSelectedLanguage(), // โหลดภาษาเริ่มต้นจาก SharedPreferences
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // ระหว่างโหลด แสดงหน้า splash screen
          return SplashScreen(); // เพิ่มหน้าจอ SplashScreen ขณะโหลด
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
