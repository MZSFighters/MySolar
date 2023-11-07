////// need charles  to commit because this has to be changed////////
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mysolar/battery_output_calculation/finalOutputCalculation.dart';
import 'package:mysolar/graph/prediction_graph.dart';
import 'package:mysolar/load_shedding/fetch_today_schedule.dart';
import 'package:mysolar/device_consumption_and_use/deviceConsumption.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mysolar/models/device.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

final FirebaseAuth auth = FirebaseAuth.instance;

final User? user = auth.currentUser;

final String userId = user!.uid;



class GraphInitiator extends StatelessWidget {

  //final energy usage :
  static Future<List<Map<String, dynamic>>> finalOutputData() async {  
    //List<double> consumptionData = List.generate(720, (index) => Random().nextDouble());
   

    FinalOutputCalculation finalCalculation = FinalOutputCalculation(
      batterySize: 5.00, 
      lowestBatteryPercentage: 10, 
      maxPower: 10.0, 
      userID: userId,
      firestore: firestore,
    );

    List<Map<String, dynamic>> outputData = await finalCalculation.calculateFinalOutput();
    return outputData;
  }

  final double maxOutput = 10.00;
  final double possibleStorage = 5.00 * (1 - 10/100);
  final Future<List<Map<String, dynamic>>> outputData = GraphInitiator.finalOutputData();
  final Future<List<List<String>>> minutelyAppliancesFuture = DeviceConsumption(userId: userId, firestore: firestore).devicesOnEachMinute();
  final Future<List<List<int>>> loadSheddingScheduleFuture = FetchTodaysLoadSheddingSchedule().getCurrentDayLoadShedding();



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: outputData,
      builder: (context, snapshotKw) {
        if (snapshotKw.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshotKw.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshotKw.error}')),
          );
        } else {
              return FutureBuilder<List<List<String>>>(
                future: minutelyAppliancesFuture,
                builder: (context, snapshotAppliances) {
                  if (snapshotAppliances.connectionState == ConnectionState.waiting) {
                    return Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshotAppliances.hasError) {
                    return Scaffold(
                      body: Center(child: Text('Error: ${snapshotAppliances.error}')),
                    );
                  } else {
                          return FutureBuilder<List<List<int>>>(
                            future: loadSheddingScheduleFuture,
                            builder: (context, snapshotLoadShedding) {
                              if (snapshotLoadShedding.connectionState == ConnectionState.waiting) {
                                return Scaffold(
                                  body: Center(child: CircularProgressIndicator()),
                                );
                              } else if (snapshotLoadShedding.hasError) {
                                return Scaffold(
                                  body: Center(child: Text('Error: ${snapshotLoadShedding.error}')),
                                );
                              }else { 
                                  List<Map<String, dynamic>> hourlyKw = snapshotKw.data!;
                                  List<List<String>> minutelyAppliances = snapshotAppliances.data!;
                                  List<List<int>>? loadShedding = snapshotLoadShedding.data!;
                                  return PredictionGraph(
                                    maxOutput: maxOutput,
                                    possibleStorage: possibleStorage,
                                    hourlyKw: hourlyKw,
                                    minutelyAppliances: minutelyAppliances,
                                    loadShedding:loadShedding,
                                  ); 
                                }
                              },
                            );
                          }
                        },
                      );
                    }
                  },
                );
              }
            }