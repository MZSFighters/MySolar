import 'package:flutter/material.dart';

class WeatherModel {
  final currentWeather;
  final hourlyWeather;

  WeatherModel({required this.currentWeather, required this.hourlyWeather});

  factory WeatherModel.fromJson(Map<String, dynamic> data) {
    final currentWeather = data["current_weather"] as Map<String, dynamic>;
    final hourlyWeather = data["hourly"] as Map<String, dynamic>;

    return WeatherModel(
        currentWeather: currentWeather, hourlyWeather: hourlyWeather);
  }
}

class CurentWeather {
  final double temperature;
  final double weathercode;
  final double windspeed;
  final int winddirection;
  final int isDay;

  CurentWeather(
      {required this.temperature,
      required this.weathercode,
      required this.winddirection,
      required this.windspeed,
      required this.isDay});

  factory CurentWeather.fromJson(Map<String, dynamic> data) {
    final temperature = data["temperature"] as double;
    final weathercode = data["weathercode"] as double;
    final windspeed = data["windspeed"] as double;
    final winddirection = data["winddirection"] as int;
    final isDay = data["is_day"] as int;

    return CurentWeather(
        temperature: temperature,
        weathercode: weathercode,
        winddirection: winddirection,
        windspeed: windspeed,
        isDay: isDay);
  }
}

class HourlyWeather {
  final List<String> time;
  final List<double> temperature;

  HourlyWeather({required this.time, required this.temperature});

  factory HourlyWeather.fromJson(Map<String, dynamic> data) {
    final List<String> time = data["time"] as List<String>;
    final List<double> temperature = data["temperature_2m"] as List<double>;

    return HourlyWeather(time: time, temperature: temperature);
  }
}
