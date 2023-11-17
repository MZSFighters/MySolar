import 'dart:convert';
import 'package:dio/dio.dart';
import 'models.dart';

class WeatherAPICall{

  Future<WeatherModel> request() async {
    String url = "http://api.open-meteo.com/v1/forecast?latitude=-26.2041&longitude=28.0473&current_weather=true&hourly=temperature_2m,relativehumidity_2m,windspeed_10m";
    final dio = Dio();
    final response = await dio.get(url);
    final purseData = jsonDecode(response.toString());
    final weather = WeatherModel.fromJson(purseData);

    return weather;

  }
}
