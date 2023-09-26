import 'package:mysolar/database_functionality/data_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Device {
  // A lot of these should not be null

  String? userId;
  String? id;
  String name;
  int startTime;
  int endTime;
  int kw;

  static List<Device> devices = <Device>[];

  static final repository = DataRepository();

  Device(
      {this.id,
      required this.name,
      required this.startTime,
      required this.endTime,
      required this.kw});

  static Device fromJson(json) {
    return Device(
        name: json['name'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        kw: json['kw']);
  }

  Map<String, dynamic> toJson(Device device) => <String, dynamic>{
        'name': device.name,
        'startTime': device.startTime,
        'endTime': device.endTime,
        'kw': device.kw,
      };
}
