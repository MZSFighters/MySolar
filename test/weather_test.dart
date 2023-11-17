import 'package:flutter_test/flutter_test.dart';
import 'package:mysolar/weather/api_call.dart';
import 'package:mysolar/weather/models.dart';


void main() {
  group('Weather Tests', () { 
    test("API fetched data", () async{
      bool done = false;
      var result = await WeatherAPICall().request();
      if(result != null){
        done = true;
      }
      expect(done, true);
    });

    test('Test API response parsing into WeatherModel', () async {
      // Given
      final Map<String, dynamic> mockResponse = {
        "current_weather": {
          "temperature": 25.0,
          "weathercode": 3.0,
          "windspeed": 12.5,
          "winddirection": 180,
          "is_day": 1
        },
        "hourly": {
          "time": ["12:00", "1:00", "2:00"],
          "temperature_2m": [24.0, 25.0, 26.0]
        }
      };

      // When
      final currentWeatherData = mockResponse['current_weather'] as Map<String, dynamic>;
      final hourlyWeatherData = mockResponse['hourly'] as Map<String, dynamic>;

      final currentWeather = CurentWeather.fromJson(currentWeatherData);
      final hourlyWeather = HourlyWeather.fromJson(hourlyWeatherData);

      final weatherModel = WeatherModel(currentWeather: currentWeather, hourlyWeather: hourlyWeather);

      // Then
      expect(weatherModel.currentWeather.temperature, equals(25.0));
      expect(weatherModel.currentWeather.weathercode, equals(3.0));
      expect(weatherModel.currentWeather.windspeed, equals(12.5));
      expect(weatherModel.currentWeather.winddirection, equals(180));
      expect(weatherModel.currentWeather.isDay, equals(1));

      expect(weatherModel.hourlyWeather.time, equals(["12:00", "1:00", "2:00"]));
      expect(weatherModel.hourlyWeather.temperature, equals([24.0, 25.0, 26.0]));
    });
  });

}