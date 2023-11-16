import 'solarPowerProduced.dart';
import 'fetchWeatherData.dart';
import 'package:mysolar/device_consumption_and_use/deviceConsumption.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FinalOutputCalculation {
  final double batterySize;
  final double lowestBatteryPercentage;
  final double maxPower;
  final String userID;
  final FirebaseFirestore firestore;

  FinalOutputCalculation({
    required this.batterySize,
    required this.lowestBatteryPercentage,
    required this.maxPower,
    required this.userID,
    required this.firestore,
  });

  Future<List<Map<String, dynamic>>> calculateFinalOutput() async {
    WeatherService weatherService = WeatherService();
    List<List<dynamic>> weatherData = await weatherService.fetchWeatherData();

    SolarPowerProduced solarPower = SolarPowerProduced(maxOutput: maxPower);
    List<Map<String, dynamic>> solarOutputData = await solarPower.calculateSolarOutput(weatherData);

    int apiHour = int.parse(solarOutputData[0]['hour'].split(':')[0]);
  

    List<double> consumptionPerMinute =
        await DeviceConsumption().calculateMinuteConsumption(apiHour);

    List<Map<String, dynamic>> finalOutput = [];

    double possibleStorage = (1 - (lowestBatteryPercentage / 100.0)) *
        batterySize; // the possible battery storage
    double batteryStorage = 0.00;

    for (int a = 0; a < 12; a++) {
      // for each hour

      // SolarPanelOutputForHour is the solar panel system power production in kW.
      double solarPanelOutputForHour = double.parse(solarOutputData[a]
              ['solarOutput']
          .toStringAsFixed(3)); // 3 decimal places

      /**************************************************************************************/
      // There is the potential here to  add logic that distributes solarPanelOutputForHour (the solar panel production), according to a user's inverter system
      // Some can go to battery storage whilst some can be used directly for consumptionData
      // We have decided to not implement this logic.
      // Instead, the distribution specified here, is that the battery is filled to its possible storage, and used to feed the house.
      // Only, when the battery is full, does solarOutputForHour (the solar panel production) feed the house as well.
      /**************************************************************************************/

      /////// Our Inverter Algorithm //////

      if (batteryStorage < possibleStorage) {
        //if availabe battery storage
        if (solarPanelOutputForHour <= possibleStorage) {
          batteryStorage += solarPanelOutputForHour; //feed battery first

          solarPanelOutputForHour = solarPanelOutputForHour -
              batteryStorage; //decrease the solar panel power
        } else {
          batteryStorage =
              possibleStorage; // this feed will fill up battery storage

          solarPanelOutputForHour = solarPanelOutputForHour -
              batteryStorage; //decrease the solar panel power
        }
      } else {
        batteryStorage =
            possibleStorage; // else battery is already full, and nothing chages to solarPanelOutputForHour
      }

      List<double> hourlyOutput = [];
      // double remainderAfterSolar = 0.0;

      /////  Algorithm to calculate the final output in kw/hr , considering depleting battery and solar power and consumption usage ////

      for (int i = a * 60; i < (a + 1) * 60; i++) {
        // for each minute in that hour

        // battery must only decrease when we have used solarPanelOutputForHour up

        if (solarPanelOutputForHour < 0) {
          double value = batteryStorage - consumptionPerMinute[i];
          batteryStorage -= consumptionPerMinute[i];
          if (batteryStorage >= 0) {
            hourlyOutput.add(batteryStorage);
          } else {
            //it became less than 0
            batteryStorage = 0.0;
            hourlyOutput.add(value); // using grid
          }
        } else {
          solarPanelOutputForHour -=
              consumptionPerMinute[i]; //use solar panel when there still is
          if (solarPanelOutputForHour < 0) {
            // it became less than 0
            batteryStorage += solarPanelOutputForHour;
            hourlyOutput.add(batteryStorage);
            if (batteryStorage < 0) {
              // if this made or battery storage go less than zero
              batteryStorage = 0; // set battery to 0
            }
          } else {
            // still left
            hourlyOutput.add(solarPanelOutputForHour + batteryStorage);
          }
        }
      }

      List<double> minutelyOutput = hourlyOutput.map((value) {
        return double.parse(value.toStringAsFixed(3));
      }).toList();

      finalOutput.add({
        'hour': solarOutputData[a]['hour'],
        'outputKw': minutelyOutput,
      });
    }
    return finalOutput;
  }
}
