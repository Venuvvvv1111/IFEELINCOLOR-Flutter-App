import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MediaQueryUtil {
  static Size size(BuildContext context) {
    return MediaQuery.of(context).size;
  }

  static String formatDateWithSuffix(DateTime date) {
    String day = DateFormat('dd').format(date);
    String suffix;

    if (day.endsWith('1') && !day.endsWith('11')) {
      suffix = 'st';
    } else if (day.endsWith('2') && !day.endsWith('12')) {
      suffix = 'nd';
    } else if (day.endsWith('3') && !day.endsWith('13')) {
      suffix = 'rd';
    } else {
      suffix = 'th';
    }

    return DateFormat("dd'$suffix' MMM yyyy").format(date);
  }

  static String formatDoctorDateWithSuffix(DateTime date) {
    String day = DateFormat('d').format(date);
    String suffix;

    if (day.endsWith('1') && !day.endsWith('11')) {
      suffix = 'st';
    } else if (day.endsWith('2') && !day.endsWith('12')) {
      suffix = 'nd';
    } else if (day.endsWith('3') && !day.endsWith('13')) {
      suffix = 'rd';
    } else {
      suffix = 'th';
    }

    return "$day$suffix ${DateFormat('MMM yyyy').format(date)}";
  }

  static String formatDateWithSuffix2(DateTime date) {
    String day = DateFormat('d').format(date); // Remove leading zero
    String suffix;

    if (day.endsWith('1') && !day.endsWith('11')) {
      suffix = 'st';
    } else if (day.endsWith('2') && !day.endsWith('12')) {
      suffix = 'nd';
    } else if (day.endsWith('3') && !day.endsWith('13')) {
      suffix = 'rd';
    } else {
      suffix = 'th';
    }

    String formattedDate = DateFormat('MMM d').format(date) +
        suffix +
        DateFormat(', yyyy').format(date);
    return formattedDate;
  }

  String formatPatientDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return 'N/A';

    try {
      DateTime date = DateTime.parse(dateStr);
      String day = DateFormat('d').format(date);
      String month = DateFormat('MMM').format(date);
      String year = DateFormat('y').format(date);

      // Add suffix for the day
      String suffix = getPatientDaySuffix(int.parse(day));

      return '$day$suffix $month $year';
    } catch (e) {
      return 'Invalid Date';
    }
  }

  String getPatientDaySuffix(int day) {
    if (day >= 11 && day <= 13) return 'th';
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
