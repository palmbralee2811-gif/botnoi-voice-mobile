import 'package:botnoivoice/presentation/providers/email/email_delete_account_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/widgets/dialog/alert_notification_dialog.dart';
import 'package:botnoivoice/presentation/widgets/modal/alert_message_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EmailDeleteAccountButton extends StatefulWidget {
  const EmailDeleteAccountButton({super.key});

  @override
  State<EmailDeleteAccountButton> createState() =>
      _EmailDeleteAccountButtonState();
}

class _EmailDeleteAccountButtonState extends State<EmailDeleteAccountButton> {
  Future<void> _deleteAccount() async {
    final emailDeleteAccountProvider =
        Provider.of<EmailDeleteAccountProvider>(context, listen: false);
    final emailProvider =
        Provider.of<EmailLoginProvider>(context, listen: false);
    final tokenProvider =
        Provider.of<EmailTokenProvider>(context, listen: false);

    if (!emailProvider.isLoggedIn || emailProvider.user?.providerData[0].providerId != 'password') {
      AlertMessageModal(
        context: context,
        text: 'ไม่สามารถลบบัญชีได้. คุณไม่ได้เข้าสู่ระบบด้วยอีเมล',
      ).showErrorModal(context);
      return;
    }

    //TODO: ลบตรวจสอบ เครดิตคงเหลือ ออก แล้ว สร้างหน้า UI ใหม่ สำหรับยืนยันลบบัญชี
    if (tokenProvider.getRemainingCredits != '0') {
      AlertMessageModal(
        context: context,
        text: 'เครดิตคงเหลือ ${tokenProvider.getRemainingCredits} \nกรุณาใช้เครดิตให้หมดก่อนลบบัญชี.',
      ).showErrorModal(context);
      return;
    }

    try {
      await emailDeleteAccountProvider.deleteUserAccountWithDatabase();
      final errorMessage = emailDeleteAccountProvider.errorMessage;

      if (errorMessage != null && errorMessage.isNotEmpty) {
        AlertMessageModal(
          context: context,
          text: errorMessage,
        ).showErrorModal(context);
      } else {
        AlertMessageModal(
          context: context,
          text: "ลบบัญชีเรียบร้อยแล้ว",
        ).showCheckmarkModal(context);
      }
    } catch (error) {
      AlertNotificationDialog(
        context: context,
        text: 'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง. $error',
      ).showAsError();
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'ยืนยันการลบบัญชี',
            style: GoogleFonts.prompt(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'คุณแน่ใจหรือไม่ว่าต้องการลบบัญชีนี้?',
            style: GoogleFonts.prompt(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก', style: GoogleFonts.prompt()),
              onPressed: () {
                Navigator.of(context).pop(); // ปิดกล่องโต้ตอบ
              },
            ),
            TextButton(
              child:
                  Text('ยืนยัน', style: GoogleFonts.prompt(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // ปิดกล่องโต้ตอบ
                _deleteAccount(); // เรียกใช้ฟังก์ชันลบบัญชี
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.white, Colors.white],
        ),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        onPressed: () {
          _showConfirmationDialog(); // แสดงกล่องโต้ตอบการยืนยันก่อนลบบัญชี
        },
        child: Text("ลบบัญชี",
            style: GoogleFonts.prompt(
                color: Colors.red,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600)),
      ),
    );
  }
}
