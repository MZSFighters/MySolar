import 'package:flutter/material.dart';
import 'package:mysolar/weather/api_call.dart';
import 'package:mysolar/weather/current_forecast.dart';
import 'package:mysolar/weather/hourly_weather_page.dart';
import 'package:mysolar/weather/models.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherModel? weatherModel;

  void doRequest() async{
    weatherModel = await WeatherAPICall().request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        centerTitle: true,
        
      ),
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
          
                ElevatedButton(
                  onPressed: () {
                    print("pressed");
                    // Running api call to fetch weather data before switching to weather page
                    doRequest();
                    print(weatherModel);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CurrentWeatherPage(),
                      ),
                    );
                  },
                  child: Text('Weather Page'),
                
                )   
            ],
          ),
        
      ),
    );
  }
}
