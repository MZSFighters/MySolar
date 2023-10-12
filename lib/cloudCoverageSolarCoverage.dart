import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String apiKey = 'cLTcCVlnbyykGMZwuxRBsa32G9sv76rG';
  final String endpoint = 'http://dataservice.accuweather.com/forecasts/v1/hourly/12hour/305448';

  List<dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeatherData().then((data) {
      setState(() {
        weatherData = data;
      });
    });
  }

  Future<List<dynamic>> fetchWeatherData() async {
    final response = await http.get(Uri.parse('$endpoint?apikey=$apiKey&language=en-us&details=true&metric=true'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Weather Data')),
      body: weatherData == null
          ? Center(child: CircularProgressIndicator()) // loading indicator
          : ListView.builder(
              itemCount: weatherData!.length,
              itemBuilder: (context, index) {
                int cloudCover = weatherData![index]['CloudCover'];
                double solarIrradiance = weatherData![index]['SolarIrradiance']['Value'];
                String dateTime = weatherData![index]['DateTime'];
                return ListTile(
                  title: Text('Time: $dateTime'),
                  subtitle: Text('Cloud Cover: $cloudCover%, Solar Irradiance: $solarIrradiance W/m²'),
                );
              },
            ),
    );
  }
}

