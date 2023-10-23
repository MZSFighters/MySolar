import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppWorkings extends StatefulWidget {
  @override
  _AppWorkingsState createState() => _AppWorkingsState();
}

class _AppWorkingsState extends State<AppWorkings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('App Workings')),
      body: ListView(
        children: [
          _buildExpansionTile("The Prediction Graph Algorithm", Icons.show_chart, "assets/your_image1.png"),
          _buildExpansionTile("App Assumptions and Limtitations", Icons.paste_outlined, "assets/your_image2.png"),
          _buildExpansionTile("Notifications", Icons.notifications_none, "assets/your_image3.png"),
        ],
      ),
    );
  }

Widget _buildExpansionTile(String title, IconData? iconData, String imagePath) {
            return ExpansionTile(
              leading: iconData != null ? Icon(iconData) : null,
              title: Text(title),
              children: [
                _getContentBasedOnTitle(title),
              ],
            );
          }

          Widget _getContentBasedOnTitle(String title) {
            if (title == "The Prediction Graph Algorithm") {
              return Column(
                children: [
                  //Image.asset("assets/your_image1.png"),
                  Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                  'The Prediction Graph provides a comprehensive overview of your solar panel system\'s performance over the next 12 hours. At its core, the algorithm predicts the solar output in kilowatts (kW) for each upcoming hour. This prediction is derived from AccuWeather\'s API, which supplies data on solar irradiance and cloud coverage percentages.\nUsing this formula:',
                  style: GoogleFonts.quicksand(  
                    textStyle: TextStyle(
                      color: Colors.blue,  
                      fontSize: 14,  
                      fontWeight: FontWeight.bold,  
                    ),
                  ),
                ),
                  ),
                  Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: '\nSolar panel output',style: TextStyle( decoration: TextDecoration.underline)),
                      TextSpan(text: ' = maxSystemOutput'),
                      TextSpan(text: ' × (1 - '),
                      TextSpan(text: 'cloud coverage/100', style: TextStyle(fontStyle: FontStyle.italic)),
                      TextSpan(text: ') × ('),
                      TextSpan(text: 'solarIrradiance/standardIrradiance', style: TextStyle(fontStyle: FontStyle.italic)),
                      TextSpan(text: ')'),
                    ],
                  ),
                ),
                  ),
                   Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    "\n(Where, StandardIrradiance is the solar irradiance at noon, typically 1000 W/m^2.)",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                 Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                   '\n, the app calculates the potential solar output for each hour. Refer to "App Assumptions and Limitations" on how this power is distributed between the battery and house appliances.',                  
                   style: GoogleFonts.quicksand(  
                    textStyle: TextStyle(
                      color: Colors.blue, 
                      fontSize: 14,  
                      fontWeight: FontWeight.bold, 
                    ),
                  ),
                ),
                  ),
                       Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    '\nFurthermore, the app evaluates the power consumption of each appliance based on their operational schedules and their current status (on/off). This consumption value is then deducted, minute-by-minute, from either the battery storage or the excess solar production over the 12-hour prediction window. \nAs a result, the graph offers insights into three key metrics: predicted solar panel production (in kW), battery power (in kW), and grid usage (in kW).',
                   style: GoogleFonts.quicksand(  
                    textStyle: TextStyle(
                      color: const Color.fromARGB(255, 6, 87, 8),  // Set text color
                      fontSize: 14,  
                      fontWeight: FontWeight.bold, 
                    ),
                  ),
                ),
                  ),
                 SizedBox(height: 8.0), 
                ],
              );
            } else if (title == "App Assumptions and Limtitations") {
              return Column(
                children: [
                  Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "• Inverter System Assumption:",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),               
                      ),
                      Text(
                        "The app operates on the premise that solar panel production feeds into the battery until it's full. Appliances draw power from the battery storage first, and only use current excess solar panel production when the battery is full.",
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8.0), 
                      Text(
                        "• Data Retention Limitation:",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "The app doesn't retain data beyond the 12-hour prediction window, as it lacks access to the current battery storage status in a user's solar system.",
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 8.0), 
                    ],
                  ),
                ),
                ],
              );
            } else {
              return Column(
                children: [
                  Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: Text("There are two types of notifications that the app notifies the user about:\n\n1. When there is loadshedding and they are using grid power. \n\n2. When they are consuming more energy in kw then their maximum inverter capacity.",
                  style: TextStyle(fontSize: 14),
                  ),
                  ),
                  SizedBox(height: 8.0), 
                ],
              );
            }
          }

}
