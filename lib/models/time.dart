class Time {
  int startTime;
  int endTime;
  bool sameDay;

  Time({required this.startTime, required this.endTime, required this.sameDay});

  static Time makeTime(String startTimeText, String endTimeText) {
    var time = Time(
        startTime: convertToMinutes(startTimeText),
        endTime: convertToMinutes(endTimeText),
        sameDay: true);

    if (time.startTime > time.endTime) {
      time.sameDay = false;
    }

    return time;
  }

  static Map<String, dynamic> toJson(Time time) => <String, dynamic>{
        'startTime': time.startTime,
        'endTime': time.endTime,
        'sameDay': time.sameDay
      };

  static Time fromJson(json) {
    return Time(
      startTime: json['startTime'],
      endTime: json['endTime'],
      sameDay: json['sameDay'],
    );
  }

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

  static bool validateInputTime(String input) {
    input = handleSingleDigitHour(input);

    if (int.parse(input.substring(0, 2)) >= 24 ||
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

  static convertToHourMinutes(int minutes) {
    String str = "";
    str += (minutes / 60).floor().toString();
    if (str.length == 1) {
      str = "0" + str;
    }

    str += ":";
    String minute = (minutes % 60).toString();

    if (minute.length == 1) {
      str += "0$minute";
    } else {
      str += "$minute";
    }

    return str;
  }
}
