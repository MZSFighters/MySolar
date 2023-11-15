import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mysolar/battery_output_calculation/finalOutputCalculation.dart';
import 'package:mysolar/graph/prediction_graph.dart';
import 'package:mysolar/load_shedding/fetch_today_schedule.dart';
import 'package:mysolar/device_consumption_and_use/deviceConsumption.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysolar/models/system_details.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final String userId = user!.uid;

class GraphInitiator extends StatelessWidget {
  static Future<SystemDetails?> fetchSystemDetails(String userId) async {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref("systemDetailsInformation/$userId");
    DataSnapshot snapshot = await dbRef.get();

    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      return SystemDetails.fromMap(data);
    } else {
      print(userId);
      print("No data available.");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SystemDetails?>(
      future: fetchSystemDetails(userId),
      builder: (context, snapshotSystemDetails) {
        if (snapshotSystemDetails.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshotSystemDetails.hasError ||
            !snapshotSystemDetails.hasData) {
          print('${snapshotSystemDetails.error}');
          return Scaffold(
              body: Center(
                  child: Text('Error : ${snapshotSystemDetails.error}')));
        }

        final SystemDetails systemDetails = snapshotSystemDetails.data!;
        final double maxOutput = systemDetails.maxPowerOutput;
        final double possibleStorage = systemDetails.batteryCapacity *
            (1 - systemDetails.lowestBatteryPercentage / 100);

        return FutureBuilder<List<Map<String, dynamic>>>(
          future: finalOutputData(systemDetails),
          builder: (context, snapshotKw) {
            if (snapshotKw.connectionState == ConnectionState.waiting) {
              return Scaffold(body: Center(child: CircularProgressIndicator()));
            } else if (snapshotKw.hasError) {
              return Scaffold(
                  body: Center(child: Text('Error: ${snapshotKw.error}')));
            }
            List<Map<String, dynamic>> hourlyKw = snapshotKw.data!;
            int apiHour = int.parse(hourlyKw[0]['hour'].split(':')[0]);

            final Future<List<List<String>>> minutelyAppliancesFuture =
                DeviceConsumption(userId: userId, firestore: firestore)
                    .devicesOnEachMinute(apiHour);
            final Future<List<List<int>>> loadSheddingScheduleFuture =
                FetchTodaysLoadSheddingSchedule().getCurrentDayLoadShedding();

            return FutureBuilder<List<List<String>>>(
              future: minutelyAppliancesFuture,
              builder: (context, snapshotAppliances) {
                if (snapshotAppliances.connectionState ==
                    ConnectionState.waiting) {
                  return Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                } else if (snapshotAppliances.hasError) {
                  return Scaffold(
                      body: Center(
                          child: Text('Error: ${snapshotAppliances.error}')));
                }

                return FutureBuilder<List<List<int>>>(
                  future: loadSheddingScheduleFuture,
                  builder: (context, snapshotLoadShedding) {
                    if (snapshotLoadShedding.connectionState ==
                        ConnectionState.waiting) {
                      return Scaffold(
                          body: Center(child: CircularProgressIndicator()));
                    } else if (snapshotLoadShedding.hasError) {
                      return Scaffold(
                          body: Center(
                              child: Text(
                                  'Error: ${snapshotLoadShedding.error}')));
                    }

                    List<List<String>> minutelyAppliances =
                        snapshotAppliances.data!;
                    List<List<int>>? loadShedding = snapshotLoadShedding.data!;

                    return PredictionGraph(
                      maxOutput: maxOutput,
                      possibleStorage: possibleStorage,
                      hourlyKw: hourlyKw,
                      minutelyAppliances: minutelyAppliances,
                      loadShedding: loadShedding,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  static Future<List<Map<String, dynamic>>> finalOutputData(
      SystemDetails systemDetails) async {
    FinalOutputCalculation finalCalculation = FinalOutputCalculation(
      batterySize: systemDetails.batteryCapacity,
      lowestBatteryPercentage: systemDetails.lowestBatteryPercentage,
      maxPower: systemDetails.maxPowerOutput,
      userID: userId,
      firestore: firestore,
    );

    return await finalCalculation.calculateFinalOutput();
  }
}
