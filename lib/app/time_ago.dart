import 'package:cloud_firestore/cloud_firestore.dart';

class TimeAgoFormatter {
  static String format(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp);
      Duration difference = DateTime.now().difference(dateTime);

      if (difference.inDays > 365) {
        int years = (difference.inDays / 365).floor();
        return '$years ${_pluralize('year', years)} ago';
      } else if (difference.inDays >= 30) {
        int months = (difference.inDays / 30).floor();
        return '$months ${_pluralize('month', months)} ago';
      } else if (difference.inDays >= 1) {
        return '${difference.inDays} ${_pluralize('day', difference.inDays)} ago';
      } else if (difference.inHours >= 1) {
        return '${difference.inHours} ${_pluralize('hour', difference.inHours)} ago';
      } else if (difference.inMinutes >= 1) {
        return '${difference.inMinutes} ${_pluralize('minute', difference.inMinutes)} ago';
      } else {
        return 'just now';
      }
    } catch (e) {
      return timestamp;
    }
  }

  static String formatTimeSt(Timestamp timestamp) {
    try {
      DateTime dateTime = timestamp.toDate();
      Duration difference = DateTime.now().difference(dateTime);

      if (difference.inDays > 365) {
        int years = (difference.inDays / 365).floor();
        return '$years ${_pluralize('year', years)} ago';
      } else if (difference.inDays >= 30) {
        int months = (difference.inDays / 30).floor();
        return '$months ${_pluralize('month', months)} ago';
      } else if (difference.inDays >= 1) {
        return '${difference.inDays} ${_pluralize('day', difference.inDays)} ago';
      } else if (difference.inHours >= 1) {
        return '${difference.inHours} ${_pluralize('hour', difference.inHours)} ago';
      } else if (difference.inMinutes >= 1) {
        return '${difference.inMinutes} ${_pluralize('minute', difference.inMinutes)} ago';
      } else {
        return 'just now';
      }
    } catch (e) {
      return timestamp.toString();
    }
  }

  static String _pluralize(String unit, int value) {
    return unit;
  }
}
