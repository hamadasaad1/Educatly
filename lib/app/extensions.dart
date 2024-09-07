import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';

import 'constants.dart';

extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return Constants.empty;
    } else {
      return this!;
    }
  }
}

extension NonNullInteger on int? {
  int orZero() {
    if (this == null) {
      return Constants.zero;
    } else {
      return this!;
    }
  }
}

extension NonNullDouble on double? {
  double orZero() {
    if (this == null) {
      return Constants.zeroDec;
    } else {
      return this!;
    }
  }
}

extension NonNullBoolean on bool? {
  bool orBool() {
    if (this == null) {
      return Constants.isEmpty;
    } else {
      return this!;
    }
  }
}

extension NonNullMap on Map<String, bool>? {
  Map<String, bool> orEmpty() {
    if (this == null) {
      return {};
    } else {
      return this!;
    }
  }
}

extension TimeStringExtension on String {
  String convertToAMAndPM() {
    if (isEmpty) {
      return Constants.empty;
    } else {
      final time = DateFormat('HH:mm').parse(this);
      final formattedTime = DateFormat('h:mm a').format(time);
      return formattedTime;
    }
  }
}

extension DateConversion on String {
  String convertToFormattedDate() {
    try {
      // Parse the input date string
      final parsedDate = DateTime.parse(this);

      // Format the date as 'dd/mm/yy'

      final formattedDate = DateFormat('dd-MMM-yyyy', 'en').format(parsedDate);
      // String formattedDate =
      //     "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}";

      return formattedDate;
    } catch (e) {
      // Handle parsing errors (invalid date format)
      print("Error converting date: $e");
      return this;
    }
  }
}

extension TimeConversion on String {
  String convertTo24HourFormat() {
    if (isEmpty) {
      return Constants.empty;
    } else {
      DateFormat inputFormat =
          DateFormat('hh:mm a', 'en'); // Specify the input format as AM/PM
      DateFormat outputFormat =
          DateFormat('HH:mm', 'en'); // Specify the output format as 24-hour

      DateTime time = inputFormat
          .parse(this); // Parse the time string into a DateTime object
      String convertedTime = outputFormat.format(
          time); // Format the DateTime object into the desired 24-hour format

      return convertedTime;
    }
  }
}

extension DateFormatter on String {
  String toFormattedDate() {
    if (isEmpty) {
      return Constants.empty;
    } else {
      final parsedDate = DateTime.parse(this);
      final formattedDate = DateFormat('E, MMM d', 'en').format(parsedDate);
      return formattedDate;
    }
  }

  String convertDateToTimeAMPM() {
    try {
      DateTime dateTime = DateTime.parse(this);
      String formattedTime = DateFormat("hh:mm a").format(dateTime);
      return formattedTime;
    } catch (e) {
      print("Error parsing date: $e");
      return "--:--"; // Or handle the error as needed
    }
  }
}

extension DateFormatters on String {
  String toFormattedDateYear() {
    if (isEmpty) {
      return Constants.empty;
    } else {
      final parsedDate = DateTime.parse(this);
      final formattedDate = DateFormat('E, MMM d, yyyy').format(parsedDate);
      return formattedDate;
    }
  }
}

extension ColorExtension on String {
  Color toColor() {
    String colorString = this;
    if (isEmpty) {
      return Colors.white;
    }
    if (colorString.startsWith("#")) {
      colorString = colorString.substring(1);
    }
    if (colorString.length == 6) {
      colorString = "FF$colorString";
    }
    return Color(int.parse(colorString, radix: 16));
  }
}

extension ColorsExtension on Color {
  String toHexString() {
    // String hexAlpha = alpha.toRadixString(16).padLeft(2, '0');
    String hexRed = red.toRadixString(16).padLeft(2, '0');
    String hexGreen = green.toRadixString(16).padLeft(2, '0');
    String hexBlue = blue.toRadixString(16).padLeft(2, '0');
    return '$hexRed$hexGreen$hexBlue';
  }
}

extension FirstLettersExtension on String {
  String extractFirstLetters() {
    List<String> words = split(" ");
    String result = "";

    for (String word in words) {
      if (word.isNotEmpty) {
        result += "${word[0].toUpperCase()}.";
      }
    }

    if (result.isNotEmpty) {
      result = result.substring(0, result.length - 1);
    }

    return result;
  }
}

extension CardTypeExtension on String {
  String getCardType() {
    RegExp re = RegExp(r'^4[0-9]{12}(?:[0-9]{3})?$');
    if (re.hasMatch(this)) {
      return "visa";
    }

    re = RegExp(r'^(34|37)');
    if (re.hasMatch(this)) {
      return "amex";
    }

    re = RegExp(r'^5[1-5]');
    if (re.hasMatch(this)) {
      return "mastercard";
    }

    re = RegExp(r'^6011');
    if (re.hasMatch(this)) {
      return "discover";
    }

    re = RegExp(r'^9792');
    if (re.hasMatch(this)) {
      return "troy";
    }

    return "unknown"; // If no pattern matches, return "unknown".
  }
}

extension DoubleExtensions on double {
  String formatAsCurrency() {
    final NumberFormat formatter = NumberFormat('#,##0.00', 'en');
    return formatter.format(this);
  }
}

extension StringExtensions on String {
  String formatAsCurrency() {
    try {
      final double number = double.tryParse(this) ?? 0.0;
      final NumberFormat formatter = NumberFormat('#,##0.00', 'en');
      return formatter.format(number);
    } catch (e) {
      return this;
    }
  }
}

extension IntegerExtensions on int {
  String formatAsCurrency() {
    try {
      final NumberFormat formatter = NumberFormat('#,##0.00', 'en');
      return formatter.format(this);
    } catch (e) {
      return toString();
    }
  }
}

extension StringExtension on String {
  String getLastFourDigits() {
    // Ensure the string has at least 4 characters
    if (length >= 4) {
      return substring(length - 4);
    } else {
      // Handle the case when the string has less than 4 characters
      return this;
    }
  }
}

extension CreditCardExpirationDateExtension on String {
  String toTimestamp() {
    // Extract month and year from the credit card expiration date
    List<String> parts = split('-');
    if (parts.length != 2) {
      throw const FormatException('Invalid credit card expiration date format');
    }

    int month = int.parse(parts[0]);
    int year = int.parse(parts[1]);

    // Convert to a full timestamp string
    DateTime expirationDate = DateTime(year + 2000, month, 1);
    return expirationDate.toUtc().toIso8601String();
  }
}

extension FileExtension on File {
  String convertToBase64() {
    final bytes = readAsBytesSync();
    String base64Str = base64Encode(bytes);
    String? mimeType = lookupMimeType(this.path);
    return 'data:$mimeType;base64,$base64Str';
  }
}
extension DateTimeFormatting on DateTime {
  String toFormattedDate() {
    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);
    DateTime yesterdayStart = todayStart.subtract(const Duration(days: 1));

    if (isAfter(todayStart)) {
      return 'Today';
    } else if (isAfter(yesterdayStart) && isBefore(todayStart)) {
      return 'Yesterday';
    } else {
      return DateFormat('dd-MM-yyyy').format(this);
    }
  }
}
