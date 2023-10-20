import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'qmBPwJo9VEc60GAqP5A62xz26YfT9VV5';
  final String endpoint = 'http://dataservice.accuweather.com/forecasts/v1/hourly/12hour/305448';

  Future<List<List<dynamic>>> fetchWeatherData() async {
    final response = await http.get(Uri.parse('$endpoint?apikey=$apiKey&language=en-us&details=true&metric=true'));

    if (response.statusCode == 200) {
      List<dynamic> rawData = json.decode(response.body);
      List<List<dynamic>> formattedData = [];

      for (var data in rawData) {
        String dateTime = data['DateTime'];
        String hour = DateTime.parse(dateTime).toLocal().hour.toString().padLeft(2, '0') + ":00";
        int cloudCover = data['CloudCover'];
        double solarIrradiance = data['SolarIrradiance']['Value'];

        formattedData.add([hour, cloudCover, solarIrradiance]);
      }

      return formattedData;
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
