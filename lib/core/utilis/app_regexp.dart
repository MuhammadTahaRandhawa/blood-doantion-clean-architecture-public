class AppRegExp {
  static final RegExp numberPattern = RegExp(r'^[0-9]+$');
  static final RegExp numberPatternWithPlusAtStart = RegExp(r'^\+[0-9]+$');
  static final RegExp upperCaseLetter = RegExp(r'[A-Z]');
  static final RegExp lowerCaseLetter = RegExp(r'[a-z]');
  static final RegExp emailPattern =
      RegExp(r'^[a-zA-Z0-9._]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
}
