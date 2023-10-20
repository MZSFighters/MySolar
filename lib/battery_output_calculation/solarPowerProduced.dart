import 'fetchWeatherData.dart';

class SolarPowerProduced {
  final double maxOutput; // maximum output in kW/hr

  SolarPowerProduced({required this.maxOutput});

  Future<List<Map<String, dynamic>>> calculateSolarOutput() async {
    WeatherService weatherService = WeatherService();
    List<List<dynamic>> weatherData = await weatherService.fetchWeatherData();

    List<Map<String, dynamic>> solarOutputData = [];

    for (var data in weatherData) {
      String hour = data[0];
      int cloudCover = data[1];
      double solarIrradiance = data[2];
      // print('cloud cover -  $cloudCover');
      // print('solar - irradiance - $solarIrradiance');

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
