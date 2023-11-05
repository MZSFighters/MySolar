import 'fetchWeatherData.dart';

class SolarPowerProduced {
  final double maxOutput; // maximum output in kW/hr
  

  SolarPowerProduced({required this.maxOutput});

  Future<List<Map<String, dynamic>>> calculateSolarOutput(List<List<dynamic>> weatherData) async {

    List<Map<String, dynamic>> solarOutputData = [];

    for (var data in weatherData) { // for each hour in weather data
      String hour = data[0];
      int cloudCover = data[1];
      double solarIrradiance = data[2];

      double standardIrradiance = 1000.0; // solar irradiance on a clear day at noon
      
      double solarOutput = maxOutput * (1 - (cloudCover / 100)) * (solarIrradiance / standardIrradiance);

      solarOutputData.add({
        'hour': hour,
        'solarOutput': solarOutput, 
      });
    }
    return solarOutputData;
  }
}
