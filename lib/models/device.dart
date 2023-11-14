import 'time.dart';

class Device {
  String? userId;
  String? id;
  String name;
  double kw;
  Time time;
  String manualState;
  bool on = false; //by default devices are off,

  static List<Device> devices =
      <Device>[]; //Must create a new DataRepository (check database functionality) before using this list

  Device({
    this.id,
    this.manualState = "null",
    required this.name,
    required this.time,
    required this.kw,
    this.userId,
  });

  bool checkIfOn(final checkTime) {
    if (manualState != "null") //then its in manual mode
    {
      if (manualState == "on") //device is manually on
      {
        on = true;
        return true;
      } else if (manualState == "off") // device is manually off
      {
        on = false;
        return false;
      }
    }

    int hours = checkTime.hour;
    int minutes = checkTime.minute;
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
    // if its we got to this point the device must be automatically set to off
    on = false;
    return false;
  }

  static Device fromJson(json) {
    var device = Device(
        name: json['name'],
        manualState: json['manualState'],
        time: Time.fromJson(json['time']),
        kw: json['kw']);
    return device;
  }

  Map<String, dynamic> toJson(Device device) => <String, dynamic>{
        'userId': device.userId,
        'name': device.name,
        'time': Time.toJson(time),
        'kw': device.kw,
        'manualState': device.manualState,
      };

  // power usage method that calculates the power usage for the current hour
  double calculatePowerUsageForHour(DateTime currentTime) {
    int timeInMinutes =
        currentTime.hour * 60 + currentTime.minute; // time in minutes

    // checking if the device is on for the current time
    if (time.sameDay == true) {
      if (time.startTime <= timeInMinutes && time.endTime >= timeInMinutes) {
        return kw;
      }
    } else {
      if (time.startTime <= timeInMinutes && time.endTime <= timeInMinutes) {
        return kw;
      }
    }
    return 0;
  }
}

class PowerUsageTracker {
  Map<int, double> powerUsageByHour = {};
  Map<int, List<Device>> devicesByHour = {};

  // update power usage for the nwxt 24 hours (have to call it every time we draw the graph)
  void updatePowerUsageForDay(List<Device> devices) {
    DateTime currentDate = DateTime.now();

    // initializing power usage for each hour to 0 and the devices per hour list
    for (int hour = 0; hour < 24; hour++) {
      powerUsageByHour[hour] = 0.0;
      devicesByHour[hour] = [];
    }

    for (Device device in devices) {
      for (int hour = 0; hour < 24; hour++) {
        DateTime currentHourTime = currentDate.add(Duration(hours: hour));

        //  calculating the power usage for the current hour for the device
        double powerUsage = device.calculatePowerUsageForHour(currentHourTime);

        // adding the device to the list for this hour if there is power usage
        if (powerUsage != 0) {
          devicesByHour[hour]!.add(device);
        }

        // adding the current power suage to the total power usage for this hour
        powerUsageByHour[hour] = (powerUsageByHour[hour] ?? 0) + powerUsage;
      }
    }
  }

  // get power usage method for a specific hour
  double getPowerUsageForHour(int hour) {
    return powerUsageByHour[hour] ?? 0.0;
  }

  // get devices method for a specific hour
  List<Device> getDevicesForHour(int hour) {
    return devicesByHour[hour] ?? [];
  }
}
