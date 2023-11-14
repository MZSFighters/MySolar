import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class _RedSquarePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.3)
      ..strokeWidth = 4;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += 3) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class PredictionGraph extends StatelessWidget {
  final double maxOutput;
  final double possibleStorage;
  final List<Map<String, dynamic>> hourlyKw;
  final List<List<String>> minutelyAppliances;
  final List<List<int>> loadShedding;

  PredictionGraph({
    required this.maxOutput,
    required this.possibleStorage,
    required this.hourlyKw,
    required this.minutelyAppliances,
    required this.loadShedding,
  });

  @override
  Widget build(BuildContext context) {
    //*******************  MULTICOLOURING THE GRAPH ***************************/

    // compute blue colour for solar panel production and green for battery storage and grid use orange
    // here the graph shows in its display that solar panel power production is used only when the battery is full
    // When battery is full, the consumption uses both battery and solar
    // else it uses just battery

    // depending on maxOuput and possible storage , we have to adjust the y values visible on graph
    double yInterval = maxOutput + possibleStorage;
    double minY = -double.parse((yInterval).toStringAsFixed(0)) -
        3; //-3 for extra space to view down
    double maxY = double.parse((yInterval).toStringAsFixed(0)) +
        3; // give extra space to view top

    // find start hour
    String startHour = hourlyKw[0]['hour'];
    List<String> parts = startHour.split(':');
    int startMinutes = int.parse(parts[0]) * 60; // our minx which is 0
    // print(startMinutes);
    // print(loadShedding);

    //adjust loadshedding time list to show on our graph x axis from 0 to 719 correctly

    List<List<int>> adjusted = [];
    if (loadShedding.length >= 1) {
      for (int i = 0; i < loadShedding.length; i++) {
        int start = loadShedding[i][0];
        int end = loadShedding[i][1];

        if (start < end) {
          adjusted.add([start - startMinutes, end - startMinutes]);
        } else {
          adjusted.add(
              [start - startMinutes, end + 1440 - startMinutes]); //next day
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Prediction Graph'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Title
            Text(
              "Predicted Solar Panel Power, Battery Power and Grid Usage",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            // Key for Battery Usage
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.green,
                ),
                SizedBox(width: 10),
                Text("- Battery Power (kW)"),
                SizedBox(width: 20),
                Container(
                  width: 20,
                  height: 40,
                  child: CustomPaint(
                    painter: _RedSquarePainter(),
                  ),
                ),
                SizedBox(width: 10),
                Text("- Load Shedding"),
              ],
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.orange,
                ),
                SizedBox(width: 10),
                Text("- Grid Usage (kW)"),
              ],
            ),
            SizedBox(height: 10),
            // Key for Grid Usage
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  color: Colors.blue,
                ),
                SizedBox(width: 10),
                Text("- Solar Panel Power (kW)"),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Container(
                          width: 12 * 60.0, // 12 data points * 60 pixels each
                          child: LineChart(
                            LineChartData(
                              minX: 0,
                              maxX: 719.0,
                              minY: minY,
                              maxY: maxY,
                              gridData: FlGridData(
                                  show: true,
                                  getDrawingHorizontalLine: (value) {
                                    if (value == 0) {
                                      return FlLine(
                                        color: Colors.black,
                                        strokeWidth: 1,
                                      );
                                    }
                                    return FlLine(
                                      color: Colors.transparent,
                                      strokeWidth: 0,
                                    );
                                  },
                                  drawVerticalLine: true,
                                  getDrawingVerticalLine: (value) {
                                    /// load shedding shading
                                    for (int i = 0; i < adjusted.length; i++) {
                                      int start = adjusted[i][0];
                                      int end = adjusted[i][1];
                                      if (value >= start && value <= end) {
                                        // x value lies between adjusted values
                                        return FlLine(
                                          color: Colors.red.withOpacity(0.3),
                                          strokeWidth: 4,
                                        );
                                      }
                                    }
                                    return FlLine(
                                      color: Colors.transparent,
                                      strokeWidth: 0,
                                    );
                                  }),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 22,
                                  interval: 60,
                                  getTextStyles: (context, value) =>
                                      const TextStyle(
                                    color: Color(0xff68737d),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  getTitles: (value) {
                                    if (value % 60 == 0) {
                                      return hourlyKw[(value ~/ 60).toInt()]
                                          ['hour'];
                                    } else {
                                      return '';
                                    }
                                  },
                                  margin: 8,
                                ),
                                leftTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 60,
                                  getTextStyles: (context, value) =>
                                      const TextStyle(
                                    color: Color(0xff67727d),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  getTitles: (value) {
                                    // display every 3 kw ?
                                    final interval = 3.0;

                                    final numberOfIntervals =
                                        (yInterval / interval).ceil();

                                    for (int i = 0;
                                        i <= numberOfIntervals;
                                        i++) {
                                      if (value == i * interval) {
                                        return '${i * interval}kw';
                                      }
                                    }
                                    // negative values
                                    for (int i = 1;
                                        i <= numberOfIntervals;
                                        i++) {
                                      if (value == -i * interval) {
                                        return '-${i * interval}kw';
                                      }
                                    }

                                    return '';
                                  },
                                  margin: 12,
                                ),
                              ),
                              borderData: FlBorderData(
                                show: true,
                                border: Border.all(
                                    color: const Color(0xff37434d), width: 1),
                              ),
                              lineTouchData: LineTouchData(
                                touchSpotThreshold: 1,
                                touchTooltipData: LineTouchTooltipData(
                                  getTooltipItems:
                                      (List<LineBarSpot> touchedBarSpots) {
                                    return touchedBarSpots.map((barSpot) {
                                      final flSpot = barSpot;
                                      // if (flSpot.y == possibleStorage) {
                                      //   return null;  // dont show tooltip for spots where blue is above
                                      // }
                                      final appliancesForMinute =
                                          minutelyAppliances[flSpot.x.toInt()]
                                              .join(', ');
                                      return LineTooltipItem(
                                        '${flSpot.y}kw \n Appliances used: $appliancesForMinute ', //\nAppliances used: $appliancesForHour',
                                        const TextStyle(color: Colors.white),
                                      );
                                    }).toList();
                                  },
                                ),
                                getTouchedSpotIndicator:
                                    (LineChartBarData barData,
                                        List<int> indicators) {
                                  return indicators.map((int index) {
                                    // final spot = barData.spots[index];

                                    // if (spot.y == possibleStorage) { //the behaviour for spots not clickable/ underneath blue
                                    //   return null;
                                    // }
                                    // the default behaviour for spots that are clickable
                                    return TouchedSpotIndicatorData(
                                        FlLine(
                                            color: Colors.blue, strokeWidth: 4),
                                        FlDotData(getDotPainter:
                                            (spot, percent, barData, index) {
                                      return FlDotCirclePainter(
                                        radius: 8,
                                        color: Colors.white,
                                        strokeWidth: 2,
                                        strokeColor: Colors.blue,
                                      );
                                    }));
                                  }).toList();
                                },
                                touchCallback:
                                    (LineTouchResponse touchResponse) {},
                                handleBuiltInTouches: true,
                              ),
                              lineBarsData: [
                                createLineChartBarData(generateData(), 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> generateData() {
    List<FlSpot> data = [];
    int minuteCounter = 0;

    for (int i = 0; i < hourlyKw.length; i++) {
      List<double> outputKwForHour = hourlyKw[i]['outputKw'];

      for (int j = 0; j < outputKwForHour.length; j++) {
        data.add(FlSpot(minuteCounter.toDouble(), outputKwForHour[j]));
        minuteCounter++;
      }
    }
    return data;
  }

  LineChartBarData createLineChartBarData(List<FlSpot> spots, double cutOffY) {
    // Determine the colors for the spots based on the Y value
    List<Color> colours = spots.map((spot) {
      if (spot.y > possibleStorage) {
        return Colors.blue.withOpacity(0.8);
      } else if (spot.y >= 0) {
        return Colors.green.withOpacity(0.8);
      } else {
        return Colors.orange.withOpacity(0.8);
      }
    }).toList();

    // Create the LineChartBarData
    return LineChartBarData(
      spots: spots,
      isCurved: false,
      colors: colours,
      barWidth: 3,
      isStrokeCapRound: true,
      // belowBarData: BarAreaData(
      //   show: true,
      //   colors: colours,
      //   cutOffY: cutOffY,
      //   applyCutOffY: true,
      // ),
      // aboveBarData: BarAreaData(
      //   show: true,
      //   colors: colours,
      //   cutOffY: cutOffY,
      //   applyCutOffY: true,
      // ),
      dotData: FlDotData(show: false),
    );
  }
}
