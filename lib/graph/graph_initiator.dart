////// need charles  to commit because this has to be changed////////
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mysolar/battery_output_calculation/finalOutputCalculation.dart';
import 'package:mysolar/graph/prediction_graph.dart';
import 'package:mysolar/load_shedding/fetch_today_schedule.dart';

class GraphInitiator extends StatelessWidget {
  //final energy usage :
  static Future<List<Map<String, dynamic>>> finalOutputData() async {
    List<double> consumptionData =
        List.generate(720, (index) => Random().nextDouble());

    FinalOutputCalculation finalCalculation = FinalOutputCalculation(
      batterySize: 8,
      lowestBatteryPercentage: 10,
      maxPower: 15.0,
      consumptionData: consumptionData,
    );

    List<Map<String, dynamic>> outputData =
        await finalCalculation.calculateFinalOutput();
    return outputData;
  }

  final double maxOutput = 15.00;
  final double possibleStorage = 8.00 * (1 - 10 / 100);
  final Future<List<Map<String, dynamic>>> outputData =
      GraphInitiator.finalOutputData();
  final Future<List<List<String>>> hourlyAppliancesFuture = Future.value([]);
  final Future<List<List<int>>> loadSheddingScheduleFuture =
      FetchTodaysLoadSheddingSchedule().getCurrentDayLoadShedding();

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
            future: hourlyAppliancesFuture,
            builder: (context, snapshotAppliances) {
              if (snapshotAppliances.connectionState ==
                  ConnectionState.waiting) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshotAppliances.hasError) {
                return Scaffold(
                  body:
                      Center(child: Text('Error: ${snapshotAppliances.error}')),
                );
              } else {
                return FutureBuilder<List<List<int>>>(
                  future: loadSheddingScheduleFuture,
                  builder: (context, snapshotLoadShedding) {
                    if (snapshotLoadShedding.connectionState ==
                        ConnectionState.waiting) {
                      return Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    } else if (snapshotLoadShedding.hasError) {
                      return Scaffold(
                        body: Center(
                            child:
                                Text('Error: ${snapshotLoadShedding.error}')),
                      );
                    } else {
                      List<Map<String, dynamic>> hourlyKw = snapshotKw.data!;
                      List<List<String>> hourlyAppliances =
                          snapshotAppliances.data!;
                      List<List<int>>? loadShedding =
                          snapshotLoadShedding.data!;
                      return PredictionGraph(
                        maxOutput: maxOutput,
                        possibleStorage: possibleStorage,
                        hourlyKw: hourlyKw,
                        hourlyAppliances: hourlyAppliances,
                        loadShedding: loadShedding,
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
