import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BatteryGraphDisplay extends StatelessWidget {
  final double batterySize;
  final List<Map<String, dynamic>> hourlyKw;
  final List<List<String>> hourlyAppliances;

  BatteryGraphDisplay({
    required this.batterySize,
    required this.hourlyKw,
    required this.hourlyAppliances,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Usage Graph'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
         child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: <Widget>[
      // Title
      Text(
        "Predicted Battery Power And Grid Usage",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 10), // Spacing
      // Key for Battery Usage
      Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: Colors.green,
          ),
          SizedBox(width: 10), // Spacing between the square and the text
          Text("- Battery Power (kW)"),
        ],
      ),
      SizedBox(height: 10), // Spacing
      // Key for Grid Usage
      Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: Colors.orange,
          ),
          SizedBox(width: 10), // Spacing between the square and the text
          Text("- Grid Usage"),
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
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            interval: 1,
                            getTextStyles: (context, value) => const TextStyle(
                              color: Color(0xff68737d),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            getTitles: (value) {
                              return hourlyKw[value.toInt()]['hour'];
                            },
                            margin: 8,
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 40,
                            getTextStyles: (context, value) => const TextStyle(
                              color: Color(0xff67727d),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            getTitles: (value) {
                              switch (value.toInt()) {
                                case 10:
                                  return '10kw';
                                case 5:
                                  return '5kw';
                                case 0:
                                  return '0kw';
                                case -5:
                                  return '-5kw';
                                case -10:
                                  return '-10kw';
                                default:
                                  return '';
                              }
                            },
                            margin: 12,
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border.all(
                              color: const Color(0xff37434d), width: 1),
                        ),
                        minX: 0,
                        maxX: 11.5,
                        minY: -14,
                        maxY: 14,
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Colors.blueAccent,
                            getTooltipItems:
                                (List<LineBarSpot> touchedBarSpots) {
                              return touchedBarSpots.map((barSpot) {
                                final flSpot = barSpot;
                                final appliancesForHour =
                                    hourlyAppliances[flSpot.x.toInt()]
                                        .join(', ');
                                return LineTooltipItem(
                                  '${flSpot.y}kw\nAppliances used: $appliancesForHour',
                                  const TextStyle(color: Colors.white),
                                );
                              }).toList();
                            },
                          ),
                          touchCallback: (LineTouchResponse touchResponse) {},
                          handleBuiltInTouches: true,
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: generateData(),
                            isCurved: true,
                            colors: [Colors.black.withOpacity(0.5)],
                            barWidth: 4,
                            isStrokeCapRound: true,
                            aboveBarData: BarAreaData(
                              show: true,
                              colors: generateData()
                                  .map((spot) => spot.y < 0
                                      ? Colors.orange.withOpacity(0.8)
                                      : Colors.transparent)
                                  .toList(),
                              cutOffY: 0.0,
                              applyCutOffY: true,
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              colors: generateData()
                                  .map((spot) => spot.y >= 0
                                      ? Colors.green.withOpacity(0.8)
                                      : Colors.transparent)
                                  .toList(),
                              cutOffY: 0.0,
                              applyCutOffY: true,
                            ),
                            dotData: FlDotData(show: true),
                          ),
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
    for (int i = 0; i < 12; i++) {
      data.add(FlSpot(i.toDouble(), hourlyKw[i]['outputKw']));
    }
    return data;
  }
}
