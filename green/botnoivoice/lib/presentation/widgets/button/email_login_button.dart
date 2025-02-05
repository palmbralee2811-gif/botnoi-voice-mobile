import 'package:botnoivoice/presentation/constants/styles.dart';
import 'package:botnoivoice/presentation/screens/responsive/orientation_helper.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmailLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  const EmailLoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: EdgeInsets.only(
                left: OrientationHelper.isLandscape ? 65.w : 30.w,
                right: OrientationHelper.isLandscape ? 65.w : 30.w),
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  side: BorderSide(
                    color: Colors.grey.shade400,
                    width: 1.0,
                  ),
                ),
                padding: EdgeInsets.zero,
                minimumSize:
                    OrientationHelper.isLandscape ? Size(224.w, 88.h) : Size(224.w, 48.h),
              ),
              //TODO: [Bug] UI Overflow in Email Login Button
              /*
════════ Exception caught by rendering library ═════════════════════════════════
The following assertion was thrown during layout:
A RenderFlex overflowed by 37 pixels on the right.

The relevant error-causing widget was:
    Row Row:file:///Users/kawin101/Desktop/botnoi-voice-mobile/green/botnoivoice/lib/presentation/widgets/button/email_login_button.dart:38:22

: To inspect this widget in Flutter DevTools, visit: http://127.0.0.1:9100/#/inspector?uri=http%3A%2F%2F127.0.0.1%3A62790%2FeCAt20acy3A%3D%2F&inspectorRef=inspector-0

The overflowing RenderFlex has an orientation of Axis.horizontal.
The edge of the RenderFlex that is overflowing has been marked in the rendering with a yellow and black striped pattern. This is usually caused by the contents being too big for the RenderFlex.
Consider applying a flex factor (e.g. using an Expanded widget) to force the children of the RenderFlex to fit within the available space instead of being sized to their natural size.
This is considered an error condition because it indicates that there is content that cannot be seen. If the content is legitimately bigger than the available space, consider clipping it with a ClipRect widget before putting it in the flex, or using a scrollable container rather than a Flex, like a ListView.
The specific RenderFlex in question is: RenderFlex#450c7 relayoutBoundary=up28 OVERFLOWING
    parentData: offset=Offset(0.0, 17.7) (can use size)
    constraints: BoxConstraints(0.0<=w<=334.3, 0.0<=h<=Infinity)
    size: Size(334.3, 25.3)
    direction: horizontal
    mainAxisAlignment: center
    mainAxisSize: max
    crossAxisAlignment: center
    textDirection: ltr
    verticalDirection: down
    child 1: RenderSemanticsAnnotations#34115 relayoutBoundary=up29
        parentData: offset=Offset(0.0, 0.0); flex=null; fit=null (can use size)
        constraints: BoxConstraints(unconstrained)
        size: Size(25.7, 25.3)
        child: RenderConstrainedBox#d76fc relayoutBoundary=up30
            parentData: <none> (can use size)
            constraints: BoxConstraints(unconstrained)
            size: Size(25.7, 25.3)
            additionalConstraints: BoxConstraints(w=25.7, h=25.3)
    child 2: RenderConstrainedBox#1c7f5 relayoutBoundary=up29
        parentData: offset=Offset(25.7, 12.7); flex=null; fit=null (can use size)
        constraints: BoxConstraints(unconstrained)
        size: Size(20.6, 0.0)
        additionalConstraints: BoxConstraints(w=20.6, 0.0<=h<=Infinity)
    child 3: RenderParagraph#09373 relayoutBoundary=up29
        parentData: offset=Offset(46.3, 1.7); flex=null; fit=null (can use size)
        constraints: BoxConstraints(unconstrained)
        size: Size(325.2, 22.0)
        textAlign: start
        textDirection: ltr
        softWrap: wrapping at box width
        overflow: clip
        locale: id
        maxLines: unlimited
        text: TextSpan
            debugLabel: (((((englishLike labelLarge 2021).merge((blackMountainView labelLarge).apply)).copyWith).copyWith).copyWith).merge(unknown)
            inherit: false
            color: Color(0xff323130)
            family: Prompt_500
            familyFallback: Prompt
            size: 15.4
            weight: 500
            letterSpacing: 0.1
            baseline: alphabetic
            height: 1.4x
            leadingDistribution: even
            decoration: Color(0xff1d1b20) TextDecoration.none
            "Masuk dengan Nama Pengguna atau Email"
◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤◢◤
════════════════════════════════════════════════════════════════════════════════
              */
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/auth_screen/email-icon.svg',
                    height: OrientationHelper.isLandscape ? 35.h : 20.h,
                    width: OrientationHelper.isLandscape ? 20.w : 20.w,
                  ),
                  SizedBox(width: OrientationHelper.isLandscape ? 12.w : 16.w),
                  Text(
                    'auth.sign_in_with_username_email'.tr(),
                    style: TextStyle(
                      fontSize: OrientationHelper.isLandscape ? 9.sp : 12.sp,
                      color: kDark,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
