class TextFormatter {
  TextFormatter._();

  static String formatAddress(String rawAddress) {
    List<String> split = rawAddress.split(',');
    return split.length > 1 ? split.sublist(1).join(',').trim() : '';
  }
}
