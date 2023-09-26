import 'package:flutter/material.dart';

class Time {
  static String handleSingleDigitHour(String input) {
    /*If a string input is only length 4 then add a 0 to its front so that it matches the expected length 5 string expected
    by all functions in Time
     */
    if (input.length == 4) {
      return '0$input';
    } else {
      return input;
    }
  }

  static int handleTimeOfDay(TimeOfDay timeOfDay) {
    var hours = timeOfDay.hour;
    var minutes = timeOfDay.minute;

    String hhmm;

    if (minutes < 10) // if minutes are single digit
    {
      hhmm = "$hours:0$minutes";
    } else {
      hhmm = "$hours:$minutes";
    }

    hhmm = handleSingleDigitHour(hhmm);

    return convertToMinutes(hhmm);
  }

  static bool validateInputTime(String input) {
    input = handleSingleDigitHour(
        input); // if string is only of length 4 append a zero to its left

    if (int.parse(input.substring(0, 2)) > 24 ||
        int.parse(input.substring(3)) > 59) {
      return false;
    }

    return true;
  }

  static int convertToMinutes(String input) {
    // if string is only of length 4 append a zero to its left
    input = handleSingleDigitHour(input);
    var minuteTime = 0;
    minuteTime =
        int.parse(input.substring(0, 2)) * 60 + int.parse(input.substring(3));
    return minuteTime;
  }

  static converMinutesToHourMinutes(int minutes) {
    String str = "";
    str += (minutes / 60).floor().toString();
    str += ":";
    str += (minutes % 60).toString();

    return str;
  }
}
