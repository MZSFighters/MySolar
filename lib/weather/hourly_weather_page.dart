import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HourlyWeatherPage extends StatelessWidget {
  final List<dynamic> time;
  final List<dynamic> temperature;

  HourlyWeatherPage({required this.time, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hourly Weather'),
        centerTitle: true,
      ),
      body: HourlyWeatherWidget(time: time, temperature: temperature),
    );
  }
}

class HourlyWeatherWidget extends StatelessWidget {
  final List<dynamic> time;
  final List<dynamic> temperature;
  List<Widget>? hourlyCastTemp;
  List<Widget>? hourlyCastDate;

  HourlyWeatherWidget({required this.time, required this.temperature}) {
    final dateFormatter = DateFormat.MMMEd().add_jm();

    hourlyCastDate = time.map((e) {
      
      final dateTime = DateTime.parse(e);
      final formattedDate = dateFormatter.format(dateTime);

      return Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          formattedDate,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 18,
          ),
        ),
      );
    }).toList();

    String c = '°C';
    hourlyCastTemp = temperature.map((e) {
      return Padding(
        padding: EdgeInsets.all(10.0),
        child: Text(
          '$e' + c,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 18,
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        color: Colors.deepOrange[200],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: hourlyCastDate ?? [],
            ),
            Column(
              children: hourlyCastTemp ?? [],
            ),
          ],
        ),
      ),
    );
  }
}

