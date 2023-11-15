import '../models/device.dart';

class DeviceConsumption {
  List<Device> devices = Device.devices;

  Future<List<double>> calculateMinuteConsumption(int apiHour) async {
    List<double> minuteConsumption = List.filled(720, 0.0);
    DateTime now = DateTime.now();
    int currentHour = apiHour;

    for (int i = 0; i < 720; i++) {
      int hourToCheck = currentHour;
      int minuteToCheck = i % 60;

      DateTime time =
          DateTime(now.year, now.month, now.day, hourToCheck, minuteToCheck);

      for (var device in devices) {
        if (device.checkIfOn(time)) {
          minuteConsumption[i] += device.kw / 60.0;
        }
      }
    }
    return minuteConsumption;
  }

  Future<List<List<String>>> devicesOnEachMinute(int apiHour) async {
    List<List<String>> devicesOn = List.generate(720, (index) => <String>[]);

    DateTime now = DateTime.now();
    int currentHour = apiHour;

    for (int i = 0; i < 720; i++) {
      int hourToCheck = currentHour;
      int minuteToCheck = i % 60;

      DateTime time =
          DateTime(now.year, now.month, now.day, hourToCheck, minuteToCheck);

      for (var device in devices) {
        if (device.checkIfOn(time)) {
          devicesOn[i].add(device.name);
        }
      }
    }
    return devicesOn;
  }
}
