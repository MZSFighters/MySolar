import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BatteryGraphDisplay extends StatelessWidget {
  final double maxOutput;
  final double possibleStorage;
  final List<Map<String, dynamic>> hourlyKw;
  final List<List<String>> hourlyAppliances;

  BatteryGraphDisplay({
    required this.maxOutput,
    required this.possibleStorage,
    required this.hourlyKw,
    required this.hourlyAppliances,
  });

  @override
  Widget build(BuildContext context) {

    //*******************  MULTICOLOURING THE GRAPH ***************************/

    // compute blue colour for solar panel production and green for battery storage and grid use orange
    // here the graph shows in its display that solar panel power production is used only when the battery is full
    // When battery is full, the consumption uses both battery and solar 
    // else it uses just battery

  List<FlSpot> spotsAboveStorage = []; // the area below will be blue 
  List<FlSpot> spotsBelowStorage = []; //but above zero   // the area below will be green
  List<FlSpot> gridSpots = [];  // the area above will be orange


    for (var spot in generateData()) {
      if (spot.y >= possibleStorage) {
        spotsAboveStorage.add(spot);
        spotsBelowStorage.add(FlSpot(spot.x, possibleStorage)); //still exists below storage //these spots should not be clickable
      } else if (spot.y < possibleStorage && spot.y >= 0){
        spotsBelowStorage.add(spot);
      } else {
        gridSpots.add(spot);
      }
    }


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
                        minY: -double.parse(maxOutput.toStringAsFixed(0)) - 3,
                        maxY: double.parse(maxOutput.toStringAsFixed(0)) + 3, // give extra space to view top
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
                            interval: 60,
                            getTextStyles: (context, value) => const TextStyle(
                              color: Color(0xff68737d),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                             getTitles: (value) {
                            if (value % 60 == 0) {
                              return hourlyKw[(value ~/ 60).toInt()]['hour'];
                              }else {
                                return '';
                              }

                          },
                          margin: 8,
                          ),
                          leftTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 60,
                            getTextStyles: (context, value) => const TextStyle(
                              color: Color(0xff67727d),
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                            getTitles: (value) {
                              // display every 3 kw ?
                              final interval = 3.0;

                    
                              final numberOfIntervals = (maxOutput / interval).ceil();

                              for (int i = 0; i <= numberOfIntervals; i++) {
                                if (value == i * interval) {
                                  return '${i * interval}kw';
                                }
                              }
                              // negative values
                              for (int i = 1; i <= numberOfIntervals; i++) {
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
                                                          // Check if the touched spot is in the set of unclickable spots
                                            if (flSpot.y == possibleStorage) {
                                              return null;  // Return null to prevent tooltip from showing
                                            }
                                                  // final appliancesForHour =
                                                  //     hourlyAppliances[flSpot.x.toInt()]
                                                  //         .join(', ');
                                                  return LineTooltipItem(
                                                     '${flSpot.y}kw', //\nAppliances used: $appliancesForHour',
                                                    const TextStyle(color: Colors.white),
                                                  );
                                                }).toList();
                                              },
    //                                               getLineBarSpots: (touchedSpots) {
    //   return touchedSpots.where((spot) => spot.y != possibleStorage).toList();
    // },
                
                          ),
getTouchedSpotIndicator: (LineChartBarData barData, List<int> indicators) {
  return indicators.map((int index) {
    // Get the actual spot using the index
    final spot = barData.spots[index];

    if (spot.y == possibleStorage) {
      return null;  // Return null to prevent indicator from showing
    }

    // Default behavior for other spots
    return TouchedSpotIndicatorData(
      FlLine(color: Colors.blue, strokeWidth: 4),
      FlDotData(getDotPainter: (spot, percent, barData, index) {
        return FlDotCirclePainter(
          radius: 8,
          color: Colors.white,
          strokeWidth: 2,
          strokeColor: Colors.blue,
        );
      })
    );
  }).toList();
},



                          touchCallback: (LineTouchResponse touchResponse) {
                          },
                          
                          handleBuiltInTouches: true,
                          
                        ),


                        lineBarsData: [
                          LineChartBarData(
                            spots: gridSpots,
                            isCurved: true,
                            colors: [Colors.black.withOpacity(0.5)],
                            barWidth: 0.2,
                            isStrokeCapRound: true,
                            aboveBarData: BarAreaData(
                              show: true,
                              colors: [Colors.orange.withOpacity(0.8)],
                              // colors: generateData()
                              //     .map((spot) => spot.y < 0.000
                              //         ? Colors.orange.withOpacity(0.8)
                              //         : Colors.transparent)
                              //     .toList(),
                              cutOffY: 0.0,
                              applyCutOffY: true,
                            ),
                          //   belowBarData: BarAreaData(     /// the distuingishing between solar and battery is implemented here 
                          //     show: true,
                          //     colors: belowBarColors,
                          //     cutOffY: cutOffYValue,
                          //     applyCutOffY: true,
                          // ),
                            dotData: FlDotData(show: false),                   
                          ),
                            LineChartBarData(
                              spots: spotsAboveStorage,
                              isCurved: true,
                              colors: [Colors.black.withOpacity(0.5)],
                              barWidth: 0.2,
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                show: true,
                                colors: [Colors.blue.withOpacity(0.8)],
                                cutOffY: possibleStorage,
                                applyCutOffY: true,
                              ),
                              dotData: FlDotData(show: false),  
                            ),
                            LineChartBarData(
                              spots: spotsBelowStorage,
                              isCurved: true,
                              colors: [Colors.black.withOpacity(0.5)],
                              barWidth: 0.2,
                              isStrokeCapRound: true,
                              belowBarData: BarAreaData(
                                show: true,
                                colors: [Colors.green.withOpacity(0.8)],
                                cutOffY: 0.00,
                                applyCutOffY: true,
                              ),
                              
                              dotData: FlDotData(show: false),  
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

}


// lineTouchData: LineTouchData(
                        //   touchTooltipData: LineTouchTooltipData(
                        //     tooltipBgColor: Colors.blueAccent,
                        //     getTooltipItems:
                        //         (List<LineBarSpot> touchedBarSpots) {
                        //       return touchedBarSpots.map((barSpot) {
                        //         final flSpot = barSpot;
                        //         final appliancesForHour =
                        //             hourlyAppliances[flSpot.x.toInt()]
                        //                 .join(', ');
                        //         return LineTooltipItem(
                        //           '${flSpot.y}kw\nAppliances used: $appliancesForHour',
                        //           const TextStyle(color: Colors.white),
                        //         );
                        //       }).toList();
                        //     },
                        //   ),
                        //   touchCallback: (LineTouchResponse touchResponse) {},
                        //   handleBuiltInTouches: true,
                        // ),

