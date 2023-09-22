import 'package:flutter/material.dart';
import 'package:mysolar/weather/api_call.dart';
import 'package:mysolar/weather/current_weather_widget.dart';
import 'package:mysolar/weather/hourly_weather_page.dart';
import 'package:mysolar/weather/models.dart';
import 'package:intl/intl.dart';

class CurrentWeatherPage extends StatefulWidget {
  @override
  _CurrentWeatherPageState createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  WeatherModel? weatherModel;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Page'),
        centerTitle: true,
        
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    // Running the request to fetch  weather data from the api
                    weatherModel = await WeatherAPICall().request();
                    print("pressed");
                    //print(weatherModel!.hourlyWeather["temperature_2m"]);
                    //print(weatherModel!.hourlyWeather["time"]);
                    setState(() {}); // Trigger a UI update after fetching data
                  },
                  child: const Text('Refresh'),
                ),
          
                // Calling the Location and Time widget, So that we can display the time and location
                Location_Date_Widget(),
          
                if (weatherModel == null) 
                const Center(
                  child: CircularProgressIndicator(),
                  ),
          
                if (weatherModel != null)
                  CurrentWeatherWidget(
                    temperature: weatherModel!.currentWeather["temperature"],
                    weatherCode: weatherModel!.currentWeather["weathercode"],
                    windspeed: weatherModel!.currentWeather["windspeed"],
                    winddirection: weatherModel!.currentWeather["winddirection"],
                    isDay: weatherModel!.currentWeather["is_day"],
                  ),
                
                const SizedBox(height: 30,),

                if (weatherModel != null)
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HourlyWeatherPage(
                            time: weatherModel!.hourlyWeather["time"],
                            temperature: weatherModel!.hourlyWeather["temperature_2m"],
                          ),
                        ),
                      );
                    },
                    child: Text('More'),
                  ),
                       
              ],
            ),
          ),
        
      ),
    );
  }
}




class Location_Date_Widget extends StatelessWidget {

  String city = "Johannesburg";

  String date = DateFormat.MMMMEEEEd().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.center,
          child: Text(
            city,
            style: TextStyle(
              fontSize: 35,
              height: 2,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20, right: 20),
          alignment: Alignment.center,
          child: Text(
            date,
            style: TextStyle(
              fontSize: 20,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),
        ),
        
      ],
    );
  }
}