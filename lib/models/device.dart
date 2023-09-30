import 'dart:ffi';

import 'time.dart';

class Device {
  // A lot of these should not be null

  String? userId;
  String? id;
  String name;
  int kw;
  Time time;
  bool on = false; //by default devices are off,

  static List<Device> devices =
      <Device>[]; //Must create a new DataRepository (check database functionality) before using this list

  Device({this.id, required this.name, required this.time, required this.kw});

  bool checkIfOn() {
    final currentTime = DateTime.now();

    int hours = currentTime.hour;
    int minutes = currentTime.minute;

    int timeInMinutes = hours * 60 + minutes;

    if (time.sameDay == true)
    // then the device is on if the current time is between startTime and endTime
    {
      if (time.startTime <= timeInMinutes && time.endTime >= timeInMinutes) {
        on = true;
        return true;
      }
    } else {
      if (time.startTime <= timeInMinutes && time.endTime <= timeInMinutes) {
        on = true;
        return true;
      }
    }

    on = false;
    return false;
  }

  static Device fromJson(json) {
    return Device(
        name: json['name'], time: Time.fromJson(json['time']), kw: json['kw']);
  }

  Map<String, dynamic> toJson(Device device) => <String, dynamic>{
        'userId': device.userId,
        'name': device.name,
        'time': Time.toJson(time),
        'kw': device.kw,
      };
}
