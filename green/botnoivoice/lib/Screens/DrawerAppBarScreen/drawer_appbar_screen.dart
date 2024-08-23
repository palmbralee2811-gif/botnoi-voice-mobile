import 'package:botnoivoice/Authentication/authentication_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DrawerAppbarScreen extends StatelessWidget {
  const DrawerAppbarScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Authentication>(context, listen: false);
    User? user = FirebaseAuth.instance.currentUser;
    String? email = auth.getUserEmail(user);

    return Drawer(
      elevation: 16,
      backgroundColor: Colors.white,
      shadowColor: Colors.black,
      child: ListView(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.only(left: 30.w, top: 15.w, right: 30.w),
            title: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircleAvatar(
                      backgroundImage: user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : const AssetImage(
                              'assets/app_icon/icon-foreground-432x432.png'),
                      backgroundColor: Colors.black,
                      radius: 20.0.r,
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        textStyle: TextStyle(fontSize: 10.sp),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.menu_rounded,
                        color: const Color(0xFF323130),
                        size: 32.sp,
                      ),
                    ),
                  ],
                ),
                Text(
                  user?.displayName ?? 'No Name',
                  style: GoogleFonts.prompt(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF323130),
                  ),
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  maxLines: 3,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        email ?? 'No email found',
                        style: GoogleFonts.prompt(
                          fontSize: 14.sp,
                          color: const Color(0xFF323130),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.only(left: 30.w, top: 15.w),
            leading: Icon(
              Icons.logout,
              size: 24.sp,
              color: const Color(0xFF323130),
            ),
            title: Text(
              'ออกจากระบบ',
              style: GoogleFonts.prompt(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF323130),
              ),
            ),
            onTap: () {
              auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}
