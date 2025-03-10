import 'package:email_validator/email_validator.dart';

/// Is valid email format
bool isValidEmail(String email) {
  return EmailValidator.validate(email);
}

/// Is valid username is more than 3 digits
bool isValidUsername(String username) {
  if (username.length < 3) return false;
  final RegExp usernameRegex = RegExp(r'^[a-zA-Z0-9_-]+$');
  return usernameRegex.hasMatch(username);
}
