import 'solarPowerProduced.dart';

class FinalOutputCalculation {
  final double batterySize;
  final int lowestBatteryPercentage;
  final double maxPower;
  final List<double> consumptionData;

  FinalOutputCalculation({
    required this.batterySize,
    required this.lowestBatteryPercentage,
    required this.maxPower,
    required this.consumptionData,
  });

  Future<List<Map<String, dynamic>>> calculateFinalOutput() async {
    SolarPowerProduced solarPower = SolarPowerProduced(maxOutput: maxPower);
    List<Map<String, dynamic>> solarOutputData = await solarPower.calculateSolarOutput();

    List<Map<String, dynamic>> finalOutput = [];
    double possibleStorage = (1 -(lowestBatteryPercentage / 100.0)) * batterySize;
    double batteryStorageKw = 0;
    for (int i = 0; i < 12; i++) {
      double solarOutputForHour = double.parse(solarOutputData[i]['solarOutput'].toStringAsFixed(2));
      double calculation = double.parse((solarOutputForHour - consumptionData[i]).toStringAsFixed(2));
      if ((batteryStorageKw+calculation) >= possibleStorage ) { //if what will be in the battery > then what it can store:
        batteryStorageKw = possibleStorage;
      } else {
        batteryStorageKw += calculation;  //only add calculation if it will not exceed possible storage
      }

      finalOutput.add({
        'hour': solarOutputData[i]['hour'],
        'outputKw': batteryStorageKw,
      });
    }

    return finalOutput;
  }
}
