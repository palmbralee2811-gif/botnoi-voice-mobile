import 'package:firebase_auth/firebase_auth.dart';

/// Get user email
String? getUserEmail(User? user) {
  if (user == null) {
    return null;
  }

  for (var userInfo in user.providerData) {
    if (userInfo.email != null) {
      return userInfo.email;
    }
  }
  return null;
}
