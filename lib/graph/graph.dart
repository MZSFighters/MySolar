import 'package:flutter/material.dart';
import 'package:mysolar/graph/graphDisplay.dart';

class BatteryGraph extends StatelessWidget {
  final double maxOutput;
  final double possibleStorage;
  final Future<List<Map<String, dynamic>>> hourlyKwFuture;
  final Future<List<List<String>>> hourlyAppliancesFuture;

  BatteryGraph({
    required this.maxOutput,
    required this.possibleStorage,
    required this.hourlyKwFuture,
    required this.hourlyAppliancesFuture,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: hourlyKwFuture,
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
              if (snapshotAppliances.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshotAppliances.hasError) {
                return Scaffold(
                  body: Center(child: Text('Error: ${snapshotAppliances.error}')),
                );
              } else {
                List<Map<String, dynamic>> hourlyKw = snapshotKw.data!;
                List<List<String>> hourlyAppliances = snapshotAppliances.data!;
                return BatteryGraphDisplay(maxOutput: maxOutput,possibleStorage: possibleStorage, hourlyKw: hourlyKw, hourlyAppliances: hourlyAppliances); 
              }
            },
          );
        }
      },
    );
  }
}


