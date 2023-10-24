import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchTodaysLoadSheddingSchedule {
  String jsonData = '';
  Map<String, dynamic>? data;
  List<dynamic> days = [];

  Future<void> fetchData() async {
    final url = Uri.https('developer.sepush.co.za', '/business/2.0/area', {
      'id':
          'eskde-3-universityofthewitwatersrandresearchsiteandsportscityofjohannesburggauteng',
      'test': 'current'
    });
    final headers = {
      'Token': 'F294A5CF-965A40F4-A8515DE0-DA856EDD',
    };
    try {
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        data = json.decode(response.body);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error:$e');
    }
  }

  List<dynamic> dayTimes(int stageNo, int dayNo) {
    List<dynamic> scheduleDays = data!['schedule']['days'];
    List<dynamic> times = [];
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
    return times;
  }

  int convertToMinutes(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return hours * 60 + minutes;
  }

  Future<List<List<int>>> getCurrentDayLoadShedding() async{
    await fetchData(); //make sure data is fetched

    if (data == null) return [[]];

    int stageNo = int.parse((data!['events'][0]['note'])[6]);

    String todayDate = DateTime.now().toLocal().toString().split(' ')[0];

    // find the schedule for today
    for (var day in data!['schedule']['days']) {
      if (day['date'] == todayDate) {
        if (stageNo <= day['stages'].length) {
          List<String> times = day['stages'][stageNo - 1].cast<String>();
          return times.map((time) {
            List<String> parts = time.split('-');
            int start = convertToMinutes(parts[0].trim());
            int end = convertToMinutes(parts[1].trim());
            return [start, end];
          }).toList();
        }
      }
    }

    return [[]];
  }
}
