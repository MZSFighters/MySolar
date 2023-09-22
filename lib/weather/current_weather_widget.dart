import 'package:flutter/material.dart';

class CurrentWeatherWidget extends StatelessWidget {
  final dynamic temperature;
  final dynamic weatherCode;
  dynamic windspeed;
  final dynamic winddirection;
  final dynamic isDay;

  CurrentWeatherWidget({required this.temperature, required this.weatherCode, required this.winddirection, required this.windspeed, required this.isDay});

  String getImagePathForWeatherCode(int code, int isDay) {
    if (code == 0) {
      if (isDay == 1){
        return 'assets/icons/sun.png';
      }
      else{
        return 'assets/icons/clear-night.png';
      }  
    } 
    else if (code == 1 || code == 2 || code == 3) {
      if (isDay == 1){
        return 'assets/icons/overcast.png';
      }
      else{
        return 'assets/icons/night.png';
      }
    } 
    else if (code == 45 || code == 48) {
      if (isDay == 1){
        return 'assets/icons/fog.png';
      }
      else{
        return 'assets/icons/foggy-night.png';
      }
    } 
    else if (code >= 95) {
      if (isDay == 1){
        return 'assets/icons/thunderstorm.png';
      }
      else{
        return 'assets/icons/stormy-night.png';
      }
    } 
    else if (code == 71 || code == 73 || code == 75 || code == 77 || code == 85 || code == 86) {
      return 'assets/icons/snow.png';
    } 
    else {
      if (isDay == 1) {
        return 'assets/icons/rain.png';
        }
        else{
          return 'assets/icons/rainy-night.png';
        }
      
    }
  }

  @override
  Widget build(BuildContext context) {

    final imagePath = getImagePathForWeatherCode(weatherCode, isDay);
    
    // convering the wind speed from miles to kilometers and then rounding off the final speed
    windspeed = windspeed*1.6.round();


    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              imagePath,
              width: 100,
              height: 130,
            ),
            Container(
              height: 50,
              width: 1,
              color: Colors.black,
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${temperature.toStringAsFixed(0)}°C',
                    style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    color: Colors.grey[700],
                    )
                  )
                ]
              )
            )
          ],
        ),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/wind.png',
              width: 80,
              height: 80,
            ),
            
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${windspeed.toString()} km/h',
                    style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    color: Colors.grey[700],
                    )
                  )
                ]
              )
            )
          ],
        ),

        Text(
          'Wind Direction: ${winddirection.toString()}',
          style: TextStyle(
            fontSize: 20,
            height: 1.5,
            color: Colors.grey[700],),
        ),
      ],
    );
  }
}
