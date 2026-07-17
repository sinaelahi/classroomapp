import 'package:intl/intl.dart';

class DateFormatter {
  static final _dayMonthYear = DateFormat('dd.MM.yyyy', 'tr_TR');

  static String format(DateTime date) => _dayMonthYear.format(date);

  static String formatNullable(DateTime? date) {
    if (date == null) return '-';
    return _dayMonthYear.format(date);
  }
}
