import 'package:botnoivoice/service/login/apple_login.dart';
import 'package:botnoivoice/service/login/email_login.dart';
import 'package:botnoivoice/service/email/email_username_api.dart';
import 'package:botnoivoice/service/login/google_login.dart';
import 'package:botnoivoice/service/login/line_login.dart';
import 'package:botnoivoice/service/token/user_token_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DrawerAppbarLogic {
  Future<void> loadUserInfo({
    required WidgetRef ref,
    required Function(
      String displayName,
      String uid,
      String profilePictureUrl,
    ) onUpdateState,
  }) async {

    ///Fetch user data from Firebase
    final appleProvider = ref.read(appleLoginNotifierProvider);
    final googleProvider = ref.read(googleLoginNotifierProvider);
    final lineProvider = ref.read(lineLoginNotifierProvider);
    final emailProvider = ref.read(emailLoginNotifierProvider);

    // Fetch user data from Database (API)
    final userTokenState = ref.read(currentUserTokenStateProvider);

    String displayName = "Loading...";
    String uid = "Loading...";
    String profilePictureUrl = "";

    if (lineProvider.isLoggedIn) {
      displayName = lineProvider.displayName ?? 'No Name';
      uid = userTokenState.userID ?? 'No uid found';
      profilePictureUrl = lineProvider.profilePictureUrl ?? '';
    } else if (appleProvider.isLoggedIn) {
      displayName = userTokenState.userName ?? 'Apple User';
      uid = userTokenState.userID ?? 'No uid found';
      profilePictureUrl = appleProvider.user?.photoURL ?? '';
    } else if (googleProvider.isLoggedIn) {
      displayName = googleProvider.user?.displayName ?? 'Google User';
      uid = userTokenState.userID ?? 'No uid found';
      profilePictureUrl = googleProvider.user?.photoURL ?? '';
    } else if (emailProvider.isLoggedIn) {
      displayName = ref.read(emailUsernameApiNotifierProvider).getUsername ?? "Email User";
      uid = userTokenState.userID ?? 'No uid found';
      profilePictureUrl = emailProvider.user?.photoURL ?? '';
    }

    onUpdateState(displayName, uid, profilePictureUrl);
  }
}
