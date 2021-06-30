import 'package:intl/intl.dart';

///
/// @see https://www.flutterclutter.dev/flutter/tutorials/date-format-dynamic-string-depending-on-how-long-ago/2020/229/
///
/// https://pub.dev/documentation/intl/latest/intl/DateFormat-class.html
class TimeUtil {
  static String getDateTimeRepresentation(DateTime dateTime) {
    DateTime now = DateTime.now();
    DateTime localDateTime = dateTime.toLocal();

    if (now.difference(localDateTime).inMinutes < 1) return 'Vừa xong';

    String roundTimeString = DateFormat('jm').format(dateTime);
    if (_isSameDay(localDateTime, now)) return roundTimeString;

    DateTime yesterday = now.subtract(Duration(days: 1));
    if (_isSameDay(localDateTime, yesterday))
      return 'Hôm qua, $roundTimeString';

    DateTime theDayBeforeYesterday = now.subtract(Duration(days: 2));
    if (_isSameDay(localDateTime, theDayBeforeYesterday))
      return 'Hôm kia, $roundTimeString';

    if (now.difference(localDateTime).inDays < 4) {
      String weekday = DateFormat('EEEE').format(localDateTime);

      return '$weekday, $roundTimeString';
    }

    return '${DateFormat('yMd').format(localDateTime)}, $roundTimeString';
  }

  static bool _isSameDay(DateTime date1, DateTime date2) =>
      date1.day == date2.day &&
      date1.month == date2.month &&
      date1.year == date2.year;
}
