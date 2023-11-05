import 'package:test/test.dart';
import 'package:mysolar/battery_output_calculation/solarPowerProduced.dart';

void main() {
  group('SolarPowerProduced', () {
    test('calculates solar output correctly', () async {
      // Arrange
      final solarPowerProduced = SolarPowerProduced(maxOutput: 10.0);
      // Mock weather data
      final List<List<dynamic>> mockWeatherData = [
        ['06:00', 20, 500.0], // Hour, Cloud Cover %, Solar Irradiance
        ['12:00', 10, 1000.0],
        // ... add more mock data if needed
      ];

      // Act
      final result = await solarPowerProduced.calculateSolarOutput(mockWeatherData); 

      // Assert
      expect(result, [
        {
          'hour': '06:00',
          'solarOutput': 10.0 * (1 - (20 / 100)) * (500.0 / 1000.0),
        },
        {
          'hour': '12:00',
          'solarOutput': 10.0 * (1 - (10 / 100)) * (1000.0 / 1000.0),
        },
      ]);
    });
  });
}
