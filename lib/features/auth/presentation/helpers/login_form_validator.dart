import 'package:myapp/core/utilis/app_regexp.dart';

class LogInFormValidator {
  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email cannot be empty';
    }
    // Regular expression pattern for validating email
    final emailPattern = AppRegExp.emailPattern;
    if (!emailPattern.hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password cannot be empty';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }
}
