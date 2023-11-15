import 'package:cloud_firestore/cloud_firestore.dart';

class DeviceConsumption {
  final String userId;
  final FirebaseFirestore firestore;

  DeviceConsumption({required this.userId, required this.firestore});

//   Future<List<double>> calculateHourlyConsumption() async {
//     QuerySnapshot appliancesSnapshot = await firestore
//         .collection('appliances')
//         .where('userId', isEqualTo: userId)
//         .get();

//     List<Map<String, dynamic>> appliances = appliancesSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

//     List<double> hourlyConsumption = List.filled(12, 0.0);
//     DateTime now = DateTime.now();
//     int currentHour = now.hour;

//     for (int i = 0; i < 12; i++) {
//       int hourToCheck = (currentHour + i + 1) % 24;
//       for (var appliance in appliances) {

//         Map<String, dynamic> time = appliance['time'];
//         int startTime = time['startTime'];
//         int endTime = time['endTime'];
//         bool sameDay = time['sameDay'];

//         int startHour = startTime ~/ 60;
//         int endHour = endTime ~/ 60;

//         int startMinute = startTime % 60;
//         int endMinute = endTime % 60;

//         if (hourToCheck == startHour && hourToCheck == endHour) {
//           int minutesOn = endMinute - startMinute;
//           hourlyConsumption[i] += (minutesOn / 60.0) * appliance['kw'];
//         } else if (hourToCheck == startHour) {
//           int minutesOn = 60 - startMinute;
//           hourlyConsumption[i] += (minutesOn / 60.0) * appliance['kw'];
//         } else if (hourToCheck == endHour) {
//           int minutesOn = endMinute;
//           hourlyConsumption[i] += (minutesOn / 60.0) * appliance['kw'];
//         } else if (sameDay && hourToCheck > startHour && hourToCheck < endHour) {
//           hourlyConsumption[i] += appliance['kw'];
//         } else if (!sameDay && (hourToCheck > startHour || hourToCheck < endHour)) {
//           hourlyConsumption[i] += appliance['kw'];
//         }
//       }
//     }

//     return hourlyConsumption;
// }


// Future<List<List<String>>> devicesOnEachHour() async {
//   QuerySnapshot appliancesSnapshot = await firestore
//       .collection('appliances')
//       .where('userId', isEqualTo: userId)
//       .get();

//   List<Map<String, dynamic>> appliances = appliancesSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

//  // print("Fetched appliances: $appliances"); // Debug print

//   List<List<String>> devicesOn = List.generate(12, (index) => <String>[]);
//   DateTime now = DateTime.now();
//   int currentHour = now.hour;

// for (int i = 0; i < 12; i++) {
//   int hourToCheck = (currentHour + i + 1) % 24;
//   for (var appliance in appliances) {
//     Map<String, dynamic> time = appliance['time'];
//     int startTime = time['startTime'] ~/ 60;
//     int endTime = time['endTime'] ~/ 60;
//     bool sameDay = time['sameDay'];

//     if (sameDay) {
//       if (hourToCheck == startTime || (hourToCheck >= startTime && hourToCheck < endTime)) {
//         devicesOn[i].add(appliance['name']);
//       }
//     } else {
//       if (hourToCheck >= startTime || hourToCheck < endTime) {
//         devicesOn[i].add(appliance['name']);
//       }
//     }
//   }
// }
//  // print("Devices on each hour: $devicesOn"); // debug print

//   return devicesOn;
// }

  Future<List<double>> calculateMinuteConsumption(int apiHour) async { 
    QuerySnapshot appliancesSnapshot = await firestore
        .collection('appliances')
        .where('userId', isEqualTo: userId)
        .get();
    List<Map<String, dynamic>> appliances = appliancesSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    List<double> minuteConsumption = List.filled(720, 0.0);

 for (int i = 0; i < 720; i++) {
    int hourToCheck = (apiHour + i ~/ 60) % 24;
    int minuteToCheck = i % 60;

    for (var appliance in appliances) {
      Map<String, dynamic> time = appliance['time'];
      int startTime = time['startTime'];
      int endTime = time['endTime'];
      bool sameDay = time['sameDay'];

      int startHour = startTime ~/ 60;
      int endHour = endTime ~/ 60;
      int startMinute = startTime % 60;
      int endMinute = endTime % 60;

      if (hourToCheck == startHour && hourToCheck == endHour) {
        if (minuteToCheck >= startMinute && minuteToCheck <= endMinute) {
          minuteConsumption[i] += appliance['kw'] / 60.0;
        }
      } else if (hourToCheck == startHour) {
        if (minuteToCheck >= startMinute) {
          minuteConsumption[i] += appliance['kw'] / 60.0;
        }
      } else if (hourToCheck == endHour) {
        if (minuteToCheck <= endMinute) {
          minuteConsumption[i] += appliance['kw'] / 60.0;
        }
      } else if (sameDay && hourToCheck > startHour && hourToCheck < endHour) {
        minuteConsumption[i] += appliance['kw'] / 60.0;
      } else if (!sameDay && (hourToCheck > startHour || hourToCheck < endHour)) {
        minuteConsumption[i] += appliance['kw'] / 60.0;
      }
    }
  }
    return minuteConsumption;
}


Future<List<List<String>>> devicesOnEachMinute(int apiHour) async {
   QuerySnapshot appliancesSnapshot = await firestore
        .collection('appliances')
        .where('userId', isEqualTo: userId)
        .get();
  List<Map<String, dynamic>> appliances = appliancesSnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

 // print("Fetched appliances: $appliances"); // Debug print

  List<List<String>> devicesOn = List.generate(720, (index) => <String>[]);

for (int i = 0; i < 720; i++) {
  int hourToCheck = (apiHour + i ~/ 60) % 24;
  for (var appliance in appliances) {
    Map<String, dynamic> time = appliance['time'];
    int startTime = time['startTime'] ~/ 60;
    int endTime = time['endTime'] ~/ 60;
    bool sameDay = time['sameDay'];
  

    if (sameDay) {
      if (hourToCheck == startTime || (hourToCheck >= startTime && hourToCheck < endTime)) {
        devicesOn[i].add(appliance['name']);
      }
    } else {
      if (hourToCheck >= startTime || hourToCheck < endTime) {
        devicesOn[i].add(appliance['name']);
      }
    }
  }
}
 // print("Devices on each hour: $devicesOn"); // debug print

  return devicesOn;
}


}
