import 'dart:convert';
import 'package:http/http.dart' as http;

class DayTimeResult {
  final List<dynamic> times;
  final List<dynamic> days;

  DayTimeResult(this.times, this.days);
}

class DataHandler {
  static const String baseUrl =
      'https://developer.sepush.co.za/business/2.0/area';
  static const String token = 'F294A5CF-965A40F4-A8515DE0-DA856EDD';

  Future<Map<String, dynamic>> fetchData() async {
    final Uri url = Uri.https(baseUrl, '', {
      'id':
          'eskde-3-universityofthewitwatersrandresearchsiteandsportscityofjohannesburggauteng',
      'test': 'current'
    });
    final Map<String, String> headers = {'Token': token};

    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  DayTimeResult dayTimes(Map<String, dynamic> data, int stageNo, int dayNo) {
    List<dynamic> scheduleDays = data['schedule']['days'];
    List<dynamic> times = [];
    List<dynamic> days = [];
    int count = 0;
    for (var day in scheduleDays) {
      count += 1;
      if (dayNo == count) {
        List<dynamic> stages = day['stages'];
        var s_length = 0;
        if (dayNo == 0) {
          days.add(day['name'] + " - Today");
        } else {
          days.add(day['name'] + " - " + day['date']);
        }
        for (var stage in stages) {
          s_length += 1;
          if (s_length == stageNo) {
            for (var timeSlot in stage) {
              times.add(timeSlot);
            }
          }
        }
        break;
      }
    }
    return DayTimeResult(times, days);
  }
}
