import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();
  static DateTime stringToDate(String value) {
    DateFormat format = DateFormat('dd-MM-yyyy');
    DateTime dateTime = format.parse(value);
    return dateTime;
  }

  static String formateDateToString(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  static bool dobCanDonate(DateTime userDob) {
    final DateTime currentDate = DateTime.now();
    final int age = currentDate.year - userDob.year;

    // Check if age is greater than 18 and less than 60
    return age > 18 && age < 60;
  }

  static String findHowManyDaysAgo(DateTime dateTime) {
    final today = DateTime.now();
    String string = '';
    if (dateTime.day == today.day) {
      if (dateTime.minute.toString().length == 1) {
        string =
            '${dateTime.hour % 12}:0${dateTime.minute} ${dateTime.hour > 11 ? 'PM' : 'AM'}';
      } else {
        string =
            '${dateTime.hour % 12}:${dateTime.minute}  ${dateTime.hour > 11 ? 'PM' : 'AM'}';
      }
    } else {
      final difference = today.difference(dateTime).inDays;
      string = '$difference days ago';
    }
    return string;
  }

  static String convertChatDateTimeToString(DateTime dateTime) {
    final DateTime now = DateTime.now();

    // Check if the given DateTime is today
    bool isToday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;

    if (isToday) {
      // Format time in 12-hour format
      final DateFormat timeFormatter = DateFormat('hh:mm a');
      return timeFormatter.format(dateTime);
    } else {
      // Format date in dd/MM/yyyy format
      final DateFormat dateFormatter = DateFormat('dd/MM/yyyy');
      return dateFormatter.format(dateTime);
    }
  }
}
