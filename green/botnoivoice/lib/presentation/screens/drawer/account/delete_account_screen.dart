import 'package:botnoivoice/domain/repositories/auth_checker.dart';
import 'package:botnoivoice/presentation/constants/color.dart';
import 'package:botnoivoice/presentation/providers/email/email_delete_account_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_login_provider.dart';
import 'package:botnoivoice/presentation/providers/email/email_token_provider.dart';
import 'package:botnoivoice/presentation/widgets/dialog/alert_notification_dialog.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_align.dart';
import 'package:botnoivoice/presentation/widgets/gradient/gradient_text_button.dart';
import 'package:botnoivoice/presentation/widgets/modal/alert_message_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  Future<void> _signOut(BuildContext context) async {
    final emailProvider =
        Provider.of<EmailLoginProvider>(context, listen: false);

    if (emailProvider.isLoggedIn &&
        emailProvider.user?.providerData[0].providerId == 'password') {
      await emailProvider.signOutWithEmail(context);
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => AuthChecker(),
      ),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _deleteAccount() async {
    final emailDeleteAccountProvider =
        Provider.of<EmailDeleteAccountProvider>(context, listen: false);
    final emailProvider =
        Provider.of<EmailLoginProvider>(context, listen: false);
    final tokenProvider =
        Provider.of<EmailTokenProvider>(context, listen: false);

    if (!emailProvider.isLoggedIn ||
        emailProvider.user?.providerData[0].providerId != 'password') {
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
        text:
            'เครดิตคงเหลือ ${tokenProvider.getRemainingCredits} \nกรุณาใช้เครดิตให้หมดก่อนลบบัญชี.',
      ).showErrorModal(context);
      return;
    }

    try {
      await emailDeleteAccountProvider.deleteUserAccountWithDatabase();
      final errorMessage = emailDeleteAccountProvider.errorMessage;

      await _signOut(context);

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
          title: const Text(
            'ยืนยันการลบบัญชี',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'คุณแน่ใจหรือไม่ว่าต้องการลบบัญชีนี้?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(); // ปิดกล่องโต้ตอบ
              },
            ),
            TextButton(
              child: const Text('ยืนยัน', style: TextStyle(color: Colors.red)),
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'ลบบัญชี',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: kDark, // Regular text color
          ),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kDark,
            size: 24.sp,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 24.h),
            GradientTextAlign(
              'โปรดอ่าน',
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF9340FF),
                  Color(0xFF34BDFA),
                ],
              ),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22.sp,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8.h),
            GradientTextAlign(
              'การลบบัญชีเป็นการกระทำที่ไม่สามารถย้อนกลับได้ คุณจะไม่สามารถใช้บัญชีนี้กับผลิตภัณฑ์และบริการ พ้อยท์คงเหลือหรือแพ็คเกจที่สมัคร สิทธิพิเศษและโปรโมชั่นที่ได้รับอีกต่อไป โปรดระมัดระวัง',
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF9340FF),
                  Color(0xFF34BDFA),
                ],
              ),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                decoration: TextDecoration.none,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 16.h),
            const Spacer(),
            // Centered and split the text into two sections for better alignment
            Center(
              child: Column(
                children: [
                  GradientTextAlign(
                    'หากยืนยันที่จะลบบัญชีต่อ กรุณากดปุ่ม',
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF9340FF),
                        Color(0xFF34BDFA),
                      ],
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  GradientTextAlign(
                    '"ยืนยันลบบัญชี" ด้านล่าง',
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF9340FF),
                        Color(0xFF34BDFA),
                      ],
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                      decoration: TextDecoration.none,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            GradientTextButton(
              text: 'ยกเลิก',
              onPressed: () async {
                Navigator.pop(context); // กดเพื่อกลับไปหน้าก่อนหน้า
              },
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: () {
                _showConfirmationDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: const BorderSide(color: Color(0xFFCCCCCC)),
                ),
                elevation: 0,
              ),
              child: Center(
                child: Text(
                  'ยืนยันลบบัญชี',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: kDark,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
