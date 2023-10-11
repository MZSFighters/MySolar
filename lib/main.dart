import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysolar/graph/graph.dart';
import 'package:mysolar/themes/CustomTheme.dart';
import 'package:mysolar/features/app/splash_screen/splash_screen.dart';
import 'package:mysolar/features/user_auth/presentation/pages/home_page.dart';
import 'package:mysolar/features/user_auth/presentation/pages/login_page.dart';
import 'package:mysolar/features/user_auth/presentation/pages/sign_up_page.dart';
import 'package:mysolar/weather/current_forecast.dart';
import 'package:mysolar/load_shedding/load_shedding.dart';
import 'package:mysolar/themes/themes.dart';

import 'deviceList.dart';

import 'dart:math';
import 'package:mysolar/models/device.dart';

// ************* mockdata for graph ************ //

// hourly kw in battery
List<double> generateMockData() {
  final random = Random();
  return List.generate(25, (index) {
    double value = random.nextDouble() * 20 - 10;
    return double.parse(value.toStringAsFixed(3));
  });
}

List<double> powerConsumption() {
  List<double> powerUsage = <double>[];
  List<Device> devices = Device.devices;
  PowerUsageTracker put = PowerUsageTracker();
  put.updatePowerUsageForDay(devices);
  DateTime currentDate = DateTime.now();
  for (int hour = 0; hour < 24; hour++) {
    DateTime currentHourTime = currentDate.add(Duration(hours: hour));
    double x = put.getPowerUsageForHour(int.parse(currentHourTime.toString()) -
        int.parse((currentHourTime.add(Duration(hours: hour))).toString()));
    powerUsage.add(x);
  }
  powerUsage.add(0);
  return powerUsage;
}

List<List<String>> appliancesUsage() {
  List<List<String>> all_appliances = [];

  List<Device> devices = <Device>[];
  for (int i = 0; i < Device.devices.length; i++) {
    devices.add(Device.devices[i]);
  }
  DateTime currentDate = DateTime.now();
  PowerUsageTracker put = PowerUsageTracker();
  put.updatePowerUsageForDay(devices);
  for (int hour = 0; hour < 24; hour++) {
    List<String> hourly_appliances = [];
    DateTime currentHourTime = currentDate.add(Duration(hours: hour));
    List<Device> y = put.getDevicesForHour(
        int.parse(currentHourTime.toString()) -
            int.parse((currentHourTime.add(Duration(hours: hour))).toString()));
    for (int i = 0; i < y.length; i++) {
      hourly_appliances.add(y[i].name);
    }
    all_appliances.add(hourly_appliances);
  }
  return all_appliances;
}

final List<double> hourlyKw = powerConsumption();

final List<List<String>> hourlyAppliances = appliancesUsage();

// random applainces used durimg an hour

List<List<String>> generateApplianceData() {
  final List<String> appliances = ["light", "geyser", "wifi", "stove", "oven"];
  final random = Random();

  return List.generate(24, (index) {
    int numberOfAppliances =
        random.nextInt(5) + 1; // At least one appliance and at most 5
    return List.generate(numberOfAppliances,
        (i) => appliances[random.nextInt(appliances.length)]);
  });
}

//final List<List<String>> hourlyAppliances = generateApplianceData();

// ************************ //

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyBmPwbtqEVJyYB0Lpsfj6soG5Vi-ohficA",
        appId: "1:878845743646:web:d95ee7530329012546140f",
        messagingSenderId: "878845743646",
        projectId: "mysolar-72ca5",
        // Your web Firebase config options
      ),
    );
  } else {
    await Firebase.initializeApp();
  }
  runApp(CustomTheme(
    initialThemeKey: MyThemeKeys.BLUE,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase',
      theme: CustomTheme.of(context),
      // theme: ThemeData(
      //   primarySwatch: Colors.deepOrange,  // Set the primary color to deep orange
      //   elevatedButtonTheme: ElevatedButtonThemeData(
      //     style: ElevatedButton.styleFrom(
      //       backgroundColor: Colors.deepOrange,  // Set the ElevatedButton color to deep orange
      //     ),
      //   ),
      // ),
      routes: {
        '/': (context) => SplashScreen(
              // Here, you can decide whether to show the LoginPage or HomePage based on user authentication
              child: LoginPage(),
            ),
        '/login': (context) => LoginPage(),
        '/signUp': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/devices': (context) => SelectDevice(),
        '/weather_pg': (context) => CurrentWeatherPage(),
        '/loadshedding_pg': (context) => LoadShedding(),
        '/graph_pg': (context) => BatteryGraph(
            hourlyKw: powerConsumption(), hourlyAppliances: appliancesUsage()),
      },
    );
  }
}
