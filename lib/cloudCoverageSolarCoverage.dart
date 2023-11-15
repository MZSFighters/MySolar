import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final String apiKey = 'gzkR8uiC9jtxj6iPnzjdq8RWEmBpt8qA';
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
      print(json.decode(response.body));
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
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              children: [
                // Headings
               Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '    Time',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),  // Adjust as needed
                        child: Text(
                          'Cloud \nCoverage (%)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),  // Adjust as needed
                        child: Text(
                          'Solar \nIrradiance (W/m^2)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Table
                Table(
                  border: TableBorder.all(),
                  columnWidths: {
                    0: FlexColumnWidth(0.65),
                    1: FlexColumnWidth(0.75),
                    2: FlexColumnWidth(1),
                  },
                  children: [
                    ...weatherData!.map((item) {
                      int cloudCover = item['CloudCover'];
                      double solarIrradiance = item['SolarIrradiance']['Value'];
                      String dateTime = item['DateTime'];
                      String hour = DateTime.parse(dateTime).toLocal().hour.toString().padLeft(2, '0');
                      return TableRow(children: [
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                '$hour:00',
                                style: TextStyle(fontSize: 18), 
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                '$cloudCover%',
                                style: TextStyle(fontSize: 18), 
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                '$solarIrradiance W/m²',
                                style: TextStyle(fontSize: 18), 
                              ),
                            ),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ],
                ),
              ],
            ),
          ),
  );
}
}


